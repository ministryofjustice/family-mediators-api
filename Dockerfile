FROM ruby:3.3.4-alpine as base

WORKDIR /app

RUN apk --no-cache add \
    postgresql-client

# Ensure latest rubygems is installed
RUN gem update --system

FROM base as builder

RUN apk --no-cache add \
    ruby-dev \
    build-base \
    postgresql-dev \
    nodejs \
    yarn

COPY .ruby-version Gemfile* package.json api.apib ./

RUN bundle config deployment true && \
    bundle config without development test && \
    bundle install --jobs 4 --retry 3 && \
    yarn install --frozen-lockfile

COPY . .

# create documentation directory for api docs
RUN mkdir -p documentation

# Produce the API documentation (using `aglio`)
RUN yarn build

# Cleanup to save space in the production image
RUN rm -rf node_modules log/* tmp/* /tmp && \
    rm -rf /usr/local/bundle/cache

# Build runtime image
FROM base

# add non-root user and group with alpine first available uid, 1000
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

# Copy files generated in the builder image
COPY --from=builder /app /app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

# Create log and tmp
RUN mkdir -p log tmp
RUN chown -R appuser:appgroup ./*

# Set user
USER 1000

ARG APP_BUILD_DATE
ARG APP_BUILD_TAG
ARG APP_GIT_COMMIT
ENV APP_BUILD_DATE ${APP_BUILD_DATE}
ENV APP_BUILD_TAG ${APP_BUILD_TAG}
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT}
