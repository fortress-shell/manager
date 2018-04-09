FROM ruby:2.5

ENV RAILS_ENV production

ENV APP app

ENV APP_DIR /home/$APP

RUN useradd --create-home $APP

WORKDIR $APP_DIR

COPY . $APP_DIR

RUN bundle install

RUN chown -R $APP:$APP $APP_DIR

USER $APP

ENTRYPOINT rails s
