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
//= ./vendors/jquery.min.js
//= ./vendors/semantic.min.js
//= require turbolinks
//= require_tree .
//= require best_in_place

$(document).on('turbolinks:load', function (e) {
  $('.ui.dropdown').dropdown();
  $('.ui.checkbox').checkbox();
  $('.ui.radio.checkbox').checkbox();
  $('select.dropdown').dropdown();
  $('.ui.accordion').accordion();
  $(".best_in_place").best_in_place();
});