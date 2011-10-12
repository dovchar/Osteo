//= require fullcalendar/fullcalendar.js

$(document).ready(function() {

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
    }
  });

});
