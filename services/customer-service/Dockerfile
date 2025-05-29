ARG RUBY_VERSION=3.4.4
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

# Set working directory
WORKDIR /rails

# Install base system dependencies
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
      curl \
      libjemalloc2 \
      postgresql-client \
 && rm -rf /var/lib/apt/lists/*

# Default to production Rails env
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# ────────────────────────────────────────────────────────────────────────────────
# Build stage: install gems and compile bootsnap
# ────────────────────────────────────────────────────────────────────────────────
FROM base AS build

# Install build-time tools
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      libyaml-dev \
      pkg-config \
 && rm -rf /var/lib/apt/lists/*

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install \
 && rm -rf ~/.bundle "${BUNDLE_PATH}"/ruby/*/cache \
 && bundle exec bootsnap precompile --gemfile

# Copy app code & precompile Bootsnap caches
COPY . .
RUN bundle exec bootsnap precompile app/ lib/ \
 && chmod +x bin/* \
 && sed -i "s/\r$//g" bin/* \
 && sed -i 's/ruby\.exe$/ruby/' bin/*

# ────────────────────────────────────────────────────────────────────────────────
# Final stage: runtime image
# ────────────────────────────────────────────────────────────────────────────────
FROM base

# Copy gems and application code from build
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Create rails user and ensure swagger output directory is writable
RUN groupadd --system --gid 1000 rails \
 && useradd --system --uid 1000 --gid 1000 --create-home --shell /bin/bash rails \
 && mkdir -p /rails/swagger/v1 \
 && chown -R rails:rails /rails/db /rails/log /rails/tmp /rails/swagger

# Switch to non-root
USER rails:rails

# Entrypoint handles waiting for DB and running migrations
ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]

# Expose HTTP port
EXPOSE 80

# Default to Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
