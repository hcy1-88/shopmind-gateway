FROM crpi-2ya7uhq4uacai3if.cn-hangzhou.personal.cr.aliyuncs.com/shopmind-dev/jdk-17:latest
LABEL authors="hcy18"

# 设置工作目录
WORKDIR /app

COPY target/shopmind-gateway-*.jar shopmind-gateway.jar

EXPOSE 8080

# 启动应用
ENTRYPOINT ["java", "-jar", "/app/shopmind-gateway.jar"]
