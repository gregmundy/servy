defmodule Servy.Conv do
  defstruct(
    method: "",
    path: "",
    resp_body: "",
    status: nil,
    params: %{},
    headers: %{},
    resp_content_type: "text/html"
  )

  def full_status(conv) do
    "#{conv.status} #{reason(conv.status)}"
  end

  defp reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end
