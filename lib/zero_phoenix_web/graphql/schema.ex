defmodule ZeroPhoenixWeb.GraphQL.Schema do
  use Absinthe.Schema

  import_types(ZeroPhoenixWeb.GraphQL.Types.Person)

  import_types(ZeroPhoenixWeb.GraphQL.Schemas.Queries.Person)

  query do
    import_fields(:person_queries)
  end

  import_types(ZeroPhoenixWeb.GraphQL.Schemas.Mutations.Person)

  mutation do
    import_fields(:person_mutations)
  end
end
