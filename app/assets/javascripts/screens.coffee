$(document).on 'ready', ->
  remove_all = ->
    $('#screen_overlay').remove()
    $(document).off 'keydown', remove_on_key_down

  remove_on_key_down = (e)->
    if (e.keyCode == 27)
      remove_all()

  $(document).off 'click', '[data-zoom-image]'
  $(document).on 'click', '[data-zoom-image]', ->
    remove_all()
    new_image = $(this).attr('data-zoom-image')

    $(document).on 'keydown', remove_on_key_down

    img = $("<img src=\"#{new_image}\">").click (e)->
      e.preventDefault()
      false
    $('<div id="screen_overlay">')
      .click remove_all
      .append(img)
      .appendTo($('body'))
