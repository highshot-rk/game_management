$('body').on 'click', '[data-show-fading]', (e)->
  $subject = $($(this).data('show-fading'))
  $subject.addClass('shown')
