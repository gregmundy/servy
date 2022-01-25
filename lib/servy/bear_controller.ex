defmodule Servy.BearController do
  import Servy.View
  alias Servy.WildThings
  alias Servy.Bear

  def index(conv) do
    bears = WildThings.list_bears() |> Enum.sort(&Bear.order_asc_by_name/2)
    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = WildThings.get_bear(id)
    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"type" => type, "name" => name} = _params) do
    %{
      conv
      | status: 201,
        resp_body: "Created a #{type} bear named #{name}!"
    }
  end

  def delete(conv, _params) do
    %{conv | status: 403, resp_body: "Bears must never be deleted"}
  end
end
