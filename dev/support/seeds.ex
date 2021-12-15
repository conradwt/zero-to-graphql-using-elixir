defmodule ZeroPhoenix.Seeds do
  alias ZeroPhoenix.Account.{Person, Friendship}
  alias ZeroPhoenix.Repo

  def run() do
    #
    # reset database
    #

    reset()

    #
    # create people
    #

    me =
      Repo.insert!(%Person{
        first_name: "Conrad",
        last_name: "Taylor",
        email: "conradwt@gmail.com",
        username: "conradwt"
      })

    dhh =
      Repo.insert!(%Person{
        first_name: "David",
        last_name: "Heinemeier Hansson",
        email: "dhh@37signals.com",
        username: "dhh"
      })

    ezra =
      Repo.insert!(%Person{
        first_name: "Ezra",
        last_name: "Zygmuntowicz",
        email: "ezra@merbivore.com",
        username: "ezra"
      })

    matz =
      Repo.insert!(%Person{
        first_name: "Yukihiro",
        last_name: "Matsumoto",
        email: "matz@heroku.com",
        username: "matz"
      })

    #
    # create friendships
    #

    me
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset(%{friend_id: matz.id})
    |> Repo.insert()

    dhh
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset(%{friend_id: ezra.id})
    |> Repo.insert()

    dhh
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset(%{friend_id: matz.id})
    |> Repo.insert()

    ezra
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset(%{friend_id: dhh.id})
    |> Repo.insert()

    ezra
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset(%{friend_id: matz.id})
    |> Repo.insert()

    matz
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset(%{friend_id: me.id})
    |> Repo.insert()

    matz
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset(%{friend_id: ezra.id})
    |> Repo.insert()

    matz
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset(%{friend_id: dhh.id})
    |> Repo.insert()

    :ok
  end

  def reset do
    Person
    |> Repo.delete_all()
  end
end
