defmodule ConteurApp.StoryBuilding do
  alias ConteurApp.TagExtraction
  alias ConteurApp.Tag
  alias ConteurApp.TagEvent
  alias ConteurApp.Repo
  import Ecto.Query

  def taggify_events(events) do
    for e <- events do
      for t <- extract_and_insert_tags(e) do
        insert_assoc(e, t)
      end
    end
  end

  def extract_and_insert_tags(event) do
    tags = TagExtraction.extract(event)

    tags
    |> Enum.filter(fn(t) -> t != [] end)
    |> Enum.map(fn(t) ->
      tag = Repo.get_by(Tag, name: t)
      data = %{name: t}

      case tag do
        nil -> %Tag{}
        extag -> extag
      end
      |> Tag.changeset(data)
      |> Repo.insert_or_update!
    end)
  end

  def insert_assoc(e, t) do
    assoc = TagEvent
            |> where([et], et.event_id == ^e.id and et.tag_id == ^t.id)
            |> Repo.one

    data = %{ event_id: e.id, tag_id: t.id }

    case assoc do
      nil -> %TagEvent{}
      exevtag -> exevtag
    end
    |> TagEvent.changeset(data)
    |> Repo.insert_or_update!
  end
end
