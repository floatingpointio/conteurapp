defmodule ConteurApp.StoryView do
  use ConteurApp.Web, :view

  def render("index.json", %{stories: stories}) do
    %{data: render_many(stories, ConteurApp.StoryView, "story.json")}
  end
  
  def render("index.json", %{stories: stories, event_ids: event_ids}) do
    %{data: render_many(stories, ConteurApp.StoryView, "story.json", %{event_ids: event_ids})}
  end

  def render("show.json", %{story: story}) do
    %{data: render_one(story, ConteurApp.StoryView, "story.json")}
  end
  
  def render("show.json", %{story: story, event_ids: event_ids}) do
    %{data: render_one(story, ConteurApp.StoryView, "story.json", %{event_ids: event_ids})}
  end

  def render("story.json", %{story: story}) do
    %{
      id: story.id,
      calendar_id: story.calendar_id,
      description: story.description
    }
  end

  def render("story.json", %{story: story, event_ids: event_ids}) do
    %{
      id: story.id,
      calendar_id: story.calendar_id,
      description: story.description,
      event_ids: event_ids
    }
  end
end
