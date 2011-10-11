//= require fullcalendar/fullcalendar.js

$(document).ready(function() {
  $("#calendar").html("Hello World from jQuery!");
  $("#date").datepicker();
  $("#calendar").fullCalendar({
  });
});
