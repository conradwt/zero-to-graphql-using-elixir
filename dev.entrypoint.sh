#!/bin/sh

set -e

echo "Environment: $MIX_ENV"

# install missing packages
mix do deps.get, deps.compile

# run any pending migrations
mix ecto.migrate

# Then exec the container's main process
# (what's set as CMD in the Dockerfile).
exec ${@}
