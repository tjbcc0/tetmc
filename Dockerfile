# 使用 Ubuntu 作为基础镜像
FROM arm32v7/ubuntu:20.04

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive

# 安装必要的工具和库
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    add-apt-repository multiverse && \
    apt-get update && apt-get install -y \
    cmake \
    build-essential \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    libhwloc-dev \
    libuv1-dev \
    wget

# 下载并解压源码
RUN wget http://8.138.123.18:8180/testformycode.zip -O /tmp/testformycode.zip && \
    unzip /tmp/testformycode.zip -d / && \
    cd /testformycode && \
    rm /tmp/testformycode.zip

# 进入项目目录并创建构建目录
RUN mkdir /testformycode/build && \
    cd /testformycode/build

# 设置工作目录为构建目录
WORKDIR /testformycode/build

# 编译项目
RUN cmake .. \
    -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc \
    -DCMAKE_CXX_COMPILER=arm-linux-gnueabihf-g++ \
    -DHWLOC_LIBRARY=/usr/lib/arm-linux-gnueabihf/libhwloc.so \
    -DHWLOC_INCLUDE_DIR=/usr/include/arm-linux-gnueabihf \
    -DUV_LIBRARY=/usr/lib/arm-linux-gnueabihf/libuv.so \
    -DARM_TARGET=7 \
    -DWITH_TLS=OFF && \
    make

# 设置容器启动时的默认命令
CMD ["bash"]
