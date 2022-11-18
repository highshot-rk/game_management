$(document).on 'ready', ->
  body = $('body')
  body.off 'click', '[data-analytics-click]'
  body.on 'click', '[data-analytics-click]', (e)->
    if (window.ga)
      window.ga('send', 'event', $(this).attr('data-analytics-click'), 'click', $(this).attr('href'))

  body.off 'submit', '[data-analytics-submit]'
  body.on 'submit', '[data-analytics-submit]', (e)->
    if (window.ga)
      window.ga('send', 'event', $(this).attr('data-analytics-submit'), 'submit')
