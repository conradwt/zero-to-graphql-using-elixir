defmodule ZeroPhoenixWeb.Router do
  use ZeroPhoenixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ZeroPhoenixWeb do
    # Use the default browser stack
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", ZeroPhoenixWeb do
    pipe_through :api

    resources "/people", PersonController, except: [:new, :edit]
  end

  scope "/graphiql" do
    pipe_through :api

    forward "/",
            Absinthe.Plug.GraphiQL,
            schema: ZeroPhoenixWeb.Graphql.Schema,
            json_codec: Jason,
            interface: :simple
  end
end
