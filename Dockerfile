#FROM 17.0.17_10-jdk-ubi9-minimal
FROM phenompeople/openjdk17:latest
LABEL authors="hcy18"

# 设置工作目录
WORKDIR /app

COPY target/shopmind-gateway-*.jar shopmind-gateway.jar

EXPOSE 8080

# 启动应用
ENTRYPOINT ["java", "-jar", "/app/shopmind-gateway.jar"]
