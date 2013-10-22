module AlarmsHelper
  def diff(from, to)
    safe_from = from.gsub("<", "&lt;").gsub(">", "&gt;")
    safe_to = to.gsub("<", "&lt;").gsub(">", "&gt;")
    if (safe_from && safe_to)
      Differ.diff_by_word(safe_from, safe_to).format_as(:html)
    else
      safe_from
    end
  end
end
