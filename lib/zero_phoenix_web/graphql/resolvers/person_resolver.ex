defmodule ZeroPhoenixWeb.GraphQL.Resolvers.PersonResolver do
  import Ecto

  alias ZeroPhoenix.Accounts
  alias ZeroPhoenix.Accounts.Person
  alias ZeroPhoenix.Repo

  def find(_parent, %{id: id}, _resolution) do
    case Accounts.get_person(id) do
      %Person{} = person ->
        {:ok, person}

      _error ->
        {:error, "Person id #{id} not found"}
    end
  end

  def list(_parent, %{ids: ids}, _resolution) do
    {:ok, Accounts.get_people(ids)}
  end

  def create(_parent, %{input: params}, _resolution) do
    case Accounts.create_person(params) do
      {:ok, person} ->
        {:ok, person}

      {:error, _} ->
        {:error, "Could not create person"}
    end
  end

  def friends(parent, _args, _resolution) do
    {:ok, Repo.all(assoc(parent, :friends))}
  end
end
