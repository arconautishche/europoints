defmodule PointexWeb.ErrorHTMLTest do
  use PointexWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    assert render_to_string(PointexWeb.ErrorHTML, "404", "html", []) =~ "How did you even get here?!"
  end

  test "renders 500.html" do
    assert render_to_string(PointexWeb.ErrorHTML, "500", "html", []) == "Internal Server Error"
  end
end
