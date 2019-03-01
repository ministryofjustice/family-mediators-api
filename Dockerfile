FROM ministryofjustice/ruby:2.3.1-webapp-onbuild AS base

WORKDIR /usr/src/app
RUN mkdir ./documentation


FROM base AS documentation

RUN touch /etc/inittab

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get install -y yarn

COPY package.json yarn.lock api.apib ./
RUN yarn install --frozen-lockfile

# Produce the API documentation (using `aglio`)
RUN npm run-script build


FROM base

COPY --from=documentation /usr/src/app/documentation/output.html ./documentation/output.html

ARG APP_BUILD_DATE
ENV APP_BUILD_DATE ${APP_BUILD_DATE}

ARG APP_BUILD_TAG
ENV APP_BUILD_TAG ${APP_BUILD_TAG}

ARG APP_GIT_COMMIT
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT}

ARG APP_VERSION
ENV APP_VERSION ${APP_VERSION}

ENTRYPOINT ["./run.sh"]
