mint build --env DATABASE_URL=ecto://postgres:postres@localhost:5432/zero_phoenix_dev \
 --env SECRET_KEY_BASE=`mix phx.gen.secret` \
 --copy-meta-artifacts . \
 conradwt/zero-to-graphql-using-elixir:v3.6.0
