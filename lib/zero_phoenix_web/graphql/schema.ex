defmodule ZeroPhoenixWeb.Graphql.Schema do
  use Absinthe.Schema

  import_types(ZeroPhoenixWeb.Graphql.Types.Person)

  import_types(ZeroPhoenixWeb.Graphql.Schemas.Queries.Person)

  query do
    import_fields(:person_queries)
  end

  import_types(ZeroPhoenixWeb.Graphql.Schemas.Mutations.Person)

  mutation do
    import_fields(:person_mutations)
  end
end
