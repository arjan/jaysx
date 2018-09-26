defmodule JaysxTest do
  use ExUnit.Case
  doctest Jaysx

  import Jaysx

  test "~J sigil creates JSX" do
    value = ~J"""
      <RandomImage foo={a > 10}><img></RandomImage>
    """

    assert {:{}, _, ["RandomImage", _, _]} = value
  end

  defjsx greeting(name) do
    ~J"""
    <Header color="blue" shadowSize={3 + 2}>
      Hello {String.upcase(name)}!
    </Header>
    """
  end

  test "defjsx generates functions" do
    assert {"header", _, _} = greeting("Arjan")
  end

  defjsx button(label) do
    ~J"""
    <button>{label}</button>
    """
  end

  test "to_html" do
    assert "<button>Click me</button>" = button("Click me") |> Jaysx.to_html()
  end
end
