// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery-ui-timepicker/jquery-ui-timepicker-addon.js
//= require jquery-ui-addresspicker/jquery.ui.addresspicker.js

$(document).ready(function() {
  var addresspickerMap = $("#event_location").addresspicker({
    elements: {
      map: "#map"
    }
  });
  var gmarker = addresspickerMap.addresspicker("marker");
  gmarker.setVisible(true);
  addresspickerMap.addresspicker("updatePosition");
});
