defmodule PriceApiWeb.Router do
  use PriceApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PriceApiWeb do
    pipe_through :api
    resources "/prices", PriceController, only: [:index]
  end
end
