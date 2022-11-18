setFullScreen = (forced) ->
  docElm = document.documentElement;
  isFullScreen = document.fullscreenElement || document.webkitFullscreenElement || document.mozFullscreenElement || document.msFullscreenElement

  if isFullScreen && !forced
    if document.exitFullscreen
      document.exitFullscreen()
    else if document.webkitExitFullscreen
      document.webkitExitFullscreen()
    else if docElm.mozExitFullscreen
      document.mozExitFullscreen()
    else if docElm.msExitFullscreen
      document.msExitFullscreen()
  else
    if docElm.requestFullscreen
      docElm.requestFullscreen()
    else if docElm.mozRequestFullScreen
      docElm.mozRequestFullScreen()
    else if docElm.webkitRequestFullScreen
      docElm.webkitRequestFullScreen()
    else if docElm.msRequestFullscreen
      docElm.msRequestFullscreen()


$(document).on 'click', '[data-fullscreen]', ->
  setFullScreen()

$(document).on 'click', '[data-fullscreen-enabled]', ->
  setFullScreen(true)
