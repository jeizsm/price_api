defmodule PriceApiWeb.PriceController do
  use PriceApiWeb, :controller

  alias PriceApi.Location
  import CalcPrice, only: [calc_price: 1]

  action_fallback PriceApiWeb.FallbackController

  def index(conn, params) do
    location = Location.changeset(%Location{}, params)
    if location.valid? do
      price = calc_price(location.changes)
      render(conn, "index.json", price: price)
    else
      {:error, location}
    end
  end
end
