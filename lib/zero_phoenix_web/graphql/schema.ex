defmodule ZeroPhoenixWeb.GraphQL.Schema do
  use Absinthe.Schema

  import_types(ZeroPhoenixWeb.GraphQL.Types.Person)

  import_types(ZeroPhoenixWeb.GraphQL.Schemas.Queries.Person)

  alias ZeroPhoenix.Accounts

  query do
    import_fields(:person_queries)
  end

  import_types(ZeroPhoenixWeb.GraphQL.Schemas.Mutations.Person)

  mutation do
    import_fields(:person_mutations)
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
