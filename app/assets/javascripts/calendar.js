//= require fullcalendar/fullcalendar.js
//= require qtip/jquery.qtip.js

$(document).ready(function() {

  $('#mini-calendar').datepicker({
    dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
  }).children().show();

  $('#calendar').fullCalendar({
    //Similar style as the one from Google Calendar

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

    //Otherwise ISO 8601 "2011-10-28T01:22:00Z" is not seen as UTC
    ignoreTimezone: false,

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
      showEventTooltip(event, jsEvent, $(this));
    },

    //Triggered when the user clicks on a day
    //See http://arshaw.com/fullcalendar/docs/mouse/dayClick/
    dayClick: function(date, allDay, jsEvent, view) {
      showNewTooltipEvent(date, allDay, jsEvent, $(this));
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

//Shows the event inside a tooltip using qTip
function showEventTooltip(event, jsEvent, div) {
  div.qtip({
    id: 'event_' + event.id,

    content: {
      title: {
        text: event.title,
        button: true
      },
      text: 'Loading...',
      ajax: {
        url: '/events/' + event.id,
        loading: false //Hide the tooltip whilst the initial content is loaded
      }
    },

    position: {
        my: 'bottom center',
        at: 'top center',
        target: [jsEvent.pageX, jsEvent.pageY],
        viewport: $(window) //Try to keep the tooltip on-screen at all times
    },

    show: {
        //Show the tooltip when event is clicked and tooltip is 'ready' e.g. rendered
        event: 'click',
        ready: true
    },

    //Close the tooltip when it loses focus e.g. anywhere except the tooltip is clicked
    hide: 'unfocus',

    style: {
      classes: 'ui-tooltip-shadow ui-tooltip-rounded',
      widget: true //Use jQuery UI style
    }
  });
}

//Shows new_tooltip view inside a tooltip using qTip
function showNewTooltipEvent(date, allDay, jsEvent, div) {
  div.qtip({
    id: 'new_event',

    content: {
      title: {
        text: 'New event',
        button: true
      },
      text: 'Loading...',
      ajax: {
        url: 'events/new_tooltip',
        loading: false, //Hide the tooltip whilst the initial content is loaded

        //Data to pass along with the request
        data: {
          event: {
            starts_at: date.toUTCString(),
            ends_at: date.toUTCString(),
            all_day: allDay
          }
        }
      }
    },

    position: {
        my: 'bottom center',
        at: 'top center',
        target: [jsEvent.pageX, jsEvent.pageY],
        viewport: $(window) //Try to keep the tooltip on-screen at all times
    },

    show: {
        //Show the tooltip when event is clicked and tooltip is 'ready' e.g. rendered
        event: 'click',
        ready: true
    },

    //Close the tooltip when it loses focus e.g. anywhere except the tooltip is clicked
    hide: 'unfocus',

    style: {
      classes: 'ui-tooltip-shadow ui-tooltip-rounded',
      widget: true //Use jQuery UI style
    }
  });
}
