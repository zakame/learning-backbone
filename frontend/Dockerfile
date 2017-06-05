FROM node:6.10

COPY package.json yarn.lock /code/
WORKDIR /code

ENV PATH /node_modules/.bin:$PATH
RUN mkdir /node_modules && \
    yarn install --modules-folder /node_modules

COPY . /code/
RUN chown -R node:users /code /node_modules
VOLUME /node_modules

USER node:users
