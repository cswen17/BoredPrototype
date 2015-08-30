// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs

//= require_tree . 

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
