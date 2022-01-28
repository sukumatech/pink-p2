FROM node:15.4 as build

WORKDIR /app

COPY package*.json ./
RUN npm install 
COPY . .
RUN npm run build

#second stage
FROM nginx:stable-alpine

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/build /usr/share/nginx/html
#EXPOSE 80
