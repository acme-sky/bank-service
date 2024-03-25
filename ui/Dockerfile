# build stage
FROM node:16-alpine as build-stage
WORKDIR /app
COPY package*.json ./

ARG VITE_APP_BACKEND_URL 

RUN npm install
RUN npx browserslist@latest --update-db
COPY . .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY ./nginx.conf /temp/prod.conf
RUN envsubst /app < /temp/prod.conf > /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
