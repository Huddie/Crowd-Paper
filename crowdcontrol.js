//What follows is an important line. Do not touch! 
Parse.initialize("gUHWjMvMnIIQ7mVpYzXAi1N6N0jBWzlHzOb8SLB9", "UJmHkpp5C4WJ17T63wHtmcoI7eKrfzCFo6X6oLb6");
//Set up Angular like normal.
var crowdPaper = angular.module('crowdPaper', []);

        crowdPaper.controller('crowdControl', function ($scope) {
        //Newus: newuser
          $scope.newus = [];
          //TODO
          for(var i = 0; i<45; i++) {
         $scope.newus.push({'img': 'https://igcdn-photos-a-a.akamaihd.net/hphotos-ak-xaf1/t51.2885-15/11008267_1427055360925656_1037860295_n.jpg',
           'info': 'Fast just got faster with Nexus S.'});
         
       }
        });
//Helper functions
  function logoff() {
          Parse.User.logOut();
          location.reload();
        }
        function switchViews(view) {
          $('.view').css("opacity", "0");
          $(view).css("opacity", "1");
        }
//Page setup          
          $('.parallax').parallax();
          $('.dropdown-button').dropdown({
      inDuration: 300,
      outDuration: 225,
      constrain_width: false, // Does not change width of dropdown to that of the activator
      hover: true, // Activate on click
      alignment: 'right', // Aligns dropdown to left or right edge (works with constrain_width)
      gutter: 0, // Spacing from edge
      belowOrigin: false // Displays dropdown below the button
       }
       );
//Page actions
 $('.validatesignupform').click(function(){
               $('#modal1').openModal();

           var username1 = $("#username1");
           var password1 = $("#password1");
           var user = new Parse.User();
            user.set("username", username1);
            user.set("password", password1);
 
            user.signUp(null, {
              success: function(user) {
              // Hooray! Let them use the app now.
              $('.container').append("Hello, "+username+", nice meeting you!");
            },
            error: function(user, error) {
            // Show the error message somewhere and let the user try again.
            alert("Error: " + error.code + " " + error.message);
            }
          });
         });
         $('.validateform').click(function(){
           var username = $("#username").val();
           var password = $("#password").val();
           Parse.User.logIn(username, password, {
            success: function(user) {
              $("#modal2").openModal();
              $('.container').append("Hello, "+username+", nice to see you back!");
            },
            error: function(user, error) {
              $('.container').append("Error.");
  }
});
         });
$(".newusers").click(function(){
            if(Parse.User.current() !== null) {
              switchViews('.userView');
            }
            else {
              $("#loginmodal").openModal();
            }
          });

       
        
