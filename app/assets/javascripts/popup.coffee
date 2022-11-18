$(document).on 'ready page:load', ->
  $(this).on 'ajax:success', '[data-popup]', (e, data, status, xhr) ->
    selector = $(this).attr('data-popup')
    $(selector).remove()
    $('body').append(data)

  $(this).on 'click', '[data-popup-close]', (e) ->
    selector = $(this).attr('data-popup-close')
    $(selector).remove()
    e.preventDefault();
