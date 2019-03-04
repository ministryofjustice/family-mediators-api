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

ARG BUILD_DATE
ENV BUILD_DATE ${BUILD_DATE}

ARG BUILD_TAG
ENV BUILD_TAG ${BUILD_TAG}

ARG GIT_COMMIT
ENV GIT_COMMIT ${GIT_COMMIT}

ENTRYPOINT ["./run.sh"]
