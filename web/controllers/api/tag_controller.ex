defmodule ConteurApp.Api.TagController do
  use ConteurApp.Web, :controller

  alias ConteurApp.Tag

  plug :scrub_params, "tag" when action in [:create, :update]

  def index(conn, _params) do
    tags = Repo.all(Tag)
    render(conn, "index.json", tags: tags)
  end

  def show(conn, %{"id" => id}) do
    tag = Repo.get!(Tag, id)
    render(conn, "show.json", tag: tag)
  end
end
