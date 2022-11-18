if $('meta[name="current-user"]').length > 0
  App.notifications = App.cable.subscriptions.create "NotificationsChannel",
    connected: ->
      count = 0
      $.ajax
        method: 'GET'
        url: '/notifications/count.json'
        dataType: 'JSON'
        success: (data) ->
          count = data.count
          if data.count > 0
            $('.notifications-icon').append('<div class="notific_count">' + data.count + '</div>')
          else
            $('.notifications-icon .notific_count').remove()
      @update_title(count)

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      $.ajax
        method: 'GET'
        url: '/notifications/count.json'
        dataType: 'JSON'
        success: (data) ->
          if data.count > 0
            $('.notifications-icon').append('<div class="notific_count">' + data.count + '</div>')

            # Update notification count in title
            title = $("head title")[0].innerHTML
            if (title.trim().startsWith("("))
              title = title.replace(/\(.*?\)/, "(" + data.count + ")")
            else
              title = "(" + data.count + ") " + title.trim()
            $("head title")[0].innerHTML = title

            if $('body').data('notificationSound') != "" && $('body').data('notificationSound') == true
              ion.sound.play("notification")

    update_title: (count) ->
      title = $("head title")[0].innerHTML
      temp = ''
      if count > 0
        temp = "(" + data.count + ")"

      if (title.trim().startsWith("("))
        title = title.replace(/\(.*?\)/, temp)
      else
        title = temp + title.trim()
      $("head title")[0].innerHTML = title
