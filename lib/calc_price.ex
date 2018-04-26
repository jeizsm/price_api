defmodule CalcPrice do
  alias DistanceService.DistanceRequest
  alias DistanceService.DistanceResponse
  alias DistanceService.DistanceRequest.Coordinates
  alias DistanceService.Distance.Stub
  alias PriceApi.Repo
  alias PriceApi.Tariff
  alias PriceApi.Location.Cache
  alias PriceApi.Location.Caches
  require Logger

  def calc_price(location) do
    case Caches.cached([location.start_lon, location.start_lat], [location.end_lon, location.end_lat]) do
      %Cache{price: price} ->
        Logger.info("cached_price: #{price}")
        price
      nil ->
        %DistanceResponse{time: time, distance: distance} = request(location)
        %Tariff{distance_price: distance_price, serving_price: serving_price, time_price: time_price, minimal_price: minimal_price} = Repo.one(Tariff)
        price = serving_price + time_price * time + distance_price * distance
        price = if(price < minimal_price, do: minimal_price, else: price)
        cache_price(location, price)
        price
    end
  end

  defp request(location) do
    start_coordinates = Coordinates.new(lat: location.start_lat, lon: location.start_lon)
    end_coordinates = Coordinates.new(lat: location.end_lat, lon: location.end_lon)
    request = DistanceRequest.new(start: start_coordinates, end: end_coordinates)
    send_request(request)
  end

  defp send_request(request) do
    env = Application.get_env(:price_api, :distance_service)
    {:ok, channel} = GRPC.Stub.connect(env[:host], env[:port], [])
    {:ok, reply} = channel |> Stub.get_distance(request)
    reply
  end

  defp cache_price(location, price) do
    start_point = %{type: "Point", coordinates: [location.start_lon, location.start_lat]}
    end_point = %{type: "Point", coordinates: [location.end_lon, location.end_lat]}
    cache = Cache.changeset(%Cache{}, %{start: start_point, end: end_point, price: price})
    {:ok, _} = Repo.insert(cache)
  end
end
