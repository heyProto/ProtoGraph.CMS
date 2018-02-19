// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require ./vendors/jquery.min.js
//= require ./vendors/popper.min.js
//= require ./vendors/bootstrap.min.js
//= require ./vendors/jquery.noty.packaged.min.js
//= require ./app/notiy
//= require turbolinks
//= require best_in_place
// For use with color thief
//= require ./vendors/quantize.js
//= require ./vendors/color-thief.min.js
//= require ./vendors/select2.full.min.js
//= require jquery-ui
//= require best_in_place.jquery-ui


$(document).on('turbolinks:load', function (e) {
  // $('.ui.dropdown').dropdown();
  // $('.ui.checkbox').checkbox();
  // $('.ui.radio.checkbox').checkbox();
  $('select.dropdown').dropdown();
  // $('.ui.accordion').accordion();
  $(".best_in_place").best_in_place();
});
