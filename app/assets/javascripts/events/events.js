// Place all the behaviors and hooks related to the matching 
// controller here.
// All this logic will automatically be available in application.js.
var currRowMaxChars = 48;
var currRow = 1;

var attachClickableClass = function(idName) {
  // this function will help make events clickable
  $children = $('#' + idName + ' *');
  for (var i = 0; i < $children.length; i++) {
    $child = $($children[i]);
    $child.addClass('event-clickable');
    $child.attr('data-event-id', idName);
  }
}

$(document).ready(function() {
  eventCards = $('.event-card-base');
  // this code will make events clickable
  for (var i = 0; i < eventCards.length; i++) {
    cardId = $(eventCards[i]).attr('id').toString();
    attachClickableClass(cardId); 
  }

  // this code listens for clicked events
  $('.event-clickable').on('click', function(clickEvent) {
    clickEvent.stopPropagation();

    // this code associates the event id of the clicked card to the modal
    clickedEventId = $(clickEvent.target).data('event-id');
    modalEventSelector = '#modal-' + clickedEventId;
    $eventModal = $(modalEventSelector);
    $eventModal.wrap('<div class="event-modal-scrim"></div>');

    // this code brings up the scrim
    $scrim = $('.event-modal-scrim');
    $scrim.show();
    $eventModal.css({
      'z-index': '100',
      'position': 'fixed',
      'top': (($(window).height() / 2) - ($eventModal.height() / 2)) + 'px',
      'left': (($(window).width() / 2) - ($eventModal.width() / 2)) + 'px'
    });
    $eventModal.show();

    $scrim.click(function(scrimEvent) {
        $eventModal.unwrap();
        $scrim.detach();
        $('.event-modal-base').hide();
    });
  }); // end event card on click handler

  // this code is supposed to set up category filtering
  // but we really need to find a way to distinguish any
  // old paper-button from a category paper button
  $('.paper-button').click(function(categoryEvent) {
    categoryEvent.preventDefault();
    $categoryButton = $(categoryEvent.target);

    curr = $categoryButton.data('curr-class');
    toggle = $categoryButton.data('toggle-class');

    $categoryButton.removeClass(curr);
    $categoryButton.addClass(toggle);

    $categoryButton.data('curr-class', toggle);
    $categoryButton.data('toggle-class', curr);

    // this code will filter the events
    filterCategories($categoryButton, (curr === 'clicked'));
  });

  var filterCategories = function($categoryButton, shouldHide) {
    // so slow...
    categoryId = $categoryButton.attr('id');
    $events = $('.event-card-base');
    for (var i = 0; i < $events.length; i++) {
      $candidateEvent = $($events[i]);
      dataCategoryIds = $candidateEvent.data('event-categories');
      for (var j = 0; j < dataCategoryIds.length; j++) {
        if (dataCategoryIds[j] == categoryId) {
          if (shouldHide) {
            $candidateEvent.hide();
          } else {
            $candidateEvent.show();
          }
          break;
        }
      }
    }
  };

  // base
  $windowHeight = $(window).height();
  $windowWidth = $(window).width();
  $drawerWidth = $('.core-drawer-base').width();
  $inputFormGroupWidth = $('.event-form-input-group').width();
  $headerHeight = $('.core-header').height();
  $actionGroupHeight = $('.event-form-action-group').height();

  // derived
  $eventFormWidth = $windowWidth - $inputFormGroupWidth - $drawerWidth;
  $eventFormHeight = $windowHeight - $headerHeight - $actionGroupHeight;

  $('.core-right-primary-raised-sheet').css({
    'height': ($eventFormHeight - 64)  + 'px',
    'width': ($eventFormWidth - 32) + 'px'
  });
  $('.core-base-sheet').css({
    'width': ($windowWidth - $drawerWidth) + 'px',
    'height': ($windowHeight - $headerHeight - 16) + 'px'
  });

  $('.core-header').css('width', ($windowWidth - $drawerWidth) + 'px');

  $('.core-footer').css('width', ($windowWidth - $drawerWidth) + 'px')

  $('.event-form-action-group').css({
    'top': ($windowHeight - 98) + 'px',
    'width': ($eventFormWidth - 16) + 'px',
    'height': ($windowHeight - $headerHeight - $actionGroupHeight) + 'px',
    'padding-right': '16px'
  });

  $('.event-form-input-group').css({
    'height': ($windowHeight - $headerHeight) + 'px'
  });

  $('#event_flyer_url').css({
    'color': 'rgba(0, 0, 0, 0.87)'
  });

  $('#event_flyer_url').on('change', function(changeEvent) {
    $fileFieldTarget = changeEvent.target;
    file = $fileFieldTarget.files[0];

    $preview = $('.event-form-flyer-preview');

    reader = new FileReader();
    reader.onload = (function(unusedParameter) {
      return function(evt) {
        $preview.empty();
        $preview.append('<img src="' + evt.target.result + '" class="event-image-preview"></img>');
      };
    }($preview));
    reader.readAsDataURL(file);

  });

  $('.core-checkbox-and-label-pair').mousedown(function(checkboxEvent) {
    $checkbox = $(checkboxEvent.target);
    cbWrappers = $checkbox.parent('.checkbox-wrapper-for-ripple'); 

    if (cbWrappers.length == 0) {
      cbWrappers = $checkbox.siblings('.checkbox-wrapper-for-ripple');
      if (cbWrappers.length == 0) {
        return;
      }
    }
   
    $cbRipple = $(cbWrappers[0]);
    $cbRipple.addClass('checkbox-rippled');
    window.setTimeout(function clearRipple() {
      $cbRipple.removeClass('checkbox-rippled');
    }, 250);
  });

  // -----------------------------------------------------
  // floating label effects for text fields and text areas
  // -----------------------------------------------------

  $('.core-form-text-input').click(function(textFieldClick) {
    $textFieldInput = $(textFieldClick.target);
    $floatingLabel = $textFieldInput.siblings('.core-floating-label');

    if ($floatingLabel.length < 1) {
      return;
    }

    $floatingLabel.animate({
      'font-size': '12px',
      'top': '0',
      'color': '#727272'
    });

    $textFieldInput.focusout(function(textFieldEvent) {
      if ($(textFieldEvent.target).val() === '') {
        $floatingLabel.animate({
          'font-size': '16px',
          'top': '10px',
          'color': '#ffffff'
        });
      }
    });

  });


  $('.core-form-textarea').keyup(function(keyEvent) {
    $textarea = $(keyEvent.target);
    if ($textarea.val().length < currRowMaxChars) {
      return;
    }

    // else
    currRow += 1;
    currRowMaxChars += 48;

    $pairDiv = $textarea.parent('.core-text-field-and-label-pair');
    if ($pairDiv.length < 1) {
      return;
    }
    $pairDiv.animate({
      'height': '+=16'
    });
    $textarea.animate({
      'height': '+=16'
    });
  });

  $('.core-form-textarea').click(function(textareaClick) {
    $textareaInput = $(textareaClick.target);
    $floatingLabel = $textareaInput.siblings(
      '.core-floating-textarea-label');

    if ($floatingLabel.length < 1) {
      return;
    }

    $floatingLabel.animate({
      'font-size': '12px',
      'top': '0',
      'left': '8px',
      'color': '#727272'
    });

    $textareaInput.focusout(function(textareaEvent) {
      if ($(textareaEvent.target).val() === '') {
        $floatingLabel.animate({
          'font-size': '16px',
          'top': '10px',
          'color': '#ffffff'
        });
      }

      // else
      currRow = 1;
      currRowMaxCharacters = 48;
    });
  });


});


