defmodule ZeroPhoenixWeb.Graphql.Types.Person do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]

  alias ZeroPhoenix.Accounts
  alias ZeroPhoenixWeb.Graphql.Resolvers

  @desc "a person"
  object :person do
    @desc "unique identifier for the person"
    field(:id, non_null(:string))

    @desc "first name of a person"
    field(:first_name, non_null(:string))

    @desc "last name of a person"
    field(:last_name, non_null(:string))

    @desc "username of a person"
    field(:username, non_null(:string))

    @desc "email of a person"
    field(:email, non_null(:string))

    @desc "a list of friends for our person"
    # field :friends, list_of(:person), resolve: dataloader(Accounts)
    field :friends, list_of(:person) do
      resolve &Resolvers.PersonResolver.friends/3
    end
  end

  @desc "a person input"
  input_object :person_input do
    @desc "first name of a person"
    field(:first_name, non_null(:string))

    @desc "last name of a person"
    field(:last_name, non_null(:string))

    @desc "username of a person"
    field(:username, non_null(:string))

    @desc "email of a person"
    field(:email, non_null(:string))
  end

  def context(ctx) do
    loader =
      Dataloader.new
      |> Dataloader.add_source(Accounts, Accounts.datasource())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
