defmodule ZeroPhoenixWeb.Graphql.Schema do
  use Absinthe.Schema

  import_types(ZeroPhoenixWeb.Graphql.Types.Person)

  alias ZeroPhoenix.Account.Person
  alias ZeroPhoenix.Account

  query do
    field :person, type: :person do
      arg(:id, non_null(:id))

      resolve(fn %{id: id}, _info ->
        case Account.get_person(id) do
          %Person{} = person ->
            {:ok, person}

          _error ->
            {:error, "Person id #{id} not found"}
        end
      end)
    end

    field :people, type: list_of(:person) do
      arg(:ids, list_of(:id), default_value: [])

      resolve(fn %{ids: ids}, _info ->
        {:ok, Account.get_people(ids)}
      end)
    end
  end
end
