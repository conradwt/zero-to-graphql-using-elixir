defmodule ZeroPhoenixWeb.Schema.Query.PersonTest do
  use ZeroPhoenixWeb.ConnCase, async: true

  import Ecto.Query, only: [first: 1]

  alias ZeroPhoenix.Account.Person
  alias ZeroPhoenix.Repo

  setup do
    ZeroPhoenix.Seeds.run()
  end

  test "get person by ID" do
    query = """
      query GetPerson($personId: ID!) {
        person(id: $personId) {
          email
        }
      }
    """

    person =
      Person
      |> first()
      |> Repo.one()

    response =
      post(
        build_conn(),
        "/graphql",
        query: query,
        variables: %{"personId" => person.id}
      )

    assert json_response(response, 200) == %{
      "data" => %{
        "person" => %{
          "email" => "conradwt@gmail.com"
        }
      }
    }
  end
end
