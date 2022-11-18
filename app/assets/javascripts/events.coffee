$(document).on 'ready', ()->
  $('[data-datetime-picker]').each ->
    date = moment($(this).val(), "YYYY-MM-DD HH:mm Z", true);
    $(this).val(date.format('YYYY-MM-DD HH:mm Z'))
  $('[data-datetime-picker]').datetimepicker({
    timeFormat: 'HH:mm Z',
    dateFormat: 'yy-mm-dd'
  })
