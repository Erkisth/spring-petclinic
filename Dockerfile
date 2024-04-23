FROM eclipse-temurin:21.0.2_13-jre-alpine
COPY ./target/spring-petclinic*.jar /jar/spring-petclinic.jar
CMD ["java", "-jar", "-Dspring.profiles.active=postgres", "/jar/spring-petclinic.jar"]
