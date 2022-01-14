##
## Base
##

FROM ruby:3.0.2-alpine3.14 as base

# labels from https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.authors=conradwt@gmail.com
LABEL org.opencontainers.image.created=$CREATED_DATE
LABEL org.opencontainers.image.revision=$SOURCE_COMMIT
LABEL org.opencontainers.image.title="Zero To GraphQL Using Rails"
LABEL org.opencontainers.image.url=https://hub.docker.com/u/conradwt/zero-rails
LABEL org.opencontainers.image.source=https://github.com/conradwt/zero-to-graphql-using-rails
LABEL org.opencontainers.image.licenses=MIT
LABEL com.conradtaylor.ruby_version=$RUBY_VERSION

# set this with shell variables at build-time.
# If they aren't set, then not-set will be default.
ARG CREATED_DATE=not-set
ARG SOURCE_COMMIT=not-set

# environment variables
ENV APP_PATH /app
ENV BUNDLE_PATH /usr/local/bundle/gems
ENV TMP_PATH /tmp/
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_PORT 3000

# create application user.
RUN addgroup --gid 1000 darnoc \
  && adduser --uid 1000 --ingroup darnoc --shell /bin/bash --home darnoc

# copy entrypoint scripts and grant execution permissions
# COPY ./dev-docker-entrypoint.sh /usr/local/bin/dev-entrypoint.sh
# COPY ./test-docker-entrypoint.sh /usr/local/bin/test-entrypoint.sh
# RUN chmod +x /usr/local/bin/dev-entrypoint.sh && chmod +x /usr/local/bin/test-entrypoint.sh

#
# https://pkgs.alpinelinux.org/packages?name=&branch=v3.13
#

# install build and runtime dependencies
RUN apk -U add --no-cache \
  build-base=0.5-r2 \
  bzip2=1.0.8-r1 \
  ca-certificates=20191127-r5 \
  curl=7.78.0-r0 \
  fontconfig=2.13.1-r4 \
  postgresql-dev=13.4-r0 \
  tini=0.19.0-r0 \
  tzdata=2021a-r0 && \
  rm -rf /var/cache/apk/* && \
  mkdir -p $APP_PATH

ENV RAILS_ENV=production

EXPOSE ${RAILS_PORT}
ENV PORT ${RAILS_PORT}

WORKDIR ${APP_PATH}

COPY Gemfile* ./

RUN gem install bundler && \
  rm -rf ${GEM_HOME}/cache/*
RUN bundle config set without 'development test'
RUN bundle check || bundle install --jobs 20 --retry 5

ENTRYPOINT ["/sbin/tini", "--"]

# Why should this go into `base` instead of `prod` stage?
# CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production"]

##
## Development
##

FROM base as dev

ENV RAILS_ENV=development

# RUN bundle config list
RUN bundle config --delete without
RUN bundle config --delete with
RUN bundle check || bundle install --jobs 20 --retry 5

# uninstall our build dependencies
# RUN apk del build-dependencies

# Add a script to be executed every time the container starts.
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]

USER darnoc

CMD ["rails", "server", "-b", "0.0.0.0"]

##
## Test
##

FROM dev as test

COPY . .

RUN bundle exec rspec

##
## Pre-Production
##

FROM test as pre-prod

USER root

RUN rm -rf ./spec

##
## Production
##

FROM base as prod

COPY --from=pre-prod /app /app

HEALTHCHECK CMD curl http://127.0.0.1/ || exit 1

USER darnoc

CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production"]
