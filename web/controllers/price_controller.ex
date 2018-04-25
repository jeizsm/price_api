defmodule PriceApi.PriceController do
  alias DistanceService.DistanceRequest
  alias DistanceService.DistanceRequest.Coordinates
  alias DistanceService.Distance.Stub
  use PriceApi.Web, :controller

  alias PriceApi.Price

  def index(conn, %{"start_lat" => start_lat, "start_lon" => start_lon, "end_lat" => end_lat, "end_lon" => end_lon}) do
    {start_lat, _} = Float.parse(start_lat)
    {start_lon, _} = Float.parse(start_lon)
    {end_lat, _} = Float.parse(end_lat)
    {end_lon, _} = Float.parse(end_lon)
    start_coordinates = Coordinates.new(lat: start_lat, lon: start_lon)
    end_coordinates = Coordinates.new(lat: end_lat, lon: end_lon)
    request = DistanceRequest.new(start: start_coordinates, end: end_coordinates)
    {:ok, channel} = GRPC.Stub.connect("localhost:3000")
    {:ok, reply} = channel |> Stub.get_distance(request)
    price = 150 + 15 * reply.time + 38 * reply.distance
    render(conn, "index.json", price: price)
  end
end
