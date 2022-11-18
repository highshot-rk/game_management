$(document).on 'click', '[data-show-element]', (e) ->
  selector = $(this).attr('data-show-element')
  $(selector).show()
  $(this).hide()
  e.preventDefault()
  false

$(document).on 'click', '[data-hide-element]', (e) ->
  selector = $(this).attr('data-hide-element')
  $(selector).hide()
  undo_selector = $('a[data-show-element=\'' + selector + '\']')
  $(undo_selector).show()
  e.preventDefault()
  false
