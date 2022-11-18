$(document).on 'submit', '[data-advanced-search]', (e)->
  $this = $(this)
  query_value = $($this.attr('data-advanced-search')).val()
  console.log($this.attr('data-advanced-search'));
  $this.find('#hidden_query_string').val(query_value)
  $.pjax.submit(e, '[data-pjax-container]', { timeout: 2000, scrollTo: false })

$(document).on 'change', '[data-form-auto-submit] input[type="checkbox"],[data-form-auto-submit] select', (e)->
  $(this).closest('form').submit()
