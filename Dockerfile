FROM node AS build
WORKDIR /app

COPY . .
RUN npm install
RUN npm run build

FROM node AS base
RUN apt update && apt install -y firefox-esr

FROM base
ENV PUPPETEER_BROWSER=firefox
WORKDIR /app

COPY --from=build /app/dist/index.js /app/dist/index.js
COPY --from=build /app/dist/index.js.map /app/dist/index.js.map
COPY --from=build /app/node_modules /app/node_modules
COPY --from=build /app/bin/get-comics.js /app/bin/get-comics.js

#RUN npm approve-scripts puppeteer
RUN npx puppeteer browsers install firefox

ENTRYPOINT ["node","bin/get-comics.js", "-o", "/download"]
