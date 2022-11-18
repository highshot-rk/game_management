$(document).ready ->
  card = $('[data-card]')
  card.setup = (p, url)->
    $this = $(this)
    $this.css({ top: p.top, left: p.left, display: 'block' })
    xhr = $.ajax({
            url: url,
            success: (data)->
              $this.html($(data))
            })
    timeout = null
    $this.off 'mouseout'
    $this.off 'mouseover'
    $this.on 'mouseout', ->
      timeout = setTimeout ->
        xhr.abort();
        $this.css({ display: 'none' })
    $this.on 'mouseover', ->
      clearTimeout timeout if timeout != null

  $(document).on 'mouseover', '[data-game-card]', ->
    card.html('')
    p = $(this).position()
    url = $(this).attr('data-game-card')
    card.setup(p, url)
