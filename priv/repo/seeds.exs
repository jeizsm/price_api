# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PriceApi.Repo.insert!(%PriceApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
PriceApi.Repo.insert!(%PriceApi.Tariff{minimal_price: 300, serving_price: 150, distance_price: 38, time_price: 15})
