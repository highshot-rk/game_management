$(document).ready ->
  $(document).on 'click', '[data-open-embed]', (e)->
    e.preventDefault()
    id = $(this).data('open-embed')
    $.get Routes.embed_popup_game_path(id), (data) =>
      $(data).appendTo('body')
    false