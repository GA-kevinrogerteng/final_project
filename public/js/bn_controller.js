var BetterNewsApp = angular.module("BetterNewsApp", ["ngRoute"]);

BetterNewsApp.directive('fbRender', function() {
  return function(scope, element, attrs) {
    if (scope.$last) {
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
    // asynchronously load the FB JS SDK:
    (function(d){
    var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement('script'); js.id = id; js.async = true;
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=563048747135539";
    ref.parentNode.insertBefore(js, ref);
    }(document));

    function onAuthChange(response) {
      if (response.status === 'connected') {
        // The response object is returned with a status field that lets the app know the current
        // login status of the person. In this case, we're handling the situation where they 
        // have logged in to the app.
        if (response.authResponse) {
          console.log('Your user ID is ' + response.authResponse.userID);
          console.log('Your accessToken is ' + response.authResponse.accessToken);
          console.log('It expires at ' + response.authResponse.expiresIn);

          $scope.session = {
            uid: response.authResponse.userID,
            t:   response.authResponse.accessToken,
            e:   response.authResponse.expiresIn 
          };

          window.location.hash = '#/posts';
        }
      } else if (response.status === 'not_authorized') {
        // In this case, the person is logged into Facebook, but not into the app, so we call
        // FB.login() to prompt them to do so. 
        // In real-life usage, you wouldn't want to immediately prompt someone to login 
        // like this, for two reasons:
        // (1) JavaScript created popup windows are blocked by most browsers unless they 
        // result from direct interaction from people using the app (such as a mouse click)
        // (2) it is a bad experience to be continually prompted to login upon page load.
        //FB.login(function(response) {}, {scope: 'email,user_likes,read_stream'});

        window.location.hash = '#/login';
      } else {
        // In this case, the person is not logged into Facebook, so we call the login() 
        // function to prompt them to do so. Note that at this stage there is no indication
        // of whether they are logged into the app. If they aren't then they'll see the Login
        // dialog right after they log in to Facebook. 
        // The same caveats as above apply to the FB.login() call here.
        //FB.login(function(response) {}, {scope: 'email,user_likes,read_stream'});

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

      // Here we subscribe to the auth.authResponseChange JavaScript event. This event is fired
      // for any authentication related change, such as login, logout or session refresh. This means that
      // whenever someone who was previously logged out tries to log in again, the correct case below 
      // will be handled. 
      FB.Event.subscribe('auth.authResponseChange', onAuthChange);
      FB.getLoginStatus(onAuthChange);
    }
  };

  if ($scope.session) {
    $scope.updatePosts();
  }

  $scope.updatePosts = function() {
    if ($scope.session) {
      params = $scope.session;
      params['message'] = $scope.message;
      params['fb_type'] = $scope.fb_type;

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


function onAuth(authResponse) {
}

function logout() {
  FB.logout(function(response) {
    window.location.hash = '#/login';
  })
}
