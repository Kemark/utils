###############################################################################
### Build ###
###############################################################################
FROM harbor.jitpay.local:443/base-images/alpine-node:13-08-0 AS build
# FROM node:12.7-alpine AS build
ARG BUILD_ENV

WORKDIR /usr/

COPY package.json \
package-lock.json \
.npmrc \
tsconfig.* \
angular.json ./

RUN npm install

COPY . .
RUN npm run build:${BUILD_ENV}

###############################################################################
### Run ###
###############################################################################
FROM harbor.jitpay.local:443/base-images/alpine-node:13-08-0 AS final

COPY --from=build /usr/wwwroot /onboarding
RUN npm install angular-http-server -g

CMD angular-http-server --path /onboarding  -p 4200
