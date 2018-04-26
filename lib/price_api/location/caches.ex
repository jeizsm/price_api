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
            where: c.inserted_at > ^unquote(time) and near_sphere(unquote(field_name), unquote(point)),
            select: c.id)
    end
  end

  def cached(start_point, end_point) do
    time = NaiveDateTime.add(NaiveDateTime.utc_now(), -5 * 60, :second)
    start_nearest = Repo.all(get_nearest(:start, start_point, time))
    end_nearest = Repo.all(get_nearest(:end, end_point, time))
    case [start_nearest, end_nearest] do
      [[], []] ->
        nil
      _ ->
        Repo.one(from(c in Cache,
                      where: c.id in ^start_nearest and c.id in ^end_nearest,
                      select: [:price], order_by: [desc: c.inserted_at]))
    end
  end
end
