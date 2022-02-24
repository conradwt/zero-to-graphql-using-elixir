defmodule ZeroPhoenixWeb.GraphQL.Schemas.Queries.PersonTest do
  use ZeroPhoenixWeb.ConnCase, async: true

  import Ecto.Query

  alias ZeroPhoenix.Accounts.Person
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
        "/api",
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

  test "get people by IDs" do
    query = """
      query GetPeople($ids: [ID]) {
        people(ids: $ids) {
          firstName
          lastName
        }
      }
    """

   people_ids =
      Person
      |> select([:id])
      |> order_by(asc: :id)
      |> limit(2)
      |> Repo.all()
      |> Enum.map(fn person -> person.id end)

    response =
      post(
        build_conn(),
        "/api",
        query: query,
        variables: %{"ids" => people_ids}
      )

    assert json_response(response, 200) == %{
      "data" => %{
        "people" => [
          %{
            "firstName" => "Conrad",
            "lastName" => "Taylor"
          },
          %{
            "firstName" => "David",
            "lastName" => "Heinemeier Hansson"
          }
        ]
      }
    }
  end

  test "get people" do
    query = """
      query GetPeople {
        people {
          firstName
          lastName
        }
      }
    """

    response =
      post(
        build_conn(),
        "/api",
        query: query
      )

    assert json_response(response, 200) == %{
      "data" => %{
        "people" => [
          %{
            "firstName" => "Conrad",
            "lastName" => "Taylor"
          },
          %{
            "firstName" => "David",
            "lastName" => "Heinemeier Hansson"
          },
          %{
            "firstName" => "Ezra",
            "lastName" => "Zygmuntowicz"
          },
          %{
            "firstName" => "Yukihiro",
            "lastName" => "Matsumoto"
          }
        ]
      }
    }
  end
end
