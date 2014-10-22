// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require c3
//= require_tree .

var toggleWaterSystemDetail = function() {
  $('#water-system-detail').toggleClass('visible');

  var reservoirSummaryChart = c3.generate({
    bindto: '#reservoir-summary-chart',
    data: {
      columns: [
        ['Current Supply', 30.0]
      ],
      type: 'gauge'
    },
    tooltip: {
      show: false
    },
    gauge: {
      min: 0,
      max: 100,
      units: ' %'
    },
    color: {
      pattern: ['#C56E4F', '#DBBA65', '#7FAD78', '#718AA5', '#4D5D73'],
      threshold: {
        values: [20, 40, 60, 80, 100]
      }
    }
  });
}

$(document).ready(function() {
  $('.js-toggle-water-system-detail').on('click', function(e) {
    e.preventDefault();
    toggleWaterSystemDetail();
  });
});
