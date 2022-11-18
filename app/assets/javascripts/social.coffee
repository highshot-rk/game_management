$(document).on 'page:change', ->
  if (window.Turbolinks && window.FB)
    FB.init({ status: true, cookie: true, xfbml: true });