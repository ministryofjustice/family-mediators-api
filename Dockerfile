FROM ministryofjustice/ruby:2.3.1-webapp-onbuild

RUN touch /etc/inittab
RUN apt-key adv --keyserver pgp.mit.edu --recv 9D41F3C3 && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    wget -qO- https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get update
RUN apt-get install -y yarn && apt-get upgrade -y
RUN yarn

WORKDIR /usr/src/app
ENTRYPOINT ["./run.sh"]
