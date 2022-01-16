FROM node:14.17.3-alpine
ENV APP_PATH /usr/src/app
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH
COPY package.json yarn.lock $APP_PATH
# Prevent timeout for material-ui/icon (https://labor.ewigleere.net/2021/01/08/yarn_error_there_appears_to_be_trouble_with_your_network/)
RUN yarn install --network-timeout 600000
ADD . $APP_PATH
# EXPOSE 3000 → ローカルでは3333に変更

# For production
RUN NODE_ENV=production yarn build
