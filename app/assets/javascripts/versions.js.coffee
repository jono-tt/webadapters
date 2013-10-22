class Version
  constructor: ->
    $("#version").change (e) =>
      @load_version()

    $("#compare").change (e) =>
      @load_version()

  load_version: ->
    version = $("#version").val()
    compare_version = $("#compare").val()

    base_url = window.location.pathname.replace(/[^\/]+$/, '')
    url = base_url + version
    url += "?compare_id=#{compare_version}" if compare_version
    window.location = url

$ ->
  new Version()
