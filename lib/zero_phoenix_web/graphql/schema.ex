defmodule ZeroPhoenixWeb.Graphql.Schema do
  use Absinthe.Schema

  import_types(ZeroPhoenixWeb.Graphql.Types.Person)

  alias ZeroPhoenix.Repo
  alias ZeroPhoenix.Account.Person

  query do
    field :person, type: :person do
      arg(:id, non_null(:id))

      resolve(fn %{id: id}, _info ->
        case Person |> Repo.get(id) do
          person -> {:ok, person}
          nil -> {:error, "Person id #{id} not found"}
        end
      end)
    end
  end
end
