FROM node:16-alpine

RUN apk add --no-cache yarn bash
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn --pure-lockfile

COPY . .

