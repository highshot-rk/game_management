// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery.pjax
//= require jquery-ujs
//= require jquery-fileupload
//= require rails.validations
//= require jquery.rateit
//= require js-routes
//= require uri.js.js
//= require moment
//= require moment/locale/de
//= require moment/locale/es
//= require moment/locale/fi
//= require moment/locale/fr
//= require moment/locale/id
//= require moment/locale/it
//= require moment/locale/ja
//= require moment/locale/ko
//= require moment/locale/nl
//= require moment/locale/pl
//= require moment/locale/pt
//= require moment/locale/ru
//= require moment/locale/sv
//= require moment/locale/uk
//= require moment/locale/ms
//= require moment/locale/hi
//= require moment/locale/sk
//= require moment/locale/fa
//= require moment/locale/tl-ph
//= require moment/locale/th
//= require moment/locale/el
//= require moment-timezone
//= require jqueryui-timepicker-addon
//= require_directory .

$(function () {
  return $.ionSound({
    sounds: [
      {
        name: "notification",
      },
    ],
    path: "/sounds/",
    preload: true,
    multiplay: true,
    volume: 0.9,
  });
});
