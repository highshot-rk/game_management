# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ()->

  templates = {}
  counters = {}

  $('[data-more-subject]').each () ->
    templates[$(this).attr('data-more-subject')] = $(this)[0].outerHTML
    true
  .remove()

  increment_value = (string, new_id, open, close) ->
    string.replace new RegExp(open + '[0-9]+' + close), (number) ->
      open + new_id + close

  $(this).off 'click', '[data-more-remove]'
  $(this).on 'click', '[data-more-remove]', ->
    $(this).parent().remove()

  $(this).off 'click', '[data-more]'
  $(this).on 'click', '[data-more]', ->
    subject_name = $(this).attr('data-more')
    counter_name = $(this).attr('data-more-counter') || subject_name
    subject = $(templates[subject_name])
    console.log(subject_name, counter_name)
    counters[counter_name] ||= 0
    # Replace ids with new number
    subject.find('input[id]').each () ->
      id = increment_value $(this).attr('id'), counters[counter_name], '_', '_'
      name = increment_value $(this).attr('name'), counters[counter_name], '\[', '\]'
      $(this).attr { id: id, name: name }
      if !$(this).is('[type="checkbox"]')
        $(this).attr { value: '' }
      $(this).removeAttr('checked')
    # Replace labels with new number
    subject.find('label').each () ->
      _for = increment_value $(this).attr('for'), counters[counter_name], '_', '_'
      $(this).attr { for: _for }

    $(this).parent().append(subject)
    counters[counter_name] += 1

  $(this).off('input change keyup paste', '[data-destroy-on-empty]')
  $(this).on 'input change keyup paste', '[data-destroy-on-empty]', (e)->
    destroy_checkbox = $(this).attr('name').replace(/\[([a-z]+)\]$/g, '[_destroy]')
    destroy_checkbox = destroy_checkbox.split("[").join("\\[").split("]").join("\\]")
    destroy_checkbox = $(this).siblings("[type=\"checkbox\"][name=\"#{destroy_checkbox}\"]")

    if $(this).val() == ''
      destroy_checkbox.prop('checked', true);
    else
      destroy_checkbox.prop('checked', false);

  $(this).on 'click', '[ data-play-online]', (e) ->
    $('body').css('overflow', 'hidden')


  ###
  #
  # Updates the download counter (+1) when someone triggers the action.
  # This is not the Rails way neither is the way I would implement such a functionality;
  # However, with Rails > 5.1 and Stimulus changing the way we communicate with JavaScript
  # there's no reason to spend unnecessary time to implement this properly right now.
  #
  ###
  # => event: a jQuery click event
  #
  $(this).on 'click', '[data-action="player-increment"]', (event) ->
    event.stopPropagation();

    # : HTML Div Element
    element = $(event.target).closest('[data-action="player-increment"]')[0];

    # : DOMStringMap<{ action: string, url: string, target: string, ... }
    #
    # => action: 'player-increment'
    # => url: API URL for retrieving the new downloads_counter
    # => target: DOM ID identifier, usually '#playersCount'
    #
    dataset = element.dataset;

    # : HTML (span | p) Element
    target = $(dataset.target);

    getCounter = () ->
      $.ajax
        type: 'GET',

        # Specifically set the request format
        #
        dataType: 'json',
        url: dataset.url,

        # => data: API Response<{ status: number, downloads: number }>
        success: (data) ->

          # Replaces the current html content, which should be a number, with a new number returned
          # by the API.
          #
          target.html(data.downloads);

    ###
    #
    # We need to ensure that the DownloadService updates the counter before we attempt at getting
    # the new downloads_count. Otherwise, it will always return the old count.
    #
    ###
    setTimeout(getCounter, 1000)
