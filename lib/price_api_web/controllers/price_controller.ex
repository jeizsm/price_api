defmodule PriceApiWeb.PriceController do
  use PriceApiWeb, :controller

  import CalcPrice, only: [calc_price: 4]

  action_fallback PriceApiWeb.FallbackController

  def index(conn, %{"start_lat" => start_lat, "start_lon" => start_lon, "end_lat" => end_lat, "end_lon" => end_lon}) do
    price = calc_price(start_lat, start_lon, end_lat, end_lon)
    render(conn, "index.json", price: price)
  end
end
