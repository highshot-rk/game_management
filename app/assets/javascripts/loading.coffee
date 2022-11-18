$(document).on "ready page:load", () ->
  $('[data-load]').on "click", () ->
    $('.background_black').css("visibility", "visible")

  $('[data-new-form]').on 'ajax:success', () ->
    $('.background_black').css('visibility', 'hidden')
  $('[data-new-form]').on 'ajax:error', () ->
    $('.background_black').css('visibility', 'hidden')

  $('.new_comment').on 'ajax:success', () ->
    $('.background_black').css('visibility', 'hidden')
  $('.new_comment').on 'ajax:error', () ->
    $('.background_black').css('visibility', 'hidden')
