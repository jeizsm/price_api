defmodule PriceApi.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :end_lat, :float
    field :end_lon, :float
    field :start_lat, :float
    field :start_lon, :float
  end

  @required ~w(start_lat start_lon end_lat end_lon)a
  @optional ~w()a

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end
