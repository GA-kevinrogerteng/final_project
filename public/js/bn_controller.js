var BetterNewsApp = angular.module("BetterNewsApp", ["ngRoute"]);

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

    // window.location.href = '/posts?uid=' + authResponse.userID
    //   + '&t=' + authResponse.accessToken
    //   + '&e=' + authResponse.expiresIn;

    window.location.hash = '#/posts';
  }
}
