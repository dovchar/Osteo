// require jquery.ui.autocomplete
// require jquery-ui-addresspicker/jquery.ui.addresspicker.js
// require bootstrap-datepicker
//= require jquery-timepicker/jquery.timepicker.js
//= require jquery.simplecolorpicker.js

$(document).ready(function() {
  $('#event_color').simplecolorpicker();

  var all_day = $('#event_all_day');
  all_day.change(function() {
    var starts_at_time = $('#event_starts_at_time');
    var ends_at_time = $('#event_ends_at_time');
    if (all_day.prop('checked')) {
      starts_at_time.hide();
      ends_at_time.hide();
    } else {
      starts_at_time.show();
      ends_at_time.show();
    }
  });
  all_day.change();
});
