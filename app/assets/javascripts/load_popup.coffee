$(document).on 'ready page:load', ()->
  $(this).on 'ajax:success', '[data-load-popup]', (e, data, status, xhr) ->
    $('.AreaNotifications').remove()
    $('#Menu').after(data)

  $(this).on 'click', '[data-close-popup]', (e) ->
    $('.AreaNotifications').remove()
