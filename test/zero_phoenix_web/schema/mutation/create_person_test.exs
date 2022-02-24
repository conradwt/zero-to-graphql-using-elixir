defmodule ZeroPhoenixWeb.Schema.Query.CreatePersonTest do
  use ZeroPhoenixWeb.ConnCase, async: true

  import Ecto.Query, only: [first: 1]

  alias ZeroPhoenix.Account.Person
  alias ZeroPhoenix.Repo

  setup do
    ZeroPhoenix.Seeds.run()
  end

  test "create person" do
    query = """
      mutation CreatePerson($person: Person!) {
        createPerson(person: $person) {
          firstName
          lastName
          email
          userName
        }
      }
    """

    variables = %{
      "firstName" => "Jane",
      "lastName" => "Doe",
      "email" => "jane@example.com",
      "username" => "janed"
    }

    response =
      post(
        build_conn(),
        "/graphql",
        query: query,
        variables: variables
      )

    assert json_response(response, 200) == %{
      "data" => %{
        "createPerson" => %{
          "firstName" => "Jane",
          "lastName" => "Doe",
          "email" => "jane@example.com",
          "username" => "janed"
        }
      }
    }
  end
end
