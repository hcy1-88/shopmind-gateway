# ShopMind Gateway

API 网关服务，为 ShopMind 微服务架构提供统一入口和流量管理。

## 功能定位

ShopMind Gateway 是基于 Spring Cloud Gateway 构建的 API 网关服务，负责统一接收所有外部请求，并将其路由到后端微服务。主要功能包括：

- **统一入口**：作为系统的唯一对外入口，统一管理所有外部访问
- **服务路由**：根据请求路径、Header 等条件将请求路由到不同的微服务
- **负载均衡**：结合 Nacos 服务发现实现服务实例的负载均衡
- **服务发现**：集成 Nacos Discovery，自动发现并管理后端微服务实例
- **配置管理**：集成 Nacos Config，实现配置的动态管理和热更新

## 技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| Java | 17 | 基础开发语言 |
| Spring Boot | - | 应用框架 |
| Spring Cloud Gateway | - | API 网关核心框架 |
| Nacos Discovery | - | 服务注册与发现 |
| Nacos Config | - | 配置中心 |
| Spring Cloud LoadBalancer | - | 客户端负载均衡 |
| shopmind-spring-boot-starter | 1.0-SNAPSHOT | 自定义项目 Starter |

## 项目结构

```
shopmind-gateway
├── src
│   └── main
│       ├── java/com/shopmind/gateway
│       │   └── ShopmindGatewayApplication.java    # 应用启动类
│       └── resources
│           └── application.yml                      # 本地配置文件
├── Dockerfile                                       # Docker 镜像构建文件
└── pom.xml                                          # Maven 依赖配置
```

## 快速开始

### 环境要求

- JDK 17+
- Maven 3.6+
- Nacos Server (推荐 2.x 版本)

### 本地运行

1. 启动 Nacos Server（默认端口 8848）

2. 在 Nacos 控制台创建命名空间 `shopmind-dev`

3. 在 `shopmind-dev` 命名空间下创建配置文件 `shopmind-gateway.yaml`，配置网关路由规则

4. 运行应用：
```bash
mvn spring-boot:run
```

### Docker 构建

```bash
# 构建镜像
docker build -t shopmind-gateway:1.0 .

# 运行容器
docker run -p 8080:8080 shopmind-gateway:1.0
```

## 配置说明

### application.yml

```yaml
spring:
  application:
    name: shopmind-gateway
  cloud:
    nacos:
      server-addr: 127.0.0.1:8848  # Nacos 服务地址
      username: nacos
      password: nacos
      config:
        namespace: shopmind-dev    # 配置命名空间
        file-extension: yaml
      discovery:
        namespace: shopmind-dev    # 服务发现命名空间
```

### 路由配置

路由规则通过 Nacos 配置中心动态管理，在 `shopmind-gateway.yaml` 中配置：

```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: user-service
          uri: lb://user-service
          predicates:
            - Path=/api/user/**
          filters:
            - StripPrefix=1
```

## 部署

项目已配置 GitHub Actions 持续集成，支持自动构建和部署。

### 构建参数

Docker 构建时需要传入以下参数：

- `MAVEN_REPO_USERNAME`: Maven 私有仓库用户名
- `MAVEN_REPO_PASSWORD`: Maven 私有仓库密码

## 依赖说明

- **spring-cloud-starter-gateway**: Spring Cloud Gateway 核心依赖
- **spring-cloud-starter-alibaba-nacos-discovery**: Nacos 服务发现
- **spring-cloud-starter-alibaba-nacos-config**: Nacos 配置中心
- **spring-cloud-loadbalancer**: 客户端负载均衡
- **shopmind-spring-boot-starter**: 项目自定义公共 Starter

## 许可证

Copyright (c) 2025 ShopMind