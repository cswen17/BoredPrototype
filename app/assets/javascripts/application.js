// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs

//= require_tree . 

//-------------------------------------------------------------
// global variables and initialization functions for other APIs
// ------------------------------------------------------------

var secrets = {};

window.fbAsyncInit = function() {
  FB.init({
    appId      : secrets["facebook"],
    xfbml      : true,
    version    : 'v2.4'
  });
};

(function(d, s, id){
   var js, fjs = d.getElementsByTagName(s)[0];
   if (d.getElementById(id)) {return;}
   js = d.createElement(s); js.id = id;
   js.src = "//connect.facebook.net/en_US/sdk.js";
   fjs.parentNode.insertBefore(js, fjs);
 }(document, 'script', 'facebook-jssdk'));

var getSecrets = function() {
  $.get('/facebook_secret', function(data, textStatus, jqXHR) {
    secrets["facebook"] = data;
  });
  $.get('/google_secret', function(data, textStatus, jqXHR) {
    secrets["google"] = data;
  });
};

getSecrets();

// ----------------
// helper functions
// ----------------

var formatDateAsMMDDYYSlashes = function(dateString) {
  // formats a datetime as MM/DD/YY, HH:NN (24 hr clock) (date- no padding)
  months = ["January", "February", "March", "April", "May", "June", "July",
            "August", "September", "October", "November", "December"];
  date = new Date(dateString);
  month = months[date.getMonth()];
  day = date.getDate();
  year = date.getFullYear();

  hour = date.getHours();
  minute = date.getMinutes();
  if (minute < 10) minute = "0" + minute;

  return month + " " + day + ", " + year + " " + hour + ":" + minute;
};

$('.flash-dismiss-button').click(function(flashEvent) {
  whoToDismiss = $(flashEvent.target).data('dismiss-target-id');
  $('#' + whoToDismiss).hide();
});


