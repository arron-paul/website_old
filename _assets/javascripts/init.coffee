# Ensure and force secure HTTPS
if window.location.host == 'arron.io' and window.location.protocol != 'https:'
  window.location.protocol = 'https'


# Google Analytics
((i, s, o, g, r, a, m) ->
  i['GoogleAnalyticsObject'] = r
  i[r] = i[r] or ->
    (i[r].q = i[r].q or []).push arguments
    return
  i[r].l = 1 * new Date
  a = s.createElement(o)
  m = s.getElementsByTagName(o)[0]
  a.async = 1
  a.src = g
  m.parentNode.insertBefore a, m
  return
) window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga'
ga 'create', 'UA-73276366-1', 'auto'
ga 'send', 'pageview'


# Events to occur once the DOM has finished being populated
document.addEventListener 'DOMContentLoaded', ->

  # ---
  # Hero content
  # ---

  # Iterate through each .hero element
  [].forEach.call document.querySelectorAll('.hero'), ((elemHero) ->

    # Elements used for DOM manipulation
    elemContent = document.querySelector('.content')
    elemHeader = document.querySelector('header.header')

    # data-spread='x' defines how much vertical space will be filled
    dataSpread = elemHero.getAttribute('data-spread')

    # Hero images require the header to be fixed, rather than relativate
    elemHeader.classList.add 'fixed-in-place'

    # data-theme='x' overrides the light/dark theme of the header
    if elemHero.getAttribute('data-theme')
      [].forEach.call elemHeader.querySelectorAll('.light, .dark'), \
      ((elemWithThemeClass) ->
        elemWithThemeClass.classList.remove 'light'
        elemWithThemeClass.classList.remove 'dark'
        elemWithThemeClass.classList.add elemHero.getAttribute('data-theme')
        console.info 'ℹ Changed header theme to accomodate hero banner'
      )

    # Append the hero element root as the first child of the <body>
    document.body.insertBefore(elemHero, document.body.firstChild)

    # The height of the .sizable child element will be used for scaling
    sizableElem = elemHero.querySelector('.sizable')
    switch dataSpread
      when 'third', 'half', 'full'
        elemContent.classList.add dataSpread
      else
        elemContent.style.top = sizableElem.offsetHeight + 'px'

    # Once the contents of .sizable is fully loaded
    sizableContentLoad = ->
      ensureCoverBounds = ->
        content_top = elemContent.getBoundingClientRect().top
        sizable_bottom = sizableElem.getBoundingClientRect().bottom
        if content_top > sizable_bottom
          elemContent.style.top = sizable_bottom + 'px'
      window.addEventListener 'resize', ensureCoverBounds, true
      ensureCoverBounds()

    # If the contents of .sizable fails to load
    sizableContentFail = ->
      console.error '✘ Failed to download hero content.'
      elemHero.parentNode.removeChild(elemHero)
      elemContent.classList.remove dataSpread
      elemHeader.classList.remove 'using-hero'

    # Apply event handlers to .sizable element
    sizableElem.addEventListener 'load', sizableContentLoad, true
    sizableElem.addEventListener 'error', sizableContentFail, true

  )


  # ---
  # Clickable branding/logo
  # ---
  [].forEach.call document.querySelectorAll('figure.branding'), (elemBrand) ->
    elemBrand.addEventListener 'click', (->
      window.location = '/'
    ), false


  # ---
  # Konami Code
  # ---
  konami = () ->
    window.location = '//www.youtube.com/watch?v=ynl4sIFazmM'
  keypress_array = []
  keypress_sequence = '38,38,40,40,37,39,37,39,66,65'
  document.addEventListener 'keydown', ((event) ->
    keypress_array.push event.keyCode
    if keypress_array.toString().indexOf(keypress_sequence) >= 0
      konami()
      keypress_array = []
  ), false


  # ---
  # Last-FM functionality used in the site footer
  # ---
  [].forEach.call document.querySelectorAll('.last-fm'), (elem) ->

    # Asyncronous request to obtain Last-FM recent track info.
    request = new XMLHttpRequest
    request.open 'GET', '//ws.audioscrobbler.com/2.0/?method=user.getrecenttr\
    acks&user=arron-jeffery&api_key=9fbc9b675a0f143da8b1e80abde0d5fe&limit=1&\
    format=json', true

    # Success event handler for the asynchronous request
    request.onload = ->
      if request.status >= 200 and request.status < 400

        # Transform the JSON contents into a JS object
        json_data = JSON.parse(request.responseText)

        # Things to store
        track = undefined

        # Depending on the amount of 'recent tracks', it may return an
        # array, or just a single object.
        if json_data.recenttracks.track instanceof Array
          track = json_data.recenttracks.track[0]
        else
          track = json_data.recenttracks.track

        # Programatically generate 'artist' <a> element
        artist_name_for_url = track.artist['#text'].replace(' ', '+')
        artist_link = '//last.fm/music/' + artist_name_for_url
        artist_html = document.createElement('a')
        artist_html.href = artist_link
        artist_html.innerHTML = track.artist['#text']

        # Programatically generate 'title' <a> element
        title_name_for_url = track.name.replace(' ', '+')
        title_link = '//last.fm/music/' + artist_name_for_url + '/_/' + \
        title_name_for_url
        title_html = document.createElement('a')
        title_html.href = title_link
        title_html.innerHTML = track.name

        # Programatically generate the 'details' container <div> element
        meta_container = document.createElement('div')
        meta_container.classList.add 'details'
        meta_container.appendChild title_html
        meta_container.appendChild document.createTextNode(" — by ")
        meta_container.appendChild artist_html

        # Remove the 'loading' content
        while elem.firstChild
          elem.removeChild elem.firstChild

        # Obtain album art. Some artwork is bigger than others, and the API
        # returns different sizes in a positial-based array. 🙃
        if track.image[track.image.length - 1]['#text'] isnt undefined
          album_name_for_url = track.album['#text'].replace(' ', '+')
          album_link = '//last.fm/music/' + artist_name_for_url + '/' +
          album_name_for_url
          art_img_html = document.createElement('img')
          art_img_html.src = track.image[track.image.length - 1]['#text']
          art_html = document.createElement('a')
          art_html.href = album_link
          art_html.appendChild art_img_html
          artwork_html = document.createElement('div')
          artwork_html.classList.add 'artwork'
          artwork_html.appendChild art_html
          artwork_html.style.display = 'none'

          # Album art event handler for when it's finished downloading
          art_img_html.onload = ->
            artwork_html.removeAttribute 'style'

          elem.appendChild artwork_html

        # Create a 'Now Playing' element if the track is currently
        # being listened to at that moment
        if track['@attr']
          if track['@attr'].nowplaying
            date_container = document.createElement('div')
            date_container.classList.add 'now-playing'
            date_container.innerHTML = 'Currently playing…'
            elem.appendChild(date_container)

        # Finally, append 'metadata' <div> to root 'last-fm' container
        elem.appendChild(meta_container)

      else
        console.error '✘ Failed to obtain Lastest Jam info. Returned an \
        abnormal HTTP status code.'

    # Error event handler for the asynchronous request
    request.onerror = ->
      console.error '✘ Failed to download Latest Jam info. An exception \
      occured during the asyncrnous request.'

    # Finally, execute the request
    request.send()
