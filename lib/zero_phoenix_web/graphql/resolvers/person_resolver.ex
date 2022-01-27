defmodule ZeroPhoenixWeb.Graphql.Resolvers.PersonResolver do
  alias ZeroPhoenix.Account

  def find(_parent, %{id: id}, _info) do
    case Account.get_person(id) do
      %Person{} = person ->
        {:ok, person}

      _error ->
        {:error, "Person id #{id} not found"}
    end
  end

  def list(_parent,%{ids: ids}, _info) do
     {:ok, Account.get_people(ids)}
  end

  def create(_parent, %{input: params}, _info) do
    case Account.create_person(params) do
      {:ok, person} ->
        {:ok, person}

      {:error, _} ->
        {:error, "Could not create person"}
    end
  end
end
