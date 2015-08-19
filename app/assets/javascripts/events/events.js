// Place all the behaviors and hooks related to the matching 
// controller here.
// All this logic will automatically be available in application.js.

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

});

var attachClickableClass = function (idName) {
  // this function will help make events clickable
  $children = $('#' + idName + ' *');
  for (var i = 0; i < $children.length; i++) {
    $child = $($children[i]);
    $child.addClass('event-clickable');
    $child.attr('data-event-id', idName);
  }
}

