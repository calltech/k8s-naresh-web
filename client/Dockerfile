FROM  openjdk:8-jdk

COPY build/libs/*.jar /app/service.jar

EXPOSE 8080

CMD ["java", "-jar", "/app/service.jar"]