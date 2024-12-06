# Gradle 이미지 기반으로 빌드
FROM gradle:7.4-jdk17 AS build

# 작업 디렉토리 설정
WORKDIR /app

# 코드 복사
COPY . .

# Gradle 빌드 실행 (테스트 제외)
RUN ./gradlew clean build -x test

# 실제 실행 환경 설정
FROM openjdk:17-jdk-alpine

# 작업 디렉토리 설정
WORKDIR /app

# 빌드된 JAR 파일 복사
COPY --from=build /app/build/libs/*.jar app.jar

# JAR 파일 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
