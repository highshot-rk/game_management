$(document).on 'click', '[data-fieldset-enabler]', ->
  MAX_VALUES = parseInt($(this).attr('data-fieldset-enabler'))
  enabler_count = MAX_VALUES - $("[data-fieldset-enablable][disabled]").length
  if enabler_count < MAX_VALUES
    subject = $("[data-fieldset-enablable=\"#{enabler_count}\"]")
    subject.show()
    subject.removeAttr('disabled')
