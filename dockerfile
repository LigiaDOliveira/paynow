FROM ruby:3.0.1

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update

RUN apt-get install -y nodejs
RUN npm install -g yarn

WORKDIR /opt/paynow

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle