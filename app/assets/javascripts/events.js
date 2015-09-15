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
  $('.placeholder-everything-else-container').focus();
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

  $('#paper-fake-tab').click(function(fakeEvent) {
    fakeEvent.stopImmediatePropagation();
    fakeTabHref = $(fakeEvent.target).attr('href');
    window.location = fakeTabHref;
  });

  // this code sets up the tabs for category and time filtering
  $('.paper-tab-base').click(function(tabEvent) {
    $('.paper-tab-base').removeClass('paper-tab-base-clicked');
    $targetTab = $(tabEvent.target);
    $targetTab.addClass('paper-tab-base-clicked');
    targetedButtonsSelector = '.' + $targetTab.data('target-buttons'); 
    targetedHideButtonsSelector = 'button:not('
      + targetedButtonsSelector + ')';
    $(targetedButtonsSelector).show();
    $(targetedHideButtonsSelector).hide();
  });

  // this code sets up category filtering
  $('.paper-category-button').click(function(categoryEvent) {
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

  // this code sets up time category filtering.
  // I'm sorry for the redundancy :'(
  $('.paper-time-category-button').click(function(timeEvent) {
    timeEvent.preventDefault();
    $timeButton = $(timeEvent.target);

    curr = $timeButton.data('curr-class');
    toggle = $timeButton.data('toggle-class');

    $timeButton.removeClass(curr);
    $timeButton.addClass(toggle);

    $timeButton.data('curr-class', toggle);
    $timeButton.data('toggle-class', curr);

    // this code will filter the events
    filterTimeCategories($timeButton, (curr === 'clicked'));
  });

  var filterTimeCategories = function($timeButton, shouldHide) {
    // so slow...
    timeId = $timeButton.attr('id');
    $events = $('.event-card-base');
    for (var i = 0; i < $events.length; i++) {
      $candidateEvent = $($events[i]);
      dataTimeIds = $candidateEvent.data('event-time-categories');
      for (var j = 0; j < dataTimeIds.length; j++) {
        if (dataTimeIds[j] == timeId) {
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

  $('.core-fixed-height-base-sheet').css({
    'width': ($windowWidth - $drawerWidth) + 'px'
  });

  $('.core-contents-height-base-sheet').css({
    'width': ($windowWidth - $drawerWidth) + 'px'
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

    $preview = $('.event-form-image-preview');

    reader = new FileReader();
    reader.onload = (function(unusedParameter) {
      return function(evt) {
        $preview.empty();
        $preview.attr('src', evt.target.result);
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

  // on document init:
  floatingLabels = $('.core-floating-label, .core-floating-textarea-label');
  for (var i = 0; i < floatingLabels.length; i++) {
    $label = $(floatingLabels[i]);
    $textInput = $label.siblings('.core-form-text-input');
    $textArea = $label.siblings('.core-form-textarea');

    // check which one we're dealing with
    $matchedTextParent = null;
    if ($textInput.length > 0) {
      $matchedTextParent = $textInput;
    } else if ($textArea.length > 0) {
      $matchedTextParent = $textArea;
    } else {
      continue;
    }

    // check if the input is empty
    if ($matchedTextParent.text().length > 0 || 
          $matchedTextParent.val().length > 0) {
      // if it is we change our css to top: 0, font-size: 12px
      $label.css({
        'font-size': '12px',
        'top': 0,
      });
    } else {
      $label.css({
        'font-size': '16px',
        'top': '10px',
      });
    }
  }

  // event listeners
  $('.core-form-text-input').on('click focus', function(textFieldClick) {
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

  $('.core-form-textarea').on('click focus', function(textareaClick) {
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

  // this code dismisses error messages
  $('.create-event-errors-dismiss-button').click(function(dismissEvent) {
    whoToDismiss = $(dismissEvent.target).data('dismiss-target-id');
    $('#' + whoToDismiss).slideUp();
  });

  // this code shows a tooltip for flyer uploads
  $('.flyer-upload').mouseenter(function(mouseEnterEvent) {
    $('#tooltip-flyer-upload').css({
      'position': 'fixed',
      'top': (mouseEnterEvent.pageY) + 'px',
      'left': (mouseEnterEvent.pageX) + 'px',
      'z-index': '150'
    }).show();
  }).mouseleave(function(mouseLeaveEvent) {
    $('#tooltip-flyer-upload').hide();
  });

  // ------------------------------------------
  // facebook events and their helper functions
  // ------------------------------------------

  var transformEventsDataList = function(listEventsData) {
    // this function will take the result of calling the FB
    // API's <user_id>/events endpoint, which is a list of
    // objects that contain event IDs, and returns a list of
    // Event objects that contain relevant fields to Teudu:
    // name, location, start, end, description, and cover pic!
    if (!listEventsData) {
      return listEventsData;
    }

    // this loop will extract event IDs which we use to fetch
    // event data from the FB API
    var eventIdsList = [];
    for (var i = 0; i < listEventsData.length; i++) {
      currEvent = listEventsData[i];
      if (currEvent && currEvent.id) {
        eventIdsList.push(currEvent.id);
      }
    }

    $('body').append('<div class="core-modal-scrim"></div>')
             .append(
      '<div class="core-modal-base" id="facebook-events-list"></div>');
    fbEventsList = $('#facebook-events-list');

    $coreModalBaseWidth = $('.core-modal-base').width();
    $('.core-modal-base').css({
      'top': '56px',
      'left': ($windowWidth - $coreModalBaseWidth) / 2 + 'px'
    });

    $('.core-modal-scrim').click(function(scrimClickEvent) {
      $(scrimClickEvent.target).remove();
      $('#facebook-events-list').remove();
    });

    // this loop will collect FB API results for each ID from earlier
    eventsList = [];
    eventsList = eventIdsList.map(function(currentValue, index, array) {
      // currentValue is the same as listEventsData[index]
      fbEventId = currentValue;
      fieldsQueryString = '?fields=cover,description,start_time,' +
        'end_time,name,id,location';
      FB.api(
        '/' + fbEventId + fieldsQueryString,
        function(fbEventNodeResponse) {
          renderFacebookEvent(fbEventNodeResponse);
        }
      );
    });
  };

  var renderFacebookEvent = function(eventData) {
      eventDataId = 'fb-event-' + eventData.id;
      $listBase = $(document.createElement('button'));
      $listBase.addClass('paper-list-base');
      $listBase.attr('id', eventDataId);

      var locationName = '(No Location Specified)';
      if (eventData.place) {
        locationName = eventData.place.name;
      }
      if (eventData.location) {
        locationName = eventData.location;
      }

      coverImageSourceUrl = '/flyers/original/cmuthemall.jpg';
      if (eventData.cover && eventData.cover.source) {
        coverImageSourceUrl = eventData.cover.source;
      }

      listIcon = '<div class="paper-list-icon-area fb-click" data-fb-id="'
        + eventDataId
        + '"><img src="'
        + coverImageSourceUrl
        + '" class="paper-list-icon fb-click" /></div>';
      nameSubtitle = '<p class="paper-list-title fb-click" data-fb-id="'
        + eventDataId
        + '">'
        + eventData.name
        + ' at '
        + locationName;
        + '</p>';
      timeSubtitle = '<p class="paper-list-subtitle fb-click" data-fb-id="'
        + eventDataId
        + '">' 
        + formatDateAsMMDDYYSlashes(eventData.start_time)
        + ' to '
        + formatDateAsMMDDYYSlashes(eventData.end_time)
        + '</p>';
      descSubtitle = '<p class="paper-list-subtitle fb-click" data-fb-id="' 
        + eventDataId
        + '">'
        + eventData.description
        + '</p>';

      $listBase.append(listIcon);

      $listContentArea = $(
        '<div class="paper-list-content-area fb-click" data-fb-id="'
        + eventDataId
        + '"></div>'
      );
      $listContentArea.append(
        nameSubtitle,
        timeSubtitle,
        descSubtitle
      );

      $listBase.append($listContentArea);


      $listBase.attr('data-fb-raw-event-data', JSON.stringify(eventData));

      fbEventsList.append($listBase);
  };

  var retrieveFacebookEvents = function(loginResponse) {
    // Get the user's id
    fbCurrentUserId = loginResponse.authResponse.userID;

    // Get the user's events
    fbUserEventsEndpoint = '/' + fbCurrentUserId + '/events';
    FB.api(fbUserEventsEndpoint, function(userEventsResponse) {
      if (userEventsResponse && !userEventsResponse.error) {
        transformEventsDataList(userEventsResponse["data"]);
      } else {
        console.log('could not fetch facebook user events');
      }
    });
  };

  $('#import-facebook-event').click(function(facebookEvent) {
    FB.getLoginStatus(function (loginResponse) {
      if (!loginResponse) {
        console.log('fetched an empty login response from facebook');
        return;
      }
      if (loginResponse.status != 'connected') {
        FB.login(function(loginResponse) {
          if (loginResponse && loginResponse.status === 'connected') {
            retrieveFacebookEvents(loginResponse);
          }
        }, {scope: 'user_events'});
      }
      retrieveFacebookEvents(loginResponse);
    });
  });

  // this handler will prefill our Create an Event form with facebook
  // event data if someone is using the Import Facebook Event feature
  $('body').on('click', '.fb-click', function(listEvent) {
    $clickTarget = $(listEvent.target);
    $listBase = $('#' + $clickTarget.data('fb-id'));
    eventData = $listBase.data('fb-raw-event-data');
    if (!eventData) {
      return;
    }

    eventLocation = '(No Location Specified)';
    if (eventData && eventData.location) {
      eventLocation = eventData.location;
    }
    eventStart = new Date(eventData.start_time);
    eventEnd = eventStart;
    if (eventData.end_time) {
      eventEnd = new Date(eventData.end_time);
    }
    eventStartHours = "" + eventStart.getHours();
    if (eventStart.getHours() < 10) {
      eventStartHours = "0" + eventStartHours;
    }
    eventStartMinutes = "" + eventStart.getMinutes();
    if (eventStart.getMinutes() < 10) {
      eventStartMinutes = "0" + eventStartMinutes;
    }
    eventEndHours = "" + eventEnd.getHours();
    if (eventEnd.getHours() < 10) {
      eventEndHours = "0" + eventEndHours;
    }
    eventEndMinutes = "" + eventEnd.getMinutes();
    if (eventEnd.getMinutes() < 10) {
      eventEndMinutes = "0" + eventEndMinutes;
    }

    // name
    $('#event_name').val(eventData.name);
    $('[for*="event_name"]').css({
      'top': 0,
      'font-size': '12px'
    });

    // location
    $('#event_location').val(eventLocation);
    $('[for*="event_location"]').css({
      'top': 0,
      'font-size': '12px'
    });

    // start time
    $('#event_event_start_1i').val(eventStart.getFullYear());
    $('#event_event_start_2i').val(eventStart.getMonth() + 1);
    $('#event_event_start_3i').val(eventStart.getDate());
    $('#event_event_start_4i').val(eventStartHours);
    $('#event_event_start_5i').val(eventStartMinutes);

    // end time
    $('#event_event_end_1i').val(eventEnd.getFullYear());
    $('#event_event_end_2i').val(eventEnd.getMonth() + 1);
    $('#event_event_end_3i').val(eventEnd.getDate());
    $('#event_event_end_4i').val(eventEndHours);
    $('#event_event_end_5i').val(eventEndMinutes);

    // description
    $('#event_description').val(eventData.description);
    $('[for*="event_description"]').css({
      'top': 0,
      'font-size': '12px'
    });

    // url
    $('#event_url').val('https://www.facebook.com/events/' + eventData.id);
    $('[for*="event_url"]').css({
      'top': 0,
      'font-size': '12px'
    });

    // loose ends
    $('.event-form-image-preview').attr('src', eventData.cover.source);
    $('.core-modal-base').remove();
    $('.event-modal-scrim').remove();
    $('#is-facebook-event').val('true');
    $('#facebook-cover-url').val(eventData.cover.source);
  });

  $('#fb-logout').click(function(clickEvent) {
    clickEvent.preventDefault();
    FB.logout(function(response) {
      alert('You have been logged out of facebook');
    });
  });

  // ----------------------
  // google calendar events
  // ----------------------
  $('#import-google-calendar-event').click(function (gCalEvent){
    gapi.auth.authorize({
      client_id: secrets["google"].client_id,
      scope: ['https://www.googleapis.com/auth/calendar.readonly'],
      immediate: false
    }, function(authResult){
      if (authResult && !authResult.error) {
        // load calendar events
        gapi.client.load('calendar', 'v3', function(){
          var request = gapi.client.calendar.events.list({
            'calendarId': 'primary',
            'timeMin': (new Date()).toISOString(),
            'showDeleted': false,
            'singleEvents': true,
            'orderBy': 'startTime'
          });

          request.execute(function (resp){
            $('body').append('<div class="core-modal-scrim"></div>')
                     .append(
              '<div class="core-modal-base" id="gcal-events-list"></div>');
            gCalEventsList = $('#gcal-events-list');

            $coreModalBaseWidth = $('.core-modal-base').width();
            $('.core-modal-base').css({
              'top': '56px',
              'left': ($windowWidth - $coreModalBaseWidth) / 2 + 'px'
            });

            $('.core-modal-scrim').click(function(scrimClickEvent) {
              $(scrimClickEvent.target).remove();
              $('#gcal-events-list').remove();
            });

            var events = resp.items;

            if (events.length > 0) {
              // Go through the process of rendering a clickable list
              // and when you click on a list item then the event
              // creation form automatically gets populated

              eventsLen = events.length;
              // gCalEventsList.append($gCalListBase);

              for (var i = 0; i < eventsLen; i++) {
                var gCalEventData = events[i];
                var gCalEventId = gCalEventData.id;
                var gCalEventName = gCalEventData.summary;
                var gCalEventLocation = gCalEventData.location;
                var gCalEventStart = gCalEventData.start.dateTime;
                var gCalEventEnd = gCalEventData.end.dateTime;
                var gCalEventDescription = gCalEventData.description;

                $gCalListBase = $(document.createElement('button'));
                $gCalListBase.addClass('paper-list-base');
                $gCalListBase.attr('id', gCalEventId);

                namePTag = '<p class="paper-list-title g-clickable">'
                    + gCalEventName + '</p>';
                timeLocPTag = '<p class="paper-list-subtitle g-clickable">'
                    + formatDateAsMMDDYYSlashes(gCalEventStart)
                    + ' to '
                    + formatDateAsMMDDYYSlashes(gCalEventEnd)
                    + ' at ' + gCalEventLocation + '</p>';
                descPTag = '<p class="paper-list-subtitle g-clickable">'
                    + gCalEventDescription + '</p>';

                $contentArea = $('<div class="paper-list-content-area" '
                    + ' data-gcal-id="' + gCalEventId + '"></div>');

                $contentArea.append(namePTag, timeLocPTag, descPTag);
                $gCalListBase.append($contentArea);
                $gCalListBase.attr('data-gcal-raw-event-data',
                  JSON.stringify(gCalEventData));

                gCalEventsList.append($gCalListBase);

                // Click listener for this event
                $gCalListBase.click(function(gCalClickEvent) {
                  gCalClickEvent.preventDefault();
                  gCalEvent = $(gCalClickEvent.target);
                  
                  // remove the gCalEventsList modal
                  gCalEventsList.remove();
                  $('.core-modal-scrim').remove();

                  // prefill the gcal event data
                  gCalRawEventData = gCalEvent.data('gcal-raw-event-data');
                  if (!gCalRawEventData) {
                    gParent = gCalEvent.parent('.paper-list-content-area');
                    gGrandParent = gParent.parent('.paper-list-base');

                    gCalRawEventData = gGrandParent.data(
                      'gcal-raw-event-data'
                    );
                  }
                  gName = gCalRawEventData.summary;
                  gLoc = gCalRawEventData.location;
                  gStart = new Date(gCalRawEventData.start.dateTime);
                  gEnd = new Date(gCalRawEventData.end.dateTime);
                  gDesc = gCalRawEventData.description;

                  gStartHours = "" + gStart.getHours();
                  if (gStart.getHours() < 10) {
                    gStartHours = "0" + gStartHours;
                  }
                  gStartMinutes = "" + gStart.getMinutes();
                  if (gStart.getMinutes() < 10) {
                    gStartMinutes = "0" + gStartMinutes;
                  }
                  gEndHours = "" + gEnd.getHours();
                  if (gEnd.getHours() < 10) {
                    gEndHours = "0" + gEndHours;
                  }
                  gEndMinutes = "" + gEnd.getMinutes();
                  if (gEnd.getMinutes() < 10) {
                    gEndMinutes = "0" + gEndMinutes;
                  }


                  // name
                  $('#event_name').val(gName);
                  $('[for*="event_name"]').css({
                    'top': 0,
                    'font-size': '12px'
                  });

                  // location
                  $('#event_location').val(gLoc);
                  $('[for*="event_location"]').css({
                    'top': 0,
                    'font-size': '12px'
                  });

                  // start time
                  $('#event_event_start_1i').val(gStart.getFullYear());
                  $('#event_event_start_2i').val(gStart.getMonth() + 1);
                  $('#event_event_start_3i').val(gStart.getDate());
                  $('#event_event_start_4i').val(gStartHours);
                  $('#event_event_start_5i').val(gStartMinutes);

                  // end time
                  $('#event_event_end_1i').val(gEnd.getFullYear());
                  $('#event_event_end_2i').val(gEnd.getMonth() + 1);
                  $('#event_event_end_3i').val(gEnd.getDate());
                  $('#event_event_end_4i').val(gEndHours);
                  $('#event_event_end_5i').val(gEndMinutes);

                  // description
                  $('#event_description').val(gDesc);
                  $('[for*="event_description"]').css({
                    'top': 0,
                    'font-size': '12px'
                  });
                  
                });
              }
            }
          });
        });
        
      } else {
        // 'I could not log you in to Google Calendar'
        // crud, it says in the docs that we need to give the user
        // a chance to log in. todo.
      }
    });
  });

});
