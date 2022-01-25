defmodule Servy.Plugins do
  require Logger
  alias Servy.Conv

  def track(%Conv{status: 404} = conv) do
    Logger.warn("A status code #{conv.status} is on the loose!")
    conv
  end

  def track(%Conv{} = conv), do: conv

  def log(%Conv{} = conv), do: IO.inspect(conv)

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def emojify(%Conv{status: 200} = conv) do
    %{conv | resp_body: "🔥🔥 #{conv.resp_body} 🎉🎉"}
  end

  def emojify(%Conv{} = conv), do: conv
end
