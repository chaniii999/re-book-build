# 1단계: 빌드 환경
FROM openjdk:17-jdk-slim AS build

WORKDIR /app

# Gradle Wrapper 파일 복사
COPY gradlew /app/
COPY gradle /app/gradle
COPY build.gradle /app/
COPY settings.gradle /app/

# 실행 권한 부여
RUN chmod +x ./gradlew

# 소스 코드 복사 및 Gradle 빌드 (테스트 제외)
COPY . /app
RUN ./gradlew clean build -x test

# 2단계: 실행 환경
FROM openjdk:17-jdk-slim

COPY --from=build /app/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-Dspring.config.additional-location=/app/config/", "-jar", "app.jar"]

