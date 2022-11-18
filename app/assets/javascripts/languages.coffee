$(document).on 'ready page:load', ()->
  $(this).on 'ajax:success', '[data-language-select]', (e, data, status, xhr) ->
    $('.AreaNotifications').remove()
    $('#Menu').after(data)

  $(this).on 'click', '[data-close-language-select]', (e) ->
    $('.AreaNotifications').remove()
    e.preventDefault();
    false
