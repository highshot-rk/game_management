$(document).ready ->
  styleTag = $('<style>.js-ready { visibility: visible; }</style>')
  $('html > head').append(styleTag)
