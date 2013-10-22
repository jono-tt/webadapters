class ResultTabs
  constructor: (@tabl_el) ->
    @switch_to_results()
    $(@tabl_el + " a").click( (e) =>
      e.preventDefault()
      element = $(e.target)
      @set_active( element )
      @switch_to( element.data('tab') )
    )
  clear_active: () =>
    $(@tabl_el + " li").removeClass("active")

  set_active: (el) =>
    @clear_active()
    window.location.hash = $(el).attr('href')
    $(el).parent().addClass("active")

  hide_all: () =>
    $(".tabs-data").hide()

  show: (tab_ref) =>
    $(tab_ref).show()

  switch_to: (tab_ref) =>
    @hide_all()
    @show(tab_ref)

  active: () =>
    $("li.active a").data('tab')

  clear_not_active: () =>
    inactive_ids = $("li:not(.active) a").map (i, e) ->  
      return $(e).data('tab')
    inactive_ids.each (i, e) ->
      $(e).find("ul").html("")

  loading: () =>
    tab = @active()
    $(tab).addClass("loading")

  loaded: () =>
    tab = @active()
    $(tab).removeClass("loading")

  switch_to_results: () =>
    @set_active($("a[href=#result]"))
    @switch_to("#tab-results")

  refresh: () =>
    if window.location.hash
      $("a[href=" + window.location.hash+ " ]").trigger('click')

window.EditorResultTabs = ResultTabs