$(document).ready ->
  $(document).pjax('a[data-pjax]', '[data-pjax-container]', { timeout: 2000, scrollTo: false })
  $(document).on 'click', 'a[data-pjax-class]', (e) ->
    parent_count = parseInt($(this).attr('data-pjax-parent-count') || '0')
    active_class = $(this).attr('data-pjax-class')
    disabled_class = $(this).attr('data-pjax-class-off')
    $this = $(this)
    for i in [0...parent_count]
      $this = $this.parent()
    otherElements = $this.parent().find(".#{active_class}")
    console.log active_class, disabled_class
    if active_class
      otherElements.removeClass(active_class)
      $this.addClass(active_class)
    if disabled_class
      otherElements.addClass(disabled_class)
      $this.removeClass(disabled_class)

  $(document).on 'pjax:click', (e) ->
    $('body').addClass('progress')

  $(document).on 'pjax:success', (e) ->
    if (window.ga)
      window.ga('send', 'pageview')
    $('body').removeClass('progress')

  $(document).on 'ajax:before', (e) ->
    $('body').addClass('progress')

  $(document).on 'ajax:error', (e) ->
    $('body').removeClass('progress')

  $(document).on 'ajax:success', (e) ->
    $('body').removeClass('progress')

  $(document).on 'ajax:complete', (e) ->
    $('body').removeClass('progress')

  $(document).ajaxStart ->
    $('body').addClass('progress')
  .ajaxStop ->
    $('body').removeClass('progress')
