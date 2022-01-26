defmodule ZeroPhoenixWeb.Graphql.Resolvers.Person do
  alias ZeroPhoenix.Account

  def create_person(_parent, %{input: params}, _info) do
    case Account.create_person(params) do
      {:ok, person} ->
        {:ok, person}

      {:error, _} ->
        {:error, "Could not create person"}
    end
  end
end
