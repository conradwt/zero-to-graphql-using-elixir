defmodule ZeroPhoenixWeb.GraphQL.Schemas.Queries.Person do
  use Absinthe.Schema.Notation

  object :person_queries do
    field :person, type: :person do
      arg :id, non_null(:id)

      resolve(&ZeroPhoenixWeb.GraphQL.Resolvers.PersonResolver.find/3)
    end

    field :people, type: list_of(:person) do
      arg(:ids, list_of(:id), default_value: [])

      resolve(&ZeroPhoenixWeb.GraphQL.Resolvers.PersonResolver.list/3)
    end
  end
end
