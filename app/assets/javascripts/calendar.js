//= require fullcalendar/fullcalendar.js

$(document).ready(function() {

  $('#mini-calendar').datepicker({
    dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
  }).children().show();

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

    //An event has been moved to a different day/time
    //See http://arshaw.com/fullcalendar/docs/event_ui/eventDrop/
    eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
      updateEvent(event);
    },

    //An event has been resized
    //See http://arshaw.com/fullcalendar/docs/event_ui/eventResize/
    eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
      updateEvent(event);
    }
  });

});

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
