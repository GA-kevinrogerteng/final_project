var BetterNewsApp = angular.module("BetterNewsApp", ["ngRoute"]);

// define an AngularJS directive fb-render
BetterNewsApp.directive('fbRender', function() {
  return function(scope, element, attrs) {
    if (scope.$last) {
      // when invoked on the last of a series of repeating elements, ensure
      // that the parent element (named in the value of the fb-render attribute)
      // gets parsed for XFBML content by Facebok JS SDK
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
      when('/posts/new', {
        templateUrl: '/posts/new',
        controller: 'BetterNewsController'
      }).
      otherwise({
        redirectTo: '/login'
      });
  }]);

function BetterNewsController($scope, $http) {
  $scope.initialize = function() {
    // asynchronously load the FB JS SDK:
    (function(d){
    var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement('script'); js.id = id; js.async = true;
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=563048747135539";
    ref.parentNode.insertBefore(js, ref);
    }(document));

    // process Facebook authentication events
    function onAuthChange(response) {
      if (response.status === 'connected') {
        // the user is logged in to the app
        if (response.authResponse) {
          $scope.session = {
            uid: response.authResponse.userID,
            t:   response.authResponse.accessToken,
            e:   response.authResponse.expiresIn 
          };

          window.location.hash = '#/posts';
        }
      } else if (response.status === 'not_authorized') {
        // the user is logged into Facebook, but not into the app
        window.location.hash = '#/login';
      } else {
        // the user is not logged into Facebook
        window.location.hash = '#/login';
      }
    }

    window.fbAsyncInit = function() {
      FB.init({
        appId      : '563048747135539',
        status     : true, // check login status
        cookie     : true, // enable cookies to allow the server to access the session
        xfbml      : true  // parse XFBML
      });

      // Subscribe to the auth.authResponseChange JavaScript event. This event is fired
      // for any authentication related change, such as login, logout or session refresh.
      FB.Event.subscribe('auth.authResponseChange', onAuthChange);

      // Handle whatever current login status of the user is:
      FB.getLoginStatus(onAuthChange);
    }
  };

  /*
  if ($scope.session) {
    // load the posts
    $scope.updatePosts();
  } */

  $scope.updatePosts = function() {
    if ($scope.session) {
      params = $scope.session;  // include session attributes in HTTP request
      params['message'] = $scope.message; // message substring filter
      params['fb_type'] = $scope.fb_type; // post type filter

      // request posts from the Rails controller
      $http.get(
        '/posts.json',
        {'params': params}
      ).success(function(data) {
        $scope.posts = data;
        console.log('received posts: ' + $scope.posts.length);
      });
    }
  }
}

function logout() {
  FB.logout(function(response) {
    window.location.hash = '#/login';
  })
}
