class IndiepadManager
  constructor: (options) ->
    @server = options.server
    @selector = options.selector || '#indiepad'
    @domain_name = options.domain_name || window.location.hostname.replace('www.', '')
  showQR: ->
    dfd = $.Deferred()
    if $(@selector).length > 0
      dfd.resolve( $(@selector) )
    else
      $.get '/games/qrcode', (data) =>
        $(@selector).remove()
        $(data).appendTo('body')
        dfd.resolve( $(@selector) )
    dfd.promise()
  loadIndiepadSettings: (game_id)->
    dfd = $.Deferred()
    game_id = game_id || window.location.pathname.match(/\/games\/(.*)\/?$/)[1]
    $.get Routes.indiepad_game_path(game_id), (data) =>
      dfd.resolve( data )
    dfd.promise()
  setup: (iframe, game_id) ->
    document.domain = @domain_name
    $.when(this.showQR()).then =>
      $.when(this.loadIndiepadSettings(game_id)).then (keymap_data)=>
        @currentIndiepad = new Indiepad({
              server: @server,
              autoInit: true,
              domain: @domain_name,
              keymap: keymap_data.keys,
              onActivate: => $(@selector).hide()
            });
  setupGlobal: () ->
    document.domain = @domain_name
    $.when(this.showQR()).then =>
      @currentIndiepad = new Indiepad({
            server: @server,
            autoInit: true,
            domain: @domain_name,
            onActivate: => $(@selector).hide()
          });

ws_protocol = 'ws'
ws_protocol = 'wss' if window.location.protocol.indexOf("https") != -1

window.indiepadManager = new IndiepadManager({
  server: "#{ws_protocol}://indiepad.indiexpo.net",
  selector: '#indiepad'
});

$(document).on 'click', '[data-play-online]', ->
  link = $(this).attr('data-play-online')
  $("<div class='iframe_menu desktop_only'></div><iframe id='play_online_iframe' src='#{link}'>").appendTo('body');
  use_indiepad = $(this).attr('data-use-indiepad')
  game_id = $(this).attr('data-game-id')
  $(document).trigger('play-online', [$('#play_online_iframe'), game_id])
  return unless use_indiepad
  $('#play_online_iframe').on 'load', ->
    console.log('loaded iframe')
    try
      window.indiepadManager.setup(this, game_id)
    catch e
      console.log('Indiepad not configured', e)
    true
