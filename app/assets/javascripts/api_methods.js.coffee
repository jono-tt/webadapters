class ApiMethodEditor
  constructor: (@editor_el, @draft_el, @result_el, @enabled = true) ->
    @scriptChanged = false
    @tabs = new EditorResultTabs("#tabbed-results")
    @editor = new Editor(@editor_el)
    @stats = new EditorStats("#stats")
    @set_editor_value()
    @init_form_buttons()
    @init_draft()
    @init_draft_ui()
    @init_keyboard_shortcuts()
    @debug = new EditorDebug("#debug")
    @disable() unless @enabled
    @editor.change(@promptSave)
    $("#start-save-script").attr('disabled', 'disabled')
    $("#save-script").attr('disabled', 'disabled')


  promptSave: =>
    @scriptChanged = true
    $("#start-save-script").removeAttr('disabled')
    $("#save-prompt").show("fast")

  clear_result: () ->
    $(@result_el).text("")

  enable: () =>
    @editor.enable()
    @enabled = true

  disable: () =>
    @editor.disable()
    @enabled = false

  init_draft: () =>
    if $(@draft_el).length > 0
      $("#result").html( $.trim( $("#draft #diff").html() ) )

  init_draft_ui: () =>
    $("#draft #discard").click (e) =>
      e.preventDefault()
      url = $("#draft #discard").data('url')
      @discard_draft(url)
      return false

    $("#draft #restore").click (e) =>
      e.preventDefault()
      @editor.content( $.trim( $("#draft #content").text() ) )
      @clear_result()
      @discard_draft( $("#draft #discard").data('url') )
      return false

  init_form_buttons: () =>
    $("#run-script").click (e) =>
      e.preventDefault()
      @run_script()

    $("#commit-message").bind "keyup", () ->
      if $(@).val().length > 0
        $("#save-script").removeAttr("disabled")
      else
        $("#save-script").attr("disabled", "disabled")

    $("#cancel-save").click (e) ->
      e.preventDefault()
      $("#save-script-controls").hide()
      $("#save-prompt").show()
      $("#run-script-controls").show()

    $("#start-save-script").click (e) =>
      $("#save-prompt").hide()
      $("#run-script-controls").hide()
      $("#save-script-controls").show()
      $("#commit-message").focus()

    $("#save-script").click (e) =>
      @set_text_area_value()
      commitMessage = $("#commit-message").val()
      $("#message").val(commitMessage)
      $(".script-form").submit()

  init_keyboard_shortcuts: () =>
    $("html").keydown( (e) =>
      if e.metaKey or e.altKey
        if e.keyCode == 69 or e.keyCode == 13 # this keys are 'E' and 'Enter'
          e.preventDefault()
          @run_script()
        if e.keyCode == 83 # this key is 'S'
          e.preventDefault()
          save_button = $("#start-save-script")
          unless save_button.attr('disabled')
            $("#start-save-script").trigger('click')
    )

  run_script: () =>
    @set_text_area_value()
    url = $("#run-script").data('url') + "?" + $("#params").val()
    script =  $("#api_method_script").val()
    encoded_script = script

    @tabs.loading()
    spinner = new Spinner().spin(document.getElementById("spinner"))

    $(@result_el).removeClass("script-error")
    $(@result_el).removeClass("script-warning")
    @editor.clearError()

    request = $.getJSON(url, {script: encoded_script})
    request.success (response) =>
      @tabs.loaded()
      spinner.stop()
      if @scriptChanged
        $("#start-save-script").addClass("btn-danger")
        $("#save-prompt").removeClass("alert-info")
        $("#save-prompt").addClass("alert-error")

      result = response.result
      warning = response.warning
      debug = response.debug
      stats = response.stats

      if result
        $(@result_el).text(JSON.stringify(result, undefined, 2))
      else
        $(@result_el).text(warning)
        $(@result_el).addClass("script-warning")

      @debug.hide()
      @debug.clear()
      if debug
        for debug_entry in debug
          @debug.add(debug_entry)

      @stats.display(stats)
      @tabs.refresh()

    request.error (response) =>
      parsedResponse = JSON.parse(response.responseText)
      errorMessage = parsedResponse.error
      $(@result_el).text(errorMessage)
      line = parsedResponse.line
      if line
        @editor.addError(line, errorMessage)

      @tabs.loaded()
      @tabs.switch_to_results()
      @tabs.clear_not_active()
      $(@result_el).addClass("script-error")
      spinner.stop()


  set_editor_value: () =>
    @editor.content( $("#api_method_script").val() )

  set_text_area_value: () =>
    $("#api_method_script").val( @editor.content() )

  discard_draft: (url) =>
    $.post(url, { _method:'PUT', api_method: {draft: ""} } ,(res) => $(@draft_el).hide('slow') )
    $(@draft_el).hide('slow')
    $(".script-actions").show('slow')
    @enable()
    @clear_result()

$ ->
  if $("#editor").length > 0
    editor = new ApiMethodEditor("editor", "#draft", "#result", true)

  if $("#draft").length > 0
    $(".script-actions").hide()
    editor.disable() if editor


  $(".call-url").click () ->
    @.select()




