# 첫번째 스테이지 -> 빌드 영역
FROM openjdk:17-jdk-slim AS build

# 소스코드 복사
WORKDIR /app

# Gradle Wrapper 및 종속성 복사
COPY gradlew /app/
COPY gradle /app/gradle
COPY build.gradle /app/
COPY settings.gradle /app/

# gradlew 실행 권한 부여 (여기서 권한을 먼저 설정)
RUN chmod +x gradlew

# Gradle 종속성 캐싱
RUN ./gradlew dependencies --no-daemon

# gradle wrapper로 빌드
COPY . /app
RUN ./gradlew clean build -x test

# 새로운 스테이지 -> 실행 영역
FROM openjdk:17-jdk-slim

# build라는 별칭으로 이루어진 스테이지에서 *.jar 파일을 app.jar로 복사해서 이미지에 세팅.
COPY --from=build /app/build/libs/*.jar app.jar

# CMD는 기본 실행 명령어를 의미. 컨테이너 실행 시에 다른 명령어가 주어지면 그 명령어로 대체됨.
# ENTRYPOINT는 반드시 실행되어야 할 명령어를 의미. 다른 명령어로 대체되지 않음.
ENTRYPOINT ["java", "-jar", "app.jar"]
