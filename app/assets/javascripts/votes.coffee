$(document).on 'ready page:load', ()->
  $('.rateit').rateit()

  user_rating = $('#user_rating')
  mean_rating = $('#mean_rating')

  $('[data-rateit-game]').off 'rated'
  $('[data-rateit-game]').on 'rated', (event, value)->
    component = $(this)
    id = component.attr('data-rateit-game')
    old_value = component.rateit('value')
    $.ajax(
      url: Routes.game_ratings_path({ game_id : id }),
      data: { score: value },
      type: 'PUT',
      success: (data)->
        user_rating.html(value)
        mean_rating.html(data.mean)
        setTimeout(
          ()->
            component.rateit('value', data.mean)
            component.rateit('ispreset', true)
        , 1000)
      ,
      fail: (data)->
        component.rateit('value', old_value)
    )
