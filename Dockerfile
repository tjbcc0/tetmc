# 使用 ARMv7 版本的 Ubuntu 作为基础镜像
FROM arm32v7/ubuntu:20.04

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive

# 安装必要的依赖项
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    unzip \
    libuv1-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# 创建工作目录
WORKDIR /testformycode

# 下载源码
RUN wget -O testformycode.zip http://8.138.123.18:8180/testformycode.zip && \
    unzip testformycode.zip && \
    rm testformycode.zip && \
    cd testformycode

# 列出解压缩后的文件以进行调试
RUN ls -l /testformycode

# 运行 CMake 并构建项目
RUN mkdir build && \
    cd build && \
    cmake .. -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc -DCMAKE_CXX_COMPILER=arm-linux-gnueabihf-g++ -DHWLOC_LIBRARY=/usr/lib/arm-linux-gnueabihf/libhwloc.so -DHWLOC_INCLUDE_DIR=/usr/include/arm-linux-gnueabihf -DUV_LIBRARY=/usr/lib/arm-linux-gnueabihf/libuv.so -DARM_TARGET=7 -DWITH_TLS=OFF && \
    make

# 指定容器启动时执行的命令（可根据您的需要进行调整）
CMD ["./build/testformycode"]
