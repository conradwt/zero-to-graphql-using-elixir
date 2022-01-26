defmodule ZeroPhoenixWeb.Graphql.Types.PersonInput do
  use Absinthe.Schema.Notation

  @desc "a person input"
  input_object :person_input do
    @desc "first name of a person"
    field(:first_name, non_null(:string))

    @desc "last name of a person"
    field(:last_name, non_null(:string))

    @desc "username of a person"
    field(:username, non_null(:string))

    @desc "email of a person"
    field(:email, non_null(:string))
  end
end
