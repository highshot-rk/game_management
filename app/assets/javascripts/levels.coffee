$(document).on 'ready page:load', ()->
  $(this).on 'ajax:success', '[data-load-levels]', (e, data, status, xhr) ->
    $('.AreaNotifications').remove()
    $('#Menu').after(data)
