FROM ruby:2.3
ADD Gemfile /Gemfile

RUN gem install jekyll bundler;\
    bundle install
