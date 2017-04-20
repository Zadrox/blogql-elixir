defmodule BlogqlElixir.PageController do
  use BlogqlElixir.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
