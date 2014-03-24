var BetterNewsApp = angular.module("BetterNewsApp", ["ngRoute"]);

BetterNewsApp.directive('fbRender', function() {
  return function(scope, element, attrs) {
    if (scope.$last){
      FB.init({
        appId      : '563048747135539',
        status     : true, // check login status
        cookie     : true, // enable cookies to allow the server to access the session
        xfbml      : true  // parse XFBML
      });
      FB.XFBML.parse(document.getElementById(attrs.fbRender));
    }
  };
})


BetterNewsApp.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/login', {
        templateUrl: 'partials/login.html',
        controller: 'BetterNewsController'
      }).
      when('/posts', {
        templateUrl: 'partials/posts.html',
        controller: 'BetterNewsController'
      }).
      when('/posts/:postId', {
        templateUrl: 'partials/post.html',
        controller: 'BetterNewsController'
      }).
      otherwise({
        redirectTo: '/login'
      });
  }]);

function BetterNewsController($scope, $http) {
  $scope.initialize = function() {
  };

  if (session) {
    $scope.updatePosts();
  }

  $scope.updatePosts = function() {
    params = session;
    params['message'] = $scope.message;
    params['fb_type'] = $scope.fb_type;

    $http.get(
      '/posts.json',
      {'params': session}
    ).success(function(data) {
      $scope.posts = data;
      console.log('received posts: ' + $scope.posts.length);
    });
  }
}

var session = null;

function onAuth(authResponse) {
  if (authResponse) {
    console.log('Your user ID is ' + authResponse.userID);
    console.log('Your accessToken is ' + authResponse.accessToken);
    console.log('It expires at ' + authResponse.expiresIn);

    session = {
      uid: authResponse.userID,
      t:   authResponse.accessToken,
      e:   authResponse.expiresIn 
    };

    window.location.hash = '#/posts';
  }
}
