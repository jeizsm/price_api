defmodule PriceApi.PriceView do
  use PriceApi.Web, :view

  def render("index.json", %{price: price}) do
    %{data: render_one(price, PriceApi.PriceView, "price.json")}
  end

  def render("price.json", %{price: price}) do
    %{price: price}
  end
end
