# 第一阶段：构建
FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/maven:3-openjdk-17 AS builder

WORKDIR /app

COPY pom.xml .

# 👇 使用 Here Document 安全生成 settings.xml
ARG MAVEN_REPO_USERNAME
ARG MAVEN_REPO_PASSWORD

RUN mkdir -p /root/.m2 && \
    cat > /root/.m2/settings.xml <<EOF
<settings>
  <mirrors>
    <mirror>
      <id>aliyun-public</id>
      <mirrorOf>central,jcenter,!shopmind-maven</mirrorOf>
      <name>阿里云公共仓库</name>
      <url>https://maven.aliyun.com/repository/public</url>
    </mirror>
  </mirrors>
  <servers>
    <server>
      <id>shopmind-maven</id>
      <username>${MAVEN_REPO_USERNAME}</username>
      <password>${MAVEN_REPO_PASSWORD}</password>
    </server>
  </servers>
  <profiles>
    <profile>
      <id>shopmind-repo</id>
      <repositories>
        <repository>
          <id>shopmind-maven</id>
          <url>https://packages.aliyun.com/696ccd114a29923eb36066a0/maven/shopmind-maven</url>
          <releases><enabled>true</enabled></releases>
          <snapshots><enabled>true</enabled></snapshots>
        </repository>
      </repositories>
    </profile>
  </profiles>
  <activeProfiles>
    <activeProfile>shopmind-repo</activeProfile>
  </activeProfiles>
</settings>
EOF

# 继续后续步骤
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn package -DskipTests

# 第二阶段
FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/maven:3-openjdk-17
LABEL authors="hcy18"
WORKDIR /app
COPY --from=builder /app/target/shopmind-gateway-*.jar shopmind-gateway.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/shopmind-gateway.jar"]