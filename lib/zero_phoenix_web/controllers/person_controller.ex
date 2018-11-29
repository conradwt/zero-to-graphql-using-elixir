defmodule ZeroPhoenixWeb.PersonController do
  use ZeroPhoenixWeb, :controller

  alias ZeroPhoenix.Account
  alias ZeroPhoenix.Account.Person

  action_fallback ZeroPhoenixWeb.FallbackController

  def index(conn, _params) do
    people = Account.list_people()
    render(conn, "index.json", people: people)
  end

  def create(conn, %{"person" => person_params}) do
    with {:ok, %Person{} = person} <- Account.create_person(person_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.person_path(conn, :show, person))
      |> render("show.json", person: person)
    end
  end

  def show(conn, %{"id" => id}) do
    person = Account.get_person!(id)
    render(conn, "show.json", person: person)
  end

  def update(conn, %{"id" => id, "person" => person_params}) do
    person = Account.get_person!(id)

    with {:ok, %Person{} = person} <- Account.update_person(person, person_params) do
      render(conn, "show.json", person: person)
    end
  end

  def delete(conn, %{"id" => id}) do
    person = Account.get_person!(id)

    with {:ok, %Person{}} <- Account.delete_person(person) do
      send_resp(conn, :no_content, "")
    end
  end
end
