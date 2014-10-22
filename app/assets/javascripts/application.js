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
//= require handlebars-v2.0.0
//= require c3
//= require_tree .

var generateWSSummaryChart = function(currentSupplyPercentage) {
  c3.generate({
    bindto: '#water-system-summary__chart',
    data: {
      columns: [
        ['Current Supply', currentSupplyPercentage]
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
};

var generateWSDetailChart = function(chartData) {
  c3.generate({
    bindto: '#water-system-detail__reservoirs-chart',
    data: {
      columns: chartData,
      type: 'bar'
    },
    tooltip: { show: false },
    axis: {
      rotated: true,
      x: {
        show: false
      }
    },
    color: {
      pattern: ['#718AA5', '#7FAD78']
    },
    legend: {
      show: false
    }
  })
};

var renderWSTemplate = function(waterSystem) {
  var source = $('#water-system-detail-template').html();
  var template = Handlebars.compile(source);
  var html = template(waterSystem);
  $('#water-system-detail').html(html);
};

var showWaterSystemDetail = function(waterSystemName) {
  var path = '/water_system/' + waterSystemName
  var waterSystemXhr = $.ajax(path).done(function(waterSystem) {
    renderWSTemplate(waterSystem)
    generateWSSummaryChart(waterSystem.current_supply_percentage);
    generateWSDetailChart(waterSystem.reservoir_chart_data);
    $('#water-system-detail').addClass('visible');
  })
};

var hideWaterSystemDetail = function() {
  $('#water-system-detail').removeClass('visible');
}

$(document).ready(function() {
  $('.js-toggle-water-system-detail').on('click', function(e) {
    e.preventDefault();
    toggleWaterSystemDetail();
  });
});
