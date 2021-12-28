FROM node:14.17.3-alpine
ENV APP_PATH /usr/src/app
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH
COPY package.json yarn.lock $APP_PATH
RUN yarn install
ADD . $APP_PATH
# EXPOSE 3000 → ローカルでは3333に変更

# For production
RUN NODE_ENV=production yarn build
