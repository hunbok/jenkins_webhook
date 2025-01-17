# 빌드 단계
FROM gradle:8.12-jdk17-alpine AS build

WORKDIR /app

COPY /app/build.gradle .
COPY /app/settings.gradle .
COPY /app/src ./src
COPY build.gradle settings.gradle.
RUN gradle build --no-daemon -x test

# 실행 단계
FROM amazoncorretto:17-alpine

WORKDIR /app

COPY build.gradle settings.gradle.
COPY gradle ./gradle
RUN gradle dependencise --no-daemon

COPY src ./src
COPY gradle build --no-daemon -x test

ENV JAVA_OPTS="-Xms512m -Xmx512m"
ENV SERVER_PORT=8080

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar"]