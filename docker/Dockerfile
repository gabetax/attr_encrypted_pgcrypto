FROM ruby:2.7.1

# Install Ubuntu Dependencies
RUN apt-get update && apt-get install -y postgresql-client

ENV BUNDLER_VERSION='2.1.4'
RUN gem install bundler -v '2.1.4'

COPY docker/startup /usr/local/bin/startup
RUN chmod 755 /usr/local/bin/startup

WORKDIR /app

CMD "/usr/local/bin/startup"
