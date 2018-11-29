defmodule ZeroPhoenix.AccountTest do
  use ZeroPhoenix.DataCase

  alias ZeroPhoenix.Account

  describe "people" do
    alias ZeroPhoenix.Account.Person

    @valid_attrs %{
      email: "some email",
      first_name: "some first_name",
      last_name: "some last_name",
      username: "some username"
    }
    @update_attrs %{
      email: "some updated email",
      first_name: "some updated first_name",
      last_name: "some updated last_name",
      username: "some updated username"
    }
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil, username: nil}

    def person_fixture(attrs \\ %{}) do
      {:ok, person} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_person()

      person
    end

    test "list_people/0 returns all people" do
      person = person_fixture()
      assert Account.list_people() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Account.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      assert {:ok, %Person{} = person} = Account.create_person(@valid_attrs)
      assert person.email == "some email"
      assert person.first_name == "some first_name"
      assert person.last_name == "some last_name"
      assert person.username == "some username"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()
      assert {:ok, person} = Account.update_person(person, @update_attrs)
      assert %Person{} = person
      assert person.email == "some updated email"
      assert person.first_name == "some updated first_name"
      assert person.last_name == "some updated last_name"
      assert person.username == "some updated username"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_person(person, @invalid_attrs)
      assert person == Account.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Account.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Account.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Account.change_person(person)
    end
  end
end
