FROM alpine AS base

ARG MINECRAFT_VERSION=1.20.4
ARG PAPERMC_API_HOST=https://api.papermc.io

FROM base AS builder

WORKDIR /minecraft

RUN apk add curl jq

RUN curl -o builds.json ${PAPERMC_API_HOST}/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds

RUN jq -r ".builds[-1].downloads.application.name" < builds.json > filename 
RUN jq -r ".builds[-1].build" < builds.json > buildn 

RUN curl -o server.jar ${PAPERMC_API_HOST}/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/$(cat buildn)/downloads/$(cat filename)

FROM base AS runner

RUN apk add openjdk17 screen

run addgroup --system --gid 1001 minecraft
RUN adduser --system --uid 1001 -G minecraft minecraft 

WORKDIR /home/minecraft

COPY --from=builder /minecraft/server.jar .
COPY ./start.sh . 

RUN chown -R minecraft:minecraft /home/minecraft

USER minecraft 

RUN echo "eula=true" > eula.txt

VOLUME /home/minecraft

EXPOSE 25565/tcp
EXPOSE 25565/udp

CMD ["screen", "/home/minecraft/start.sh"]
