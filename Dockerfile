FROM ruby:2.7.2-alpine as base
MAINTAINER UCPD Cross Justice Delivery

# build dependencies:
#   - virtual: create virtual package for later deletion
#   - build-base for alpine fundamentals
#   - libxml2-dev/libxslt-dev for nokogiri, at least
#   - postgresql-dev for pg/activerecord gems
#
RUN apk --no-cache add --virtual build-deps \
  build-base \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev \
  bash \
  curl \
&& apk --no-cache add \
  postgresql-client \
  linux-headers \
  xz-libs \
  tzdata

# ensure everything is executable
RUN chmod +x /usr/local/bin/*

# add non-root user and group with alpine first available uid, 1000
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

# create app directory in conventional, existing dir /usr/src
RUN mkdir -p /usr/src/app && mkdir -p /usr/src/app/tmp

# create documentation directory for api docs
RUN mkdir -p /usr/src/app/documentation

WORKDIR /usr/src/app

COPY Gemfile* .ruby-version ./

RUN gem install bundler -v 2.1.4 && \
    bundle config set frozen 'true' && \
    bundle config without test:development && \
    bundle install --jobs 2 --retry 3

COPY . .

#### begin documentation ####

FROM base AS documentation

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/main/ \
  nodejs=8.9.3-r1 \
  yarn \
  python3

COPY package.json api.apib ./
RUN yarn install --frozen-lockfile

# Produce the API documentation (using `aglio`)
RUN npm run-script build

#### end documentation ####

FROM base

COPY --from=documentation /usr/src/app/documentation/output.html ./documentation/output.html

# tidy up installation
RUN apk del build-deps && rm -rf /tmp/*

# non-root/appuser should own only what they need to
RUN chown -R appuser:appgroup tmp db

ENV RACK_ENV production

ARG BUILD_DATE
ENV BUILD_DATE ${BUILD_DATE}

ARG BUILD_TAG
ENV BUILD_TAG ${BUILD_TAG}

ARG GIT_COMMIT
ENV GIT_COMMIT ${GIT_COMMIT}

ENV APPUID 1000
USER $APPUID

ENTRYPOINT ["./run.sh"]
