defmodule PriceApi.PriceController do
  import CalcPrice
  use PriceApi.Web, :controller

  def index(conn, %{"start_lat" => start_lat, "start_lon" => start_lon, "end_lat" => end_lat, "end_lon" => end_lon}) do
    price = calc_price(start_lat, start_lon, end_lat, end_lon)
    render(conn, "index.json", price: price)
  end
end
