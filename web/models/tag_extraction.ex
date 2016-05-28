defmodule ConteurApp.TagExtraction do

  @hashtag_regex ~r/(?<=\s|^)#(\w*[A-Za-z_]+\w*)/

  def extract(event) do
    extract_tags event.summary <> " " <> event.description
  end

  def extract_tags(text) do
    @hashtag_regex
    |> Regex.scan(text)
    |> Enum.map(fn([hashtag, tag]) -> tag end)
  end
end
