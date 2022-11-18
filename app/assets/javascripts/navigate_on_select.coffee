$(document).ready ->
  $(document).on 'change', 'select[data-navigate-on-select]', ->
    value = $(this).val()
    $.pjax({ url: value, container: '[data-pjax-container]', timeout: 2000, scrollTo: false })
