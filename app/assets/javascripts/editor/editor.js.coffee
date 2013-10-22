class Editor
  constructor: (@editor_el) ->
    @editor = ace.edit(@editor_el)
    @editor.setTheme("ace/theme/merbivore_soft")
    @editor.setShowPrintMargin(false)
    RubyMode = require("ace/mode/ruby").Mode
    @editor.getSession().setMode( new RubyMode() )

  content: (text) =>
    if text
      @editor.getSession().setValue( text )
    @editor.getSession().getValue()

  addError: (line, message) =>
    @editor.getSession().setAnnotations([{
      row: line - 1,
      column: 1,
      text: message,
      type: "error"
    }])

  change: (fn) ->
    @editor.getSession().on("change", fn)

  clearError: ->
    @editor.getSession().setAnnotations([])

  enable: () =>
    @editor.setReadOnly(false)

  disable: () =>
    @editor.setReadOnly(true)

window.Editor = Editor