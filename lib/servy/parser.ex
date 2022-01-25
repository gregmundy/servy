defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\r\n\r\n")
    [request_line | header_lines] = String.split(top, "\r\n")
    [method, path, _] = String.split(request_line, " ")

    params = parse_params(params_string)
    headers = parse_headers(header_lines, %{})

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  defp parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  defp parse_headers([], headers), do: headers

  defp parse_params(params_string) do
    params_string
    |> String.trim()
    |> URI.decode_query()
  end
end
