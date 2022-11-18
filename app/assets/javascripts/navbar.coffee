# jQuery ->

#   update_selected = (subject)->
#     subject.parent().find('[data-navbar]').removeClass 'selected'
#     subject.addClass 'selected'

#   $('[data-navbar]').click (e)->
#     $this = $(this)
#     console.log $this.attr('data-navbar')
#     actual_params = URI(window.location.href).query(true)
#     new_params = URI("?" + $this.attr('data-navbar')).query(true)
#     params = $.extend({}, actual_params, new_params)
#     console.log actual_params, new_params, params
#     section = $this.attr('data-navbar-section')
#     url = URI(window.location.href).query(params)
#     Turbolinks.visit(url, { change: [section] })
#     update_selected $(this)
#     e.preventDefault()
