defmodule PriceApi.Repo.Migrations.CreateGeoIndex do
  use Ecto.Migration

  def up do
    execute [
      createIndexes: "cache",
      indexes: [
        [
          key: [inserted_at: -1, start: "2dsphere"],
          name: "start_2dsphere",
          "2dsphereIndexVersion": 3
        ],
        [
          key: [inserted_at: -1, end: "2dsphere"],
          name: "end_2dsphere",
          "2dsphereIndexVersion": 3
        ]
      ]
    ]
  end

  def down do
    execute [
      dropIndexes: "cache",
      index: "start_2dsphere"
    ]
    execute [
      dropIndexes: "cache",
      index: "end_2dsphere"
    ]
  end
end
