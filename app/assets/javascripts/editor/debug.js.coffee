class Debug
  constructor: (@debug_el) ->
    @hide()
  add: (debug_entry) =>
    $(@debug_el).append("<li> => " + debug_entry + "</li>")
  hide: () =>
    $(@debug_el).parent().parent().hide()
  show: () =>
    $(@debug_el).parent().parent().show()
  clear: () =>
    $(@debug_el).text("")


window.EditorDebug = Debug