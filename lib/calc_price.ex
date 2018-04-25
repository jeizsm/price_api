defmodule CalcPrice do
  alias DistanceService.DistanceRequest
  alias DistanceService.DistanceRequest.Coordinates
  alias DistanceService.Distance.Stub
  alias PriceApi.Repo
  alias PriceApi.Tariff
  require Logger

  def calc_price(start_lat, start_lon, end_lat, end_lon) do
    start_coordinates = coordinates(start_lat, start_lon)
    end_coordinates = coordinates(end_lat, end_lon)
    request = DistanceRequest.new(start: start_coordinates, end: end_coordinates)
    reply = send_request(request)
    %Tariff{distance_price: distance_price, serving_price: serving_price, time_price: time_price, minimal_price: minimal_price} = Repo.one(Tariff)
    price = serving_price + time_price * reply.time + distance_price * reply.distance
    if(price < minimal_price, do: minimal_price, else: price)
  end

  defp parse(string) do
    {parsed, ""} = Float.parse(string)
    parsed
  end

  defp coordinates(lat, lon) do
    Coordinates.new(lat: parse(lat), lon: parse(lon))
  end

  defp send_request(request) do
    env = Application.get_env(:price_api, :distance_service)
    {:ok, channel} = GRPC.Stub.connect(env[:host], env[:port], [])
    {:ok, reply} = channel |> Stub.get_distance(request)
    reply
  end
end
