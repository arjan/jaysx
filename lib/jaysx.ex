defmodule Jaysx do
  @moduledoc """
  JaySX - A JSX sigil for elixir
  """

  @doc """
  Creates a function which returns a DOM-like tree object, based on a
  JSX literal.

  Any variables referenced in the JSX should be part of the defjsx's
  arguments, otherwise weird errors will occur.

  """
  defmacro defjsx({name, _, args}, do: contents) do
    ast = Macro.postwalk(contents, &postwalk_sigil/1)
    bindings = Enum.map(args, fn {n, _, _} = var -> {n, var} end)

    quote do
      def unquote(name)(unquote_splicing(args)) do
        import Jaysx

        unquote(Macro.escape(ast))
        |> Code.eval_quoted(unquote(bindings), __ENV__)
        |> elem(0)
      end
    end
  end

  @doc """

  The ~J sigil embeds JSX into Elixir. In the "expression" parts of
  JSX (within the curly braces) it is possible to write raw Elixir
  code, including nested JSX parts (although you have to use a
  different separation character for the nested sigil, as nesting
  identical sigils is not possible in Elixir).

  The sigil is recursively expanded at compile time, eliminating all
  ~J sigils, and returns an AST which can be evaluated using
  Code.eval_quoted/3; although, you would normally not write that
  yourself, as the `defjsx` macro is built for creating such a
  function.

  """
  defmacro sigil_J({:<<>>, _, [string]}, []) do
    ast = sigil_J_str(string)

    quote do
      unquote(Macro.escape(ast))
    end
  end

  @doc """
  Convenience function to convert an evaluated JSX tree to a HTML
  string. Pass `raw: true` as option to return `iodata()`, which is
  more efficient.
  """
  def to_html({_, _, _} = elem, opts \\ [raw: false]) do
    iolist = :jaysx_parse.to_html(elem)

    case opts[:raw] do
      true ->
        iolist

      false ->
        IO.iodata_to_binary(iolist)
    end
  end

  defp sigil_J_str(string) do
    :jaysx_parse.parse(string)
    |> parse_jsx()
  end

  defp parse_jsx({:jsx, jsx}) do
    {:ok, ast} = Code.string_to_quoted(jsx)
    Macro.postwalk(ast, &postwalk_sigil/1)
  end

  defp parse_jsx({elem, attrs, children}) when is_list(children) do
    contents = [elem, Enum.map(attrs, &parse_jsx_attr_pair/1), Enum.map(children, &parse_jsx/1)]
    {:{}, [], contents}
  end

  defp parse_jsx(string) when is_binary(string), do: string

  defp parse_jsx_attr_pair({k, jsx = {:jsx, _}}) do
    ast = parse_jsx(jsx)
    {:{}, [], [k, ast]}
  end

  defp parse_jsx_attr_pair({k, v}) do
    {:{}, [], [k, v]}
  end

  defp postwalk_sigil({:sigil_J, _, [{:<<>>, _, [string]}, _]}) do
    sigil_J_str(string)
  end

  defp postwalk_sigil(ast) do
    ast
  end
end
