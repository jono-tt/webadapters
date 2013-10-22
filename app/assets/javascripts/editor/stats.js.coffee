class Stats
  constructor: (@stats_el) ->
    @hide()

  add: (title, value) =>
    label = "<strong>"+ title + ":</strong> "
    entry = "<li>" + label +  value + " (sec)</li>" 
    $(@stats_el).append(entry)

  display: (stats) => 
    @hide()
    @clear()
    if stats    
      for key, val of stats
        @add(key, val)

  show: () =>
    $(@stats_el).parent().parent().show()

  hide: () =>
    $(@stats_el).parent().parent().hide()

  clear: () =>
    $(@stats_el).html("")


window.EditorStats = Stats