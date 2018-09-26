# Jaysx - JSX in Elixir

This library provides a `~J` sigil in Elixir, and, on top of that, a
`defjsx` function which allows you to write functions which return a
fully evaluated JSX data structure.


```elixir
  defjsx greeting(name) do
    ~J"""
    <Header color="blue" shadowSize={3 + 2}>
      Hello {String.upcase(name)}!
    </Header>
    """
  end
```

This creates a `render/1` function which, upon invocation, returns a
fully evaluated data structure. The element tree that is returned is
constructed as a nested tree of `{name, attributes, children}` tuples.

You can use `Jaysx.to_html/2` to convert this data structure to a HTML
string.

The project uses the HTML parser from the
[zotonic_stdlib](https://github.com/zotonic/z_stdlib) project, but
adapted to allow for the `{}` syntax that JSX provides to embed
expressions inside the JSX element tree.

### So… how is this different from an EEX template?

EEX returns always a plain, rendered string, whereas JSX returns a DOM tree
structure which can be rendered to a string, if needed. The DOM tree
can also be used for fancier stuff like React-like DOM diffing.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `jaysx` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:jaysx, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/jaysx](https://hexdocs.pm/jaysx).
