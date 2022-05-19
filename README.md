# Zero to GraphQL Using Elixir

The purpose of this example is to provide details as to how one would go about using GraphQL with the Elixir Language. Thus, I have created two major sections which should be self explanatory: Quick Installation and Tutorial Installation.

## Getting Started

## Software requirements

- Elixir 1.13.4 or newer

- Erlang 25.0 or newer

- Phoenix 1.6.9 or newer

- PostgreSQL 14.1 or newer

Note: This tutorial was updated on macOS 12.4.

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/absinthe). (Tag 'absinthe')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/absinthe).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Quick Installation

1.  clone this repository

    ```zsh
    git clone https://github.com/conradwt/zero-to-graphql-using-elixir.git
    ```

2.  change directory location

    ```zsh
    cd zero-to-graphql-using-elixir
    ```

3.  install and compile dependencies

    ```zsh
    mix do deps.get, deps.compile
    ```

4.  create, migrate, and seed the database

    ```zsh
    mix ecto.setup
    ```

5.  start the server

    ```zsh
    mix phx.server
    ```

6.  navigate to our application within the browser

    ```zsh
    open http://localhost:4000/graphiql
    ```

7.  enter the below GraphQL query on the left side of the browser window

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

8.  run the GraphQL query

    ```text
    Control + Enter
    ```

    Note: The GraphQL query is responding with same response but different shape
    within the GraphiQL browser because Elixir Maps perform no ordering on insertion.

## Tutorial Installation

1.  create the project

    ```zsh
    mix phx.new zero-to-graphql-using-elixir \
      --app zero_phoenix \
      --module ZeroPhoenix \
      --no-html \
      --no-assets
    ```

    Note: Just answer 'y' to all the prompts that appear.

2.  switch to the project directory

    ```zsh
    cd zero-to-graphql-using-elixir
    ```

3.  update `username` and `password` database credentials which appears at the bottom of the following files:

    ```text
    config/dev.exs
    config/test.exs
    ```

4.  create the database

    ```zsh
    mix ecto.create
    ```

5.  generate contexts, schemas, and migrations for the `Person` resource

    ```zsh
    mix phx.gen.context Accounts Person people first_name:string last_name:string username:string email:string
    ```

6.  replace the generated `Person` schema with the following:

    `lib/zero_phoenix/account/person.ex`:

    ```elixir
    defmodule ZeroPhoenix.Accounts.Person do
      use Ecto.Schema

      import Ecto.Changeset

      alias ZeroPhoenix.Accounts.Friendship
      alias ZeroPhoenix.Accounts.Person

      schema "people" do
        field :email, :string
        field :first_name, :string
        field :last_name, :string
        field :username, :string

        has_many :friendships, Friendship
        has_many :friends, through: [:friendships, :friend]

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

7.  migrate the database

    ```zsh
    mix ecto.migrate
    ```

8.  generate contexts, schemas, and migrations for the `Friendship` resource

    ```zsh
    mix phx.gen.context Accounts Friendship friendships person_id:references:people friend_id:references:people
    ```

9.  replace the generated `CreateFriendship` migration with the following:

    `priv/repo/migrations/<some datetime>_create_friendship.exs`:

    ```elixir
    defmodule ZeroPhoenix.Repo.Migrations.CreateFriendship do
      use Ecto.Migration

      def change do
        create table(:friendships) do
          add :person_id, references(:people, on_delete: :delete_all)
          add :friend_id, references(:people, on_delete: :delete_all)

          timestamps()
        end

        create index(:friendships, [:person_id])
        create index(:friendships, [:friend_id])
      end
    end
    ```

10. replace the generated `Friendship` schema with the following:

    `lib/zero_phoenix/accounts/friendship.ex`:

    ```elixir
    defmodule ZeroPhoenix.Accounts.Friendship do
      use Ecto.Schema

      import Ecto.Changeset

      alias ZeroPhoenix.Accounts.Friendship
      alias ZeroPhoenix.Accounts.Person

      @required_fields [:person_id, :friend_id]

      schema "friendships" do
        belongs_to :person, Person
        belongs_to :friend, Person

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

    Note: We want `friend_id` to reference the `people` table because our `friend_id` really represents a `Person` schema.

11. migrate the database

    ```zsh
    mix ecto.migrate
    ```

12. create dev support directory

    ```zsh
    mkdir -p dev/support
    ```

13. update the search for compiler within `mix.exs`:

    change:

    ```elixir
    defp elixirc_paths(:test), do: ["lib", "test/support"]
    defp elixirc_paths(_), do: ["lib"]
    ```

    to:

    ```elixir
    defp elixirc_paths(:test), do: ["lib", "dev/support", "test/support"]
    defp elixirc_paths(:dev), do: ["lib", "dev/support"]
    defp elixirc_paths(_), do: ["lib"]
    ```

14. create `seeds.ex` support file with the following content:

    `dev/support/seeds.ex`:

    ```zsh
    defmodule ZeroPhoenix.Seeds do
      alias ZeroPhoenix.Accounts.{Person, Friendship}
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
    ```

15. update the `seeds.exs` file with the following content:

    `priv/repo/seeds.exs`:

    ```elixir
    ZeroPhoenix.Seeds.run()
    ```

16. seed the database

    ```zsh
    mix run priv/repo/seeds.exs
    ```

17. add `absinthe_plug` and `ataloader` hex package dependencies as follows:

    `mix.exs`:

    ```elixir
    defp deps do
      [
        {:phoenix, "~> 1.6.9"},
        {:phoenix_ecto, "~> 4.4"},
        {:ecto_sql, "~> 3.7.1"},
        {:postgrex, "~> 0.15.9"},
        {:phoenix_live_dashboard, "~> 0.6.5"},
        {:swoosh, "~> 1.6.6"},
        {:telemetry_metrics, "~> 0.6.1"},
        {:telemetry_poller, "~> 1.0.0"},
        {:gettext, "~> 0.19.1"},
        {:jason, "~> 1.3.0"},
        {:plug_cowboy, "~> 2.5.2"},
        {:absinthe, "~> 1.7.0"},
        {:absinthe_plug, "~> 1.5.8"},
        {:cors_plug, "~> 3.0.3"}
      ]
    end
    ```

18. install and compile dependencies

    ```zsh
    mix do deps.get, deps.compile
    ```

19. configure `CORSPlug` by adding the following content:

    `lib/zero_phoenix_web/endpoint.ex`:

    ```elixir
    plug CORSPlug, origin: ["*"]
    ```

    Note: The above code should be added right before the following line:

    ```elixir
    plug(ZeroPhoenixWeb.Router)
    ```

20. create the GraphQL directory structure

    ```zsh
    mkdir -p lib/zero_phoenix_web/graphql/{resolvers,schemas/{queries,mutations},types}
    ```

21. add the GraphQL schema which represents our entry point into our GraphQL structure:

    `lib/zero_phoenix_web/graphql/schema.ex`:

    ```elixir
    defmodule ZeroPhoenixWeb.GraphQL.Schema do
      use Absinthe.Schema

      import_types(ZeroPhoenixWeb.GraphQL.Types.Person)

      import_types(ZeroPhoenixWeb.GraphQL.Schemas.Queries.Person)

      query do
        import_fields(:person_queries)
      end
    end
    ```

22. add our Person type which will be performing queries against:

    `lib/zero_phoenix_web/graphql/types/person.ex`:

    ```elixir
    defmodule ZeroPhoenixWeb.GraphQL.Types.Person do
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

23. add the `person_queries` object to contain all the queries for a person:

    `lib/zero_phoenix_web/graphql/schemas/queries/person.ex`:

    ```elixir
    defmodule ZeroPhoenixWeb.GraphQL.Schemas.Queries.Person do
      use Absinthe.Schema.Notation

      object :person_queries do
        field :person, type: :person do
          arg :id, non_null(:id)

          resolve(&ZeroPhoenixWeb.GraphQL.Resolvers.PersonResolver.find/3)
        end
      end
    end
    ```

24. add the `PersonResolver` to fetch the individual fields of our person object:

    `lib/zero_phoenix_web/graphql/resolvers/person_resolver.ex`:

    ```elixir
    defmodule ZeroPhoenixWeb.GraphQL.Resolvers.PersonResolver do
      alias ZeroPhoenix.Accounts
      alias ZeroPhoenix.Accounts.Person

      def find(_parent, %{id: id}, _info) do
        case Accounts.get_person(id) do
          %Person{} = person ->
            {:ok, person}

          _error ->
            {:error, "Person id #{id} not found"}
        end
      end
    end
    ```

25. add routes for our GraphQL API and GraphiQL browser endpoints:

    `lib/zero_phoenix_web/router.ex`:

    replace

    ```elixir
    scope "/api", ZeroPhoenixWeb do
      pipe_through :api
    end
    ```

    with

    ```elixir
    scope "/" do
      pipe_through :api

      if Mix.env() in [:dev, :test] do
        forward "/graphiql",
          Absinthe.Plug.GraphiQL,
          schema: ZeroPhoenixWeb.GraphQL.Schema,
          json_codec: Jason,
          interface: :playground
      end

      forward "/api",
        Absinthe.Plug,
        schema: ZeroPhoenixWeb.GraphQL.Schema
    end
    ```

26. start the server

    ```zsh
    mix phx.server
    ```

27. navigate to our application within the browser

    ```zsh
    open http://localhost:4000/graphiql
    ```

28. enter the below GraphQL query on the left side of the browser window

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

29. run the GraphQL query

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

- [File Bug Reports and Features](https://github.com/conradwt/zero-to-graphql-using-elixir/issues)

## License

Zero to GraphQL Using Elixir is released under the [MIT license](./LICENSE.md).

## Copyright

copyright:: (c) Copyright 2018 - 2022 Conrad Taylor. All Rights Reserved.
