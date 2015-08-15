// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

/* TEMPORARILY REMOVE ISOTOPE
var $container = $('#events');

// Set up isotope on .event
$container.isotope({
  itemSelector: '.event'
});

// Expand event when clicked
$container.delegate('.event', 'click', function() {

  $(this).toggleClass('expanded');
  
  // This causes severe performance issues.
  $container.isotope('reLayout');
});
*/
/*

var App = {
  Views: {},
  Routers: {},
  init: function() {
    new App.Routers.Events();
    Backbone.history.start();
  }
};
*/

var full = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]; // All categories

function updateInfo(node) {
  var infoBar = $('.info-main');
  $('#info-title', infoBar).html($('.event-title', node).html());
  $('#info-desc', infoBar).html($('.event-desc', node).html());
  $('#info-location', infoBar).html($('.event-location', node).html());
  $('#info-date', infoBar).html($('.event-date', node).html());
  $('#info-organization', infoBar).html($('.event-organization', node).html());
  $('#info-url', infoBar).html($('.event-url', node).html());
}

$(function() {
  $('.datepicker').datepicker();
  $('.event').click(function(){
    updateInfo(this);
	$('html, body').animate({ scrollTop: 0 }, "fast", "swing");
  });

  var $flyerUpload = $('#flyer-upload')

  var onFlyerUpload = function onFlyerUpload(fileList) {
    // TODO: Finish this
  }


  var i = 1; 

  init();
  $('li.catname-0').click(function(e){
	toggleAll();
  });

  $('li.catname-1').click(function(e){
	  toggleonClick(1);
      });

  $('li.catname-2').click(function(e){
	  toggleonClick(2);
      });

  $('li.catname-3').click(function(e){
	  toggleonClick(3);
      });

  $('li.catname-4').click(function(e){
	  toggleonClick(4);
      });

  $('li.catname-5').click(function(e){
	  toggleonClick(5);
      });

  $('li.catname-6').click(function(e){
	  toggleonClick(6);
      });

  $('li.catname-7').click(function(e){
	  toggleonClick(7);
      });

  $('li.catname-8').click(function(e){
	  toggleonClick(8);
      });

  $('li.catname-9').click(function(e){
	  toggleonClick(9);
      });
});

$('.field input').focus(function(){
  $(this).parent().addClass('form-focus');
});
$('.field input').blur(function(){
  $(this).parent().removeClass('form-focus');
});

function buttonoff(i) {
    $(".catname-" + (i).toString()).css('background-color', '');
    $(".catname-" + (i).toString()).css('color', 'inherit');
}

function buttonon(i) {
    $(".catname-" + (i).toString()).css('background-color', '#8C0F2E');
    $(".catname-" + (i).toString()).css('color', 'white');
}


// Initialize the page
function init() {
    buttonon(0);
    show_only_cats(full);
    var i = 1; 
    for(i = 1; i <= hashCategories.length; i++) {
    	buttonoff(i);
    }

}

// Toggle button i 
function toggleonClick(i){
    buttonoff(0);
    refresh_cat();
    cat = '.cat-' + (i).toString();
    if ( $(cat).css('display') == "none" 
	|| $(".catname-" + (i).toString()).css('color') != 'rgb(255, 255, 255)'){
	buttonon(i);
	show_cat(i);
    } 
    else{
	buttonoff(i);
	hide_cat(i);
	refresh_cat();
    }
}


// Toggling function for all events
function toggleAll() {	
	var empty = new Array();
	if($(".catname-0").css('color') == 'rgb(255, 255, 255)') {
		buttonoff(0);
        	show_only_cats(empty);
	}
	else {
		buttonon(0);
		init();
		show_only_cats(full);
	}

}

function refresh_cat() {
    var i = 1; 
    hide_all();
    for(i = 1; i <= hashCategories.length; i++) {
	if($(".catname-" + (i).toString()).css('color') == "rgb(255, 255, 255)") {
		show_cat(i);
	}
    }
}

function hide_cat(n){
	cat_string = ".cat-"+n;
	$(cat_string).css('display','none');
}

function show_cat(n){
	cat_string = ".cat-"+n;
	$(cat_string).css('display','inline');
}

//hide all events that have a category
function hide_all() {	

	for(var cur_cat in hashCategories)
	{
		hide_cat(hashCategories[cur_cat][1]);
	}
}

var show_categores = new Array(); //DELETE ME
show_categories = [1,2,3,4]; //DELETE ME

//Takes an array of categories, cats. Displays only events with those categories,
//  and hides all others.
function show_only_cats(cats){
	hide_all();
	
	for(var x in cats){
		show_cat(x);
	}
}

function hide_cat(n){
	cat_string = ".cat-"+n;
	$(cat_string).css('display','none');
}

function show_cat(n){
	cat_string = ".cat-"+n;
	$(cat_string).css('display','inline');
}
