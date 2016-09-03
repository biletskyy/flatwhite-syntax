def render_one(model, view, template, assigns \\ %{}) do
  if model != nil do
    assigns = to_map(assigns)
    render view, template, assign_model(assigns, view, model)
  end
end

defp to_map(assigns) when is_map(assigns), do: assigns
defp to_map(assigns) when is_list(assigns), do: :maps.from_list(assigns)

defp assign_model(assigns, view, model) do
  as = Map.get(assigns, :as) || view.__resource__
  Map.put(assigns, as, model)
end

@doc """
Renders the template and returns iodata.
"""
def render_to_iodata(module, template, assign) do
  render(module, template, assign) |> encode(template)
end

@doc """
Renders the template and returns a string.
"""
def render_to_string(module, template, assign) do
  render_to_iodata(module, template, assign) |> IO.iodata_to_binary
end

defp encode(content, template) do
  if encoder = Template.format_encoder(template) do
    encoder.encode_to_iodata!(content)
  else
    content
  end
end

@doc false
def __template_options__(module, opts) do
  root = opts[:root] || raise(ArgumentError, "expected :root to be given as an option")
  path = opts[:path]
  pattern = opts[:pattern]
  namespace =
    if given = opts[:namespace] do
      given
    else
      module
      |> Module.split()
      |> Enum.take(1)
      |> Module.concat(true)
    end

  root_path = Path.join(root, path || Template.module_to_template_root(module, namespace, "View"))

  if pattern do
    [root: root_path, pattern: pattern]
  else
    [root: root_path]
  end
end

defmodule NoRouteError do
  @moduledoc """
  Exception raised when no route is found.
  """
  defexception plug_status: 404, message: "no route found", conn: nil, router: nil

  def exception(opts) do
    conn   = Keyword.fetch!(opts, :conn)
    router = Keyword.fetch!(opts, :router)
    path   = "/" <> Enum.join(conn.path_info, "/")

    %NoRouteError{message: "no route found for #{conn.method} #{path} (#{inspect router})",
                  conn: conn, router: router}
  end
end
