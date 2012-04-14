//= require jquery-ui-addresspicker/jquery.ui.addresspicker.js
// require bootstrap-datepicker
//= require jquery-timepicker/jquery.timepicker.js

$(document).ready(function() {
  try {

    var addresspickerMap = $("#event_location").addresspicker({
      mapOptions: {
        center: new google.maps.LatLng(
          //Default location is Paris
          48.856614,
          2.3522219000000177
        )
      },
      elements: {
        map: "#map"
      },
      draggableMarker: false
    });
    var gmarker = addresspickerMap.addresspicker("marker");
    gmarker.setVisible(true);
    addresspickerMap.addresspicker("updatePosition");

  } catch (error) {
    //This happens when maps.google.com cannot be reached
  }
});
