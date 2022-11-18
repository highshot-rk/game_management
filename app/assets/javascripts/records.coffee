class RecordClient
  constructor: (key) ->
    @key = key

  sendScore: (score) ->
    $.ajax
      url: Routes.api_v1_score_path(format: 'json'),
      type: 'post',
      data: {
        score: score
      },
      headers: {
        "Authentication": "bearer #{@key}",
      },
      dataType: 'json'

  getUser: () ->
    $.ajax
      url: Routes.api_v1_user_path(format: 'json'),
      type: 'get',
      headers: {
        "Authentication": "bearer #{@key}",
      },
      dataType: 'json'

  getScores: () ->
    $.ajax
      url: Routes.api_v1_scores_path(format: 'json'),
      type: 'get',
      headers: {
        "Authentication": "bearer #{@key}",
      },
      dataType: 'json'

$(document).off('play-online').on 'play-online', (e, element) ->
  domain_name = window.location.hostname.replace('www.', '')
  auth_code = $('#play_online').data('auth-code')
  document.domain = domain_name
  window.IndiexpoAPI = new RecordClient(auth_code)
  if (auth_code)
    element.load ->
      win = element[0].contentWindow
      win.IndiexpoAPI = new RecordClient(auth_code)
      event = win.document.createEvent('Event')
      event.initEvent('indiexpo-ready', true, true)
      console.log(event)
      win.document.dispatchEvent(event)
