FROM ministryofjustice/ruby:2.5.3-webapp-onbuild AS base

WORKDIR /usr/src/app
RUN mkdir ./documentation


FROM base AS documentation

RUN touch /etc/inittab

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get install -y nodejs yarn

COPY package.json yarn.lock api.apib ./
RUN yarn install --frozen-lockfile

# Produce the API documentation (using `aglio`)
RUN npm run-script build


FROM base

COPY --from=documentation /usr/src/app/documentation/output.html ./documentation/output.html

ENV RACK_ENV production

ARG BUILD_DATE
ENV BUILD_DATE ${BUILD_DATE}

ARG BUILD_TAG
ENV BUILD_TAG ${BUILD_TAG}

ARG GIT_COMMIT
ENV GIT_COMMIT ${GIT_COMMIT}

# Run the application as user `moj` (created in the base image)
# uid=1000(moj) gid=1000(moj) groups=1000(moj)
# Some directories/files need to be chowned otherwise we get Errno::EACCES
#
RUN chown $APPUSER:$APPUSER ./db/schema.rb

ENV APPUID 1000
USER $APPUID

ENTRYPOINT ["./run.sh"]
