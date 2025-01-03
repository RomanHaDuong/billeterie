# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.5
FROM --platform=linux/arm64/v8 registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV RAILS_ENV="production" \
  BUNDLE_DEPLOYMENT="1" \
  BUNDLE_PATH="/usr/local/bundle" \
  BUNDLE_WITHOUT="development" \
  BUNDLE_BUILD__SASSC=--disable-march-tune-native

FROM base as build

# Install all dependencies in one layer
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y \
  build-essential \
  git \
  libvips \
  pkg-config \
  libssl-dev \
  zlib1g-dev \
  gcc \
  make \
  libc6-dev \
  nodejs \
  npm && \
  rm -rf /var/lib/apt/lists/*

# Copy Gemfiles first for better caching
COPY Gemfile Gemfile.lock ./

# Install sassc separately first to avoid ARM64 compilation issues
RUN gem install sassc:2.4.0 --disable-march-tune-native && \
  gem install msgpack --disable-march-tune-native

# Single bundle install
RUN bundle config set --local frozen false && \
  bundle install && \
  rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .

# Precompile bootsnap and assets
RUN bundle exec bootsnap precompile app/ lib/ && \
  SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

FROM base

# Install runtime dependencies only
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y curl libsqlite3-0 libvips && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN mkdir -p db log storage tmp && \
  useradd rails --create-home --shell /bin/bash && \
  chown -R rails:rails db log storage tmp

USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
