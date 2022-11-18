$(document).on 'ready', ->

  count_characters = (element)->
    $this = $(element)
    subject_id = $this.attr('data-character-counter')
    total = $this.attr('maxlength')
    current = $this.val().length
    $('#' + subject_id).html(total - current)

  cc = $('[data-character-counter]')

  count_characters(cc) if cc.length > 0

  $(this).on 'input change keyup paste', '[data-character-counter]', (e) ->
    count_characters(this)

  $(this).on 'ajax:success', '[data-load-comments]', (e, data, status, xhr) ->
    comment_id = $(this).attr('data-load-comments')
    answers = $("#comment-#{comment_id}-answers").prepend(data)
    $(this).parent().remove()

  $(this).on 'ajax:success', '[data-new-comment]', (e, data, status, xhr) ->
    $this = $(this)
    comment_id = $this.attr('data-new-comment')

    # TODO: Remove this. This is now handled by RailsUJS, leave in for now
    # in case we need to revert.
    #
    # if !comment_id
      # target = $('#comments')
      # target.prepend(data)
    # else
      # target = $("#comment-#{comment_id}-answers")
      # target.append(data)

    $('.first_to_comment').remove()
    $this[0].reset()
