defmodule PriceApiWeb.PriceView do
  use PriceApiWeb, :view
  alias PriceApiWeb.PriceView

  def render("index.json", %{price: price}) do
    %{data: render_one(price, PriceView, "price.json")}
  end

  def render("price.json", %{price: price}) do
    %{price: price}
  end
end
