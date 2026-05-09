FROM eclipse-temurin:17-jdk-jammy

RUN apt-get update && apt-get install -y maven
app

COPY pom.xml .
COPY src ./src
WORKDIR /

RUN mvn clean package -DskipTests

EXPOSE 7860

CMD ["java", "-jar", "target/MoroccoCraft.jar"]