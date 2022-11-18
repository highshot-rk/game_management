$(document).on 'ready page:load', ()->
  $(this).on 'ajax:success', '[data-load-notifications]', (e, data, status, xhr) ->
    $('.AreaNotifications').remove()
    $('#Menu').after(data)
    $('.notific_count').remove()

    $.ajax
      type: 'GET'
      url:  '/notifications/read_all'

    $('body').css('overflow', 'hidden')

  $(this).on 'click', '.mark-read', ->
    $(this).closest('.unread-notifications').removeClass 'unread-notifications'
    return false # This to prevent scroll back to top

  $(this).on 'click', 'a.see-all', (e) ->
    e.preventDefault()

    $(this).hide()
    $(this).prev().show()

    last_id = $('.notifications-list').children().last().attr('data-id')

    $.ajax
      type: 'GET'
      url:  $(this).attr('href')
      data: id: last_id
      dataType: "script",
      success: ->
        $('.loading-gif').hide()
        $('a.see-all').show()

  $(this).on 'click', '[data-close-popup]', (e) ->
    selector = $(this).attr('data-close-popup')
    e.preventDefault();
    $('body').css('overflow', 'auto')
    if $( "div.rateit > div" ).length > 1
      $( "div.rateit div:last-child" ).remove()

  $(this).on 'click', '[data-load-popup], [data-language-select], [data-open-embed]', () ->
    $('body').css('overflow', 'hidden')
