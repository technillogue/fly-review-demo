FROM openjdk:17-bullseye as builder

WORKDIR /app
# Disable gradle daemon
RUN mkdir -p ~/.gradle && echo "org.gradle.daemon=false" >> ~/.gradle/gradle.properties

# Download gradle
COPY gradlew .
RUN mkdir gradle
COPY gradle/ gradle/
RUN ./gradlew

COPY build.gradle.kts gradle.properties settings.gradle.kts ./
#COPY ./build/ /app/build/
COPY ./src/ /app/src/
# Build application
RUN ./gradlew installDist

FROM openjdk:11-slim-bullseye
WORKDIR /app
COPY --from=builder /app/build/install/demo /app/
ENTRYPOINT ["/app/bin/demo"]
