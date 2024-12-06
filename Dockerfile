# 1단계: 빌드 환경
FROM openjdk:17-jdk-slim AS build


# Gradle Wrapper 파일 복사
COPY gradlew .
COPY gradle /gradle
COPY build.gradle .
COPY settings.gradle .

# 실행 권한 부여
RUN chmod +x ./gradlew

# 소스 코드 복사 및 Gradle 빌드 (테스트 제외)
COPY . /app
RUN ./gradlew clean build -x test

# 2단계: 실행 환경
FROM openjdk:17-jdk-slim

COPY --from=build /app/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]

