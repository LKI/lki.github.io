---
title: "如何加速 Docker Build 构建过程"
date: 2020-04-22T22:28:53+08:00
aliases:
  - /boost-docker-build
---

<!--more-->

## Dockerfile

docker 已经成为现代开发的基础技术，
而在 docker 开发流中，
Dockerfile 是最基础的文件。

一个包括了系统配置、依赖安装、业务代码的 Dockerfile 可能长这样子：

```
FROM python:3.8-buster
WORKDIR /app

COPY Pipfile Pipfile.lock ./
COPY code /app/code
RUN pip install pipenv
RUN pipenv sync
RUN echo "Asia/Shanghai" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install vim tmux git
RUN curl -sL https://sentry.io/get-cli/ | bash
```

然后很自然地，
开发者小周发现：
每次改完代码以后重新 `docker build` 都非常慢。

![xkcd-docker][xkcd-docker]
他需要加速构建过程。


## 改写文件

最简单的加速是改写 Dockerfile,
因为 Dockerfile 中的一些命令 (`ADD/COPY/RUN`) 会产生新的 layer,
而 Docker 会自动跳过已经构建好的 layer。
所以一般优化的原则基于以下几点：

- 变动越小的命令，越靠前，增加 cache 使用率。
- 合并目的相同的命令，减少 layer 层数。
- 使用国内源，或者内网服务加速构建。
- 少装些东西，不是代码依赖的就尽量别装了…
- 记得加上合适的注释，以便日后的维护。

改写以后的 Dockerfile 可能长这样：

```
FROM python:3.8-buster
WORKDIR /app

# 默认使用上海时区 + 阿里源
RUN echo "Asia/Shanghai" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata && \
    echo "deb https://mirrors.aliyun.com/debian/ buster main non-free contrib" > /etc/apt/sources.list

# 预装必须的包，sentry-cli 是预先存入内网的
RUN apt-get update && apt-get -y dist-upgrade && apt-get -y install git && \
    wget https://internal-nginx-service.domain.com/sentry.sh /usr/bin/sentry-cli && \
    pip install pipenv

# 装依赖，顺便祝 pipenv 早日发布新版本
COPY Pipfile Pipfile.lock ./
RUN pipenv sync

# 代码频繁变更，放在文件底部，下面就别加更多命令了
COPY code /app/code
```

改过以后的版本，
开发者小周发现，
每次本地改完代码 build 调试都飞快，
他很满意。

但是用公司的分布式 gitlab runner 构建以后，
他发现：
有时镜像没用到 cache，又跑了一遍漫长的构建过程。


## 分布式构建

在 codebase 足够大的情况下，
CI/CD 一般都是分布式多台机器的，
默认的 docker build 只会从本地寻找 cache layer,
无法应对如此复杂的场面。

简单的办法是使用 `docker build --cache-from` 指定镜像，
我们会在 ci 脚本中这么写：

```bash
docker pull LKI/code:latest || true
docker build . -t LKI/code:latest --cache-from LKI/code:latest
docker push LKI/code:latest
```

但是这样手写的弊端是逻辑比较臃肿，
比如要完美适配多分支构建 (dev/master/hotfix/release) 的话，
往往就要自己实现一套判断究竟 cache from 哪个版本的逻辑。

更通用的办法是使用类似 [GoogleContainerTools/kaniko][kaniko] 这样的工具来构建。
最适合 kaniko 的场景是 kaniko + kubernetes,
但这个我们留到最后一章再讲，
我们顺着我们的工作流往下看。

使用 kaniko + docker 的构建，
我们可以把上面的 pull/build/push 三连改写为以下这样：

``` bash
# 这个命令包括了 cache/build/push
docker run \
  -v "$CODE"/LKI/code:/workspace \
  gcr.io/kaniko-project/executor:latest \
  --cache=true \
  --context dir:///workspace/ \
  --destination LKI/code:latest
```


## and Kubernetes?

上面提到，kaniko 可以直接丢到 kubernetes 集群中构建：

```
apiVersion: v1
kind: Pod
metadata:
  name: kaniko
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:latest
    args: ["--dockerfile=Dockerfile",
           # 没错，可以直接从 s3 里捞代码构建
           "--context=s3:///bucket/code/",
           "--destination=LKI/code:latest"]
    volumeMounts:
      - name: kaniko-secret
        mountPath: /secret
  restartPolicy: Never
  volumes:
    - name: kaniko-secret
      secret:
        secretName: kaniko-secret
```

随着研究的进一步深入，
很容易想到，
其实 docker 开发流跟 kubernetes 的开发流理应有更好的集成。

这就是 [GoogleContainerTools/skaffold][skaffold] 在做的事情了。
skaffold 不仅支持前面讲到的 kaniko 构建，
还囊括了 port-forwarding/test/helm-deploy 等一系列常用工作流。

有兴趣的同学可以自行了解，
关于 skaffold 的故事我们以后有机会，
再慢慢讲 :)

[xkcd-docker]: /assets/pics/xkcd_docker.png
[kaniko]: https://github.com/GoogleContainerTools/kaniko
[skaffold]: https://github.com/GoogleContainerTools/skaffold/
