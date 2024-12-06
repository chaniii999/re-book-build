# 1. 빌드 스테이지 (Gradle 빌드를 위한 환경)
FROM openjdk:17-jdk-slim AS build

# 작업 디렉토리 설정
WORKDIR /app

# Gradle Wrapper 및 빌드 관련 파일 복사
COPY gradlew /app/
COPY gradle /app/gradle
COPY build.gradle /app/
COPY settings.gradle /app/

# gradlew 실행 권한 부여
RUN chmod +x ./gradlew

# Gradle 의존성 캐싱 및 빌드 (테스트 제외)
RUN ./gradlew clean build -x test

# 2. 실행 스테이지
FROM openjdk:17-jdk-slim

# 작업 디렉토리 설정
WORKDIR /app

# 빌드된 JAR 파일을 복사
COPY --from=build /app/build/libs/*.jar app.jar

# 기본 타임존 설정
ENV TZ=Asia/Seoul

# JAR 파일 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]
