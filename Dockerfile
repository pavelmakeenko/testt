FROM node:lts-alpine as build-deps

ARG BUILD=default

WORKDIR /usr/src/app
COPY package.json ./
COPY package-lock.json ./
RUN npm ci

COPY . ./

ENV BUILD ${BUILD}
RUN npm run build

FROM nginx:1.12-alpine
COPY --from=build-deps /usr/src/app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]