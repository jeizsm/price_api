defmodule PriceApi.Location.Caches do
  import Ecto.Query, only: [from: 2]
  alias PriceApi.Location.Cache
  alias PriceApi.Repo

  defmacrop near_sphere(field_name, point) do
    quote do
      fragment(
        [{unquote(field_name), [
          "$nearSphere": [
            "$geometry": [
              "type": "Point",
              "coordinates": ^unquote(point)
            ],
            "$maxDistance": 10
          ]
        ]}]
      )
    end
  end

  defmacrop get_nearest(field_name, point, time) do
    quote do
      from(c in Cache,
            where: c.inserted_at > ^unquote(time) and nearSphere(unquote(field_name), unquote(point)),
            order_by: [desc: c.inserted_at],
            select: [:id, :price])
    end
  end

  def cached(start_point, end_point) do
    time = NaiveDateTime.add(NaiveDateTime.utc_now(), -5 * 60, :second)
    %Cache{id: start_id} = Repo.one(get_nearest(:start, start_point, time))
    cache = %Cache{id: end_id} = Repo.one(get_nearest(:end, end_point, time))
    if start_id == end_id do
      cache
    else
      nil
    end
  end
end
