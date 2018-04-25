defmodule PriceApi.Router do
  use PriceApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PriceApi do
    pipe_through :api
  end
end
