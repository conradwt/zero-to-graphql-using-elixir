defmodule ZeroPhoenixWeb.Graphql.Schema do
  use Absinthe.Schema

  import_types(ZeroPhoenixWeb.Graphql.Types.Person)
  import_types(ZeroPhoenixWeb.Graphql.Schemas.Queries.Person)
  import_types(ZeroPhoenixWeb.Graphql.Schemas.Mutations.Person)

  query do
    import_types(:person_queries)
  end

  mutation do
    import_types(:person_mutations)
  end
end
