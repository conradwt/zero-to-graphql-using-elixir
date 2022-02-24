defmodule ZeroPhoenixWeb.GraphQL.Schemas.Mutations.PersonTest do
  use ZeroPhoenixWeb.ConnCase, async: true

  test "create person" do
    query = """
      mutation CreatePerson($person: PersonInput!) {
        createPerson(input: $person) {
          firstName
          lastName
          email
          username
        }
      }
    """

    person = %{
      "firstName" => "Jane",
      "lastName" => "Doe",
      "email" => "jane@example.com",
      "username" => "janed"
    }

    response =
      post(
        build_conn(),
        "/api",
        query: query,
        variables: %{"person" => person}
      )

    assert json_response(response, 200) == %{
      "data" => %{
        "createPerson" => %{
          "firstName" => person["firstName"],
          "lastName" => person["lastName"],
          "email" => person["email"],
          "username" => person["username"]
        }
      }
    }
  end
end
