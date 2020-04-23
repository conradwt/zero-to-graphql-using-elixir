# Zero to GraphQL Using Phoenix

The purpose of this example is to provide details as to how one would go about using GraphQL with the Phoenix Web Framework. Thus, I have created two major sections which should be self explanatory: Quick Installation and Tutorial Installation.

## Getting Started

## Software requirements

- [Elixir 1.8.1 or higher](http://elixir-lang.org/install.html)

- [Phoenix 1.4.5 or higher](http://www.phoenixframework.org/docs/installation)

- PostgreSQL 11.2.0 or higher

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/graphql). (Tag 'graphql')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/graphql).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Quick Installation

1.  clone this repository

    ```bash
    git clone git@github.com:conradwt/zero-to-graphql-using-phoenix.git
    ```

2.  change directory location

    ```bash
    cd /path/to/zero-to-graphql-using-phoenix
    ```

3.  install dependencies

    ```bash
    mix deps.get
    ```

4.  create, migrate, and seed the database

    ```bash
    mix ecto.create
    mix ecto.migrate
    mix ecto.seed
    ```

5.  start the server

    ```bash
    mix phx.server
    ```

6.  navigate to our application within the browser

    ```bash
    open http://localhost:4000/graphiql
    ```

7.  enter and run GraphQL query

    ```graphql
    {
      person(id: 1) {
        firstName
        lastName
        username
        email
        friends {
          firstName
          lastName
          username
          email
        }
      }
    }
    ```

    Note: The GraphQL query is responding with same response but different shape
    within the GraphiQL browser because Elixir Maps perform no ordering on insertion.

## Tutorial Installation

1.  create the project

    ```bash
    mix phx.new zero_phoenix --no-webpack
    ```

    Note: Just answer 'Y' to all the prompts that appear.

2.  rename the project directory

    ```bash
    mv zero_phoenix zero-to-graphql-using-phoenix
    ```

3.  switch to the project directory

    ```bash
    cd zero-to-graphql-using-phoenix
    ```

4.  update `username` and `password` database credentials which appears at the bottom of the following files:

    ```text
    config/dev.exs
    config/test.exs
    ```

5.  create the database

    ```bash
    mix ecto.create
    ```

6.  generate contexts, schemas, and migrations for `Person` resource

    ```bash
    mix phx.gen.context Account Person people first_name:string last_name:string username:string email:string
    ```

7.  replace the generated `Person` model with the following:

    `lib/zero_phoenix/account/person.ex`:

    ```elixir
    defmodule ZeroPhoenix.Account.Person do
      use Ecto.Schema
      import Ecto.Changeset
      alias ZeroPhoenix.Account.Person
      alias ZeroPhoenix.Account.Friendship

      schema "people" do
        field(:email, :string)
        field(:first_name, :string)
        field(:last_name, :string)
        field(:username, :string)

        has_many(:friendships, Friendship)
        has_many(:friends, through: [:friendships, :friend])

        timestamps()
      end

      @doc false
      def changeset(%Person{} = person, attrs) do
        person
        |> cast(attrs, [:first_name, :last_name, :username, :email])
        |> validate_required([:first_name, :last_name, :username, :email])
      end
    end
    ```

8.  migrate the database

    ```bash
    mix ecto.migrate
    ```

9.  generate contexts, schemas, and migrations for `Friendship` resource

    ```bash
    mix phx.gen.context Account Friendship friendships person_id:references:people friend_id:references:people
    ```

10. replace the generated `Friendship` model with the following:

    `lib/zero_phoenix/account/friendship.ex`:

    ```elixir
    defmodule ZeroPhoenix.Account.Friendship do
      use Ecto.Schema
      import Ecto.Changeset
      alias ZeroPhoenix.Account.Person
      alias ZeroPhoenix.Account.Friendship

      @required_fields [:person_id, :friend_id]

      schema "friendships" do
        belongs_to(:person, Person)
        belongs_to(:friend, Person)

        timestamps()
      end

      @doc false
      def changeset(%Friendship{} = friendship, attrs) do
        friendship
        |> cast(attrs, @required_fields)
        |> validate_required(@required_fields)
      end
    end
    ```

    Note: We want `friend_id` to reference the `people` table because our `friend_id` really represents a `Person` model.

11. migrate the database

    ```bash
    mix ecto.migrate
    ```

12. create the seeds file

    `priv/repo/seeds.exs`:

    ```elixir
    alias ZeroPhoenix.Repo
    alias ZeroPhoenix.Account.Person
    alias ZeroPhoenix.Account.Friendship

    # reset the datastore
    Repo.delete_all(Person)

    # insert people
    me = Repo.insert!(%Person{ first_name: "Conrad", last_name: "Taylor", email: "conradwt@gmail.com", username: "conradwt" })
    dhh = Repo.insert!(%Person{ first_name: "David", last_name: "Heinemeier Hansson", email: "dhh@37signals.com", username: "dhh" })
    ezra = Repo.insert!(%Person{ first_name: "Ezra", last_name: "Zygmuntowicz", email: "ezra@merbivore.com", username: "ezra" })
    matz = Repo.insert!(%Person{ first_name: "Yukihiro", last_name: "Matsumoto", email: "matz@heroku.com", username: "matz" })

    me
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset( %{ person_id: me.id, friend_id: matz.id } )
    |> Repo.insert

    dhh
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset( %{ person_id: dhh.id, friend_id: ezra.id } )
    |> Repo.insert

    dhh
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset( %{ person_id: dhh.id, friend_id: matz.id } )
    |> Repo.insert

    ezra
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset( %{ person_id: ezra.id, friend_id: dhh.id } )
    |> Repo.insert

    ezra
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset( %{ person_id: ezra.id, friend_id: matz.id } )
    |> Repo.insert

    matz
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset( %{ person_id: matz.id, friend_id: me.id } )
    |> Repo.insert

    matz
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset( %{ person_id: matz.id, friend_id: ezra.id } )
    |> Repo.insert

    matz
    |> Ecto.build_assoc(:friendships)
    |> Friendship.changeset( %{ person_id: matz.id, friend_id: dhh.id } )
    |> Repo.insert
    ```

13. seed the database

    ```bash
    mix run priv/repo/seeds.exs
    ```

14. add `absinthe_plug` package to your `mix.exs` dependencies as follows:

    ```elixir
    defp deps do
      [
        {:phoenix, "~> 1.4.5"},
        {:phoenix_pubsub, "~> 1.1"},
        {:phoenix_ecto, "~> 4.0"},
        {:ecto_sql, "~> 3.0"},
        {:postgrex, "~> 0.14.1"},
        {:phoenix_html, "~> 2.11"},
        {:phoenix_live_reload, "~> 1.2", only: :dev},
        {:gettext, "~> 0.16.1"},
        {:jason, "~> 1.1"},
        {:plug_cowboy, "~> 2.0"},
        {:absinthe_plug, "~> 1.4"}
      ]
    end
    ```

15. update our projects dependencies:

    ```bash
    mix deps.get
    ```

16. add the GraphQL schema which represents our entry point into our GraphQL structure:

    `lib/zero_phoenix_web/graphql/schema.ex`:

    ```elixir
    defmodule ZeroPhoenixWeb.Graphql.Schema do
      use Absinthe.Schema

      import_types ZeroPhoenix.Graphql.Types.Person

      alias ZeroPhoenix.Repo

      query do
        field :person, type: :person do
          arg :id, non_null(:id)
          resolve fn %{id: id}, _info ->
            case ZeroPhoenix.Person|> Repo.get(id) do
              nil  -> {:error, "Person id #{id} not found"}
              person -> {:ok, person}
            end
          end
        end
      end
    end
    ```

17. add our Person type which will be performing queries against:

    `lib/zero_phoenix_web/graphql/types/person.ex`:

    ```elixir
    defmodule ZeroPhoenixWeb.Graphql.Types.Person do
      use Absinthe.Schema.Notation

      import Ecto

      alias ZeroPhoenix.Repo

      @desc "a person"
      object :person do
        @desc "unique identifier for the person"
        field :id, non_null(:string)

        @desc "first name of a person"
        field :first_name, non_null(:string)

        @desc "last name of a person"
        field :last_name, non_null(:string)

        @desc "username of a person"
        field :username, non_null(:string)

        @desc "email of a person"
        field :email, non_null(:string)

        @desc "a list of friends for our person"
        field :friends, list_of(:person) do
          resolve fn _, %{source: person} ->
            {:ok, Repo.all(assoc(person, :friends))}
          end
        end
      end
    end
    ```

18. add route for mounting the GraphiQL browser endpoint:

    `lib/zero_phoenix_web/router.ex`:

    ```elixir
    scope "/graphiql" do
      pipe_through :api

      forward "/",
              Absinthe.Plug.GraphiQL,
              schema: ZeroPhoenixWeb.Graphql.Schema,
              json_codec: Jason,
              interface: :simple
    end
    ```

19. start the server

    ```bash
    mix phx.server
    ```

20. navigate to our application within the browser

    ```bash
    open http://localhost:4000/graphiql
    ```

21. enter the GraphQL query on the left side of the browser

    ```graphql
    {
      person(id: 1) {
        firstName
        lastName
        username
        email
        friends {
          firstName
          lastName
          username
          email
        }
      }
    }
    ```

22. run the GraphQL query

    ```text
    Control + Enter
    ```

    Note: The GraphQL query is responding with same response but different shape
    within the GraphiQL browser because Elixir Maps perform no ordering on insertion.

## Production Setup

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Phoenix References

- Official website: http://www.phoenixframework.org/
- Guides: http://phoenixframework.org/docs/overview
- Docs: https://hexdocs.pm/phoenix
- Mailing list: http://groups.google.com/group/phoenix-talk
- Source: https://github.com/phoenixframework/phoenix

## GraphQL References

- Official Website: http://graphql.org
- Absinthe GraphQL Elixir: http://absinthe-graphql.org

## Support

Bug reports and feature requests can be filed with the rest for the Phoenix project here:

- [File Bug Reports and Features](https://github.com/conradwt/zero-to-graphql-using-phoenix/issues)

## License

Zero to GraphQL Using Phoenix is released under the [MIT license](https://mit-license.org).

## Copyright

copyright:: (c) Copyright 2018 - 2019 Conrad Taylor. All Rights Reserved.
