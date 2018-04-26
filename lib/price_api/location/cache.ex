defmodule PriceApi.Location.Cache do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "cache" do
    field :end, :map
    field :start, :map
    field :price, :integer
    timestamps()
  end

  @doc false
  def changeset(cache, attrs) do
    cache
    |> cast(attrs, [:start, :end, :price])
    |> validate_required([:start, :end, :price])
  end
end
