# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ()->
  $('body').off 'click', '[data-toggle-visibility]'
  $('body').on 'click', '[data-toggle-visibility]', (e)->
    $('#' + $(this).attr('data-toggle-visibility')).toggle()
    e.preventDefault()

$(document).ajaxError (event, jqxhr, settings, exception)->
  if jqxhr.status == 401
    window.location.href = Routes.new_user_session_path(from: window.location.pathname)
