//= require fullcalendar/fullcalendar.js

$(document).ready(function() {

  $('#mini-calendar').datepicker({
    dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
  }).children().show();

  createShowEventDialog();

  $('#calendar').fullCalendar({
    //Same as in Google Calendar

    header: {
      left: 'today prev,next title',
      center: '',
      right: 'agendaDay,agendaWeek,month'
    },

    //Enables jQuery UI theme
    theme: true,

    //Names in uppercase
    buttonText: {
      today: 'Today',
      month: 'Month',
      week: 'Week',
      day: 'Day'
    },

    editable: 'true',

    ignoreTimezone: false,  //Otherwise ISO 8601 "2011-10-28T01:22:00Z" is not seen as UTC

    events: '/events',

    //Triggered when an event has moved to a different day/time
    //See http://arshaw.com/fullcalendar/docs/event_ui/eventDrop/
    eventDrop: function(event) {
      updateEvent(event);
    },

    //Triggered when an event has changed in duration
    //See http://arshaw.com/fullcalendar/docs/event_ui/eventResize/
    eventResize: function(event) {
      updateEvent(event);
    },

    //Triggered when the user clicks on an event
    //See http://arshaw.com/fullcalendar/docs/mouse/eventClick/
    eventClick: function(event, jsEvent) {
      showEvent(event, jsEvent);
    },

    //Triggered when the user clicks on a day
    //See http://arshaw.com/fullcalendar/docs/mouse/dayClick/
    dayClick: function(date, allDay, jsEvent, view) {
    }
  });

});

//A calendar event has been modified, let's update it
//Sends an AJAX request to the server to update the event inside the database
function updateEvent(event) {
  var start = event.start.toUTCString() //event.start is never null

  var end = event.end
  if (end) {
    end = end.toUTCString()
  } else {
    //event.end can be null if end equals start
    //This will make Rails unhappy so let's set end to a real date instead
    //FIXME end = start
  }

  $.ajax({
    type: 'PUT',
    url: '/events/' + event.id,
    data: {
      event: {
        title: event.title,
        starts_at: start,
        ends_at: end,
        description: event.description
      }
    }
  });
}

//Creates a hidden jQuery UI dialog to use with showEvent()
function createShowEventDialog() {
  var dialog = $('<div id="show_event_dialog"></div>').appendTo('body');
  dialog.dialog({
    modal: true,
    autoOpen: false,
    resizable: false
  });
}

//Shows the event inside a jQuery UI dialog
function showEvent(event, jsEvent) {
  var dialog = $('#show_event_dialog');
  var url = '/events/' + event.id;

  //See http://stackoverflow.com/questions/809035/ajax-jquery-ui-dialog-window-loaded-within-ajax-style-jquery-ui-tabs
  dialog.load(
    url,
    function(responseText, textStatus, XMLHttpRequest) {
      dialog.dialog('option', 'title', event.title);

      //Centers the dialog above the event
      var height = dialog.parent().height();
      var width = dialog.parent().width();
      var posX = jsEvent.pageX - width / 2;
      var posY = jsEvent.pageY - height;
      dialog.dialog('option', 'position', [posX, posY]);

      dialog.dialog('open');

      $('.ui-widget-overlay').click(function() {
        dialog.dialog('close');
        //Prevent the default action, e.g., following a link
        return false;
      });
    }
  );
}
