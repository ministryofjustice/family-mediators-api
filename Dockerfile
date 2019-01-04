FROM ministryofjustice/ruby:2.3.1-webapp-onbuild

RUN touch /etc/inittab

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get install -y yarn
RUN yarn

WORKDIR /usr/src/app
ENTRYPOINT ["./run.sh"]
