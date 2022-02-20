defmodule ZeroPhoenixWeb.GraphQL.Schemas.Mutations.Person do
  use Absinthe.Schema.Notation

  object :person_mutations do
    field :create_person, type: :person do
      arg :input, non_null(:person_input)

      resolve(&ZeroPhoenixWeb.GraphQL.Resolvers.PersonResolver.create/3)
    end
  end
end
