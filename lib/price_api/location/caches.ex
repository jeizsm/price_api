defmodule PriceApi.Location.Caches do
  import Ecto.Query, only: [from: 2]
  alias PriceApi.Location.Cache
  alias PriceApi.Repo

  def cached(start_point, end_point) do
    time = NaiveDateTime.add(NaiveDateTime.utc_now(), -5 * 60, :second)
    %Cache{id: start_id} = Repo.one(get_nearest_start(start_point, time))
    cache = %Cache{id: end_id} = Repo.one(get_nearest_end(end_point, time))
    if start_id == end_id do
      cache
    else
      nil
    end
  end

  defp get_nearest_start(point, time) do
    from(c in Cache, where: c.inserted_at > ^time and fragment(
      start: [
        "$nearSphere": [
          "$geometry": [
            "type": "Point",
            "coordinates": ^point
          ],
          "$maxDistance": 10
        ]
      ]
    ), order_by: [desc: c.inserted_at], select: [:id, :price])
  end

  defp get_nearest_end(point, time) do
    from(c in Cache, where: c.inserted_at > ^time and fragment(
      end: [
        "$nearSphere": [
          "$geometry": [
            "type": "Point",
            "coordinates": ^point
          ],
          "$maxDistance": 10
        ]
      ]
    ), order_by: [desc: c.inserted_at], select: [:id, :price])
  end
end
