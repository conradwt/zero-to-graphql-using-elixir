defmodule ZeroPhoenixWeb.Graphql.Resolvers.PersonResolver do
  alias ZeroPhoenix.Accounts
  alias ZeroPhoenix.Accounts.Person

  def find(_parent, %{id: id}, _info) do
    case Accounts.get_person(id) do
      %Person{} = person ->
        {:ok, person}

      _error ->
        {:error, "Person id #{id} not found"}
    end
  end

  def list(_parent,%{ids: ids}, _info) do
     {:ok, Accounts.get_people(ids)}
  end

  def create(_parent, %{input: params}, _info) do
    case Accounts.create_person(params) do
      {:ok, person} ->
        {:ok, person}

      {:error, _} ->
        {:error, "Could not create person"}
    end
  end
end
