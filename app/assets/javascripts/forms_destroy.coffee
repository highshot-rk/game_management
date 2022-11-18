$(document).ready ->

  update_hidden_show = ->
    parent = $(this).parent()
    if $(this).is(':checked')
      parent.siblings('[data-hide-on-destroy]').hide()
      parent.children('[data-form-destroy-message]').hide()
      parent.children('[data-form-restore-message]').show()
    else
      parent.siblings('[data-hide-on-destroy]').show()
      parent.children('[data-form-destroy-message]').show()
      parent.children('[data-form-restore-message]').hide()

  $("[data-form-destroy-button] > input[type=checkbox]")
    .each(update_hidden_show).change(update_hidden_show)
