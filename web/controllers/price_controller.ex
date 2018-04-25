defmodule PriceApi.PriceController do
  alias DistanceService.DistanceRequest
  alias DistanceService.DistanceRequest.Coordinates
  alias DistanceService.Distance.Stub
  alias PriceApi.Repo
  alias PriceApi.Tariff
  use PriceApi.Web, :controller

  alias PriceApi.Price

  def index(conn, %{"start_lat" => start_lat, "start_lon" => start_lon, "end_lat" => end_lat, "end_lon" => end_lon}) do
    {start_lat, ""} = Float.parse(start_lat)
    {start_lon, ""} = Float.parse(start_lon)
    {end_lat, ""} = Float.parse(end_lat)
    {end_lon, ""} = Float.parse(end_lon)
    start_coordinates = Coordinates.new(lat: start_lat, lon: start_lon)
    end_coordinates = Coordinates.new(lat: end_lat, lon: end_lon)
    request = DistanceRequest.new(start: start_coordinates, end: end_coordinates)
    env = Application.get_env(:price_api, :distance_service)
    {:ok, channel} = GRPC.Stub.connect(env[:host], env[:port], [])
    {:ok, reply} = channel |> Stub.get_distance(request)
    %Tariff{distance_price: distance_price, serving_price: serving_price, time_price: time_price} = Repo.one(Tariff)
    price = serving_price + time_price * reply.time + distance_price * reply.distance
    render(conn, "index.json", price: price)
  end
end
