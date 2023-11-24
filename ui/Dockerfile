FROM node:16.20-slim AS build

WORKDIR /usr/src/app
COPY ui/package.json ui/yarn.lock ./
RUN yarn install
COPY ui .
RUN yarn build


FROM nginx:stable-alpine

COPY --from=build /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
