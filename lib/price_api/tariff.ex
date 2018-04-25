defmodule PriceApi.Tariff do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "tariffs" do
    field :distance_price, :integer
    field :serving_price, :integer
    field :time_price, :integer
    field :minimal_price, :integer

    timestamps()
  end

  @doc false
  def changeset(tariff, attrs) do
    tariff
    |> cast(attrs, [:serving_price, :distance_price, :time_price, :minimal_price])
    |> validate_required([:serving_price, :distance_price, :time_price, :minimal_price])
  end
end
