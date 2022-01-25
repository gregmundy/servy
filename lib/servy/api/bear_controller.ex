defmodule Servy.Api.BearController do
  alias Servy.WildThings
  # alias Servy.Bear

  def index(conv) do
    bears =
      WildThings.list_bears()
      # |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Poison.encode!()
    %{ conv | status: 200, resp_body: bears, resp_content_type: "application/json"}
  end
end
