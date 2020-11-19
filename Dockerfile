FROM ruby:2.7.2-alpine

ENV BUNDLER_VERSION=2.1.4

RUN gem install bundler -v ${BUNDLER_VERSION}

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install

COPY . .

ENTRYPOINT ["ruby","lib/account_movements.rb"]
