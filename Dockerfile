#FROM 17.0.17_10-jdk-ubi9-minimal
FROM phenompeople/openjdk17:latest
LABEL authors="hcy18"

# 设置工作目录
WORKDIR /app

COPY target/shopmind-gateway-*.jar shopmind-gateway.jar

EXPOSE 8080

# 启动应用
ENTRYPOINT ["java", "-jar", "/app/shopmind-gateway.jar"]

# 启动命令：前面是宿主机端口
#docker run -d --name shopmind-gateway -p 8080:8080 shopmind-gateway:latest --spring.cloud.nacos.server-addr=host.docker.internal:8848 --spring.cloud.nacos.username=nacos --spring.cloud.nacos.password=nacos --spring.cloud.nacos.config.namespace=shopmind-dev --spring.cloud.nacos.discovery.namespace=shopmind-dev --spring.cloud.nacos.config.group=DEFAULT_GROUP --spring.cloud.nacos.discovery.group=DEFAULT_GROUP