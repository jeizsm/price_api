defmodule PriceApi.Repo.Migrations.CreateTariffs do
  use Ecto.Migration

  def change do
    create table(:tariffs) do
      add :serving_price, :integer
      add :distance_price, :integer
      add :time_price, :integer

      timestamps()
    end

  end
end
