ARG BASE_IMAGE=nvcr.io/nvidia/tritonserver:23.03-py3
FROM ${BASE_IMAGE} as base

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    libatlas-base-dev libatlas3-base \
    clang-8 \
    libopenblas-dev \
    libpcre2-dev \
    flex bison \
    libglib2.0-dev \
    libjson-glib-dev \
    uuid-dev \
    libssl-dev \
    ffmpeg libsm6 libxext6 \
    && rm -rf /var/lib/apt/lists/* \
    && apt autoremove \
    && apt-get clean

FROM base as builder

# Cmake
WORKDIR /tmp
RUN wget https://github.com/Kitware/CMake/releases/download/v3.19.5/cmake-3.19.5-Linux-x86_64.tar.gz \
    && tar -zxvf cmake-3.19.5-Linux-x86_64.tar.gz \
    && rm cmake-3.19.5-Linux-x86_64.tar.gz \
    && cd /tmp/cmake-3.19.5-Linux-x86_64/ \
    && cp -rf bin/ doc/ share/ /usr/local/ \
    && cp -rf man/* /usr/local/man \
    && sync \
    && cmake --version \
    && cd /tmp \
    && rm -rf /tmp/cmake-3.19.5-Linux-x86_64/

# Build tensorRT
ARG TRT_OSS_CHECKOUT_TAG=release/8.5
ARG TENSORRT_REPO=https://github.com/hiennguyen9874/TensorRT

WORKDIR /tmp
RUN git clone -b $TRT_OSS_CHECKOUT_TAG $TENSORRT_REPO \
    && export TRT_SOURCE=/tmp/TensorRT \
    && cd /tmp/TensorRT \
    && git submodule update --init --recursive \
    && mkdir -p build \
    && cd /tmp/TensorRT/build \
    && cmake .. \
    -DTRT_LIB_DIR=/usr/lib/x86_64-linux-gnu/ \
    -DCMAKE_C_COMPILER=/usr/bin/gcc \
    -DTRT_BIN_DIR=`pwd`/out \
    && make nvinfer_plugin -j$(nproc) \
    && mkdir -p /TensorRT \
    && cp /tmp/TensorRT/build/libnvinfer_plugin.so.8.* /TensorRT \
    && cp $(find /tmp/TensorRT/build -name "libnvinfer_plugin.so.8.*" -print -quit) \
    $(find /usr/lib/x86_64-linux-gnu/ -name "libnvinfer_plugin.so.8.*" -print -quit) \
    && ldconfig \
    && cd /tmp \
    && rm -rf /tmp/TensorRT

FROM base as runtime

COPY --from=builder /TensorRT /tmp/TensorRT
RUN cp $(find /tmp/TensorRT -name "libnvinfer_plugin.so.8.*" -print -quit) \
    $(find /usr/lib/x86_64-linux-gnu/ -name "libnvinfer_plugin.so.8.*" -print -quit) \
    && ldconfig \
    && cd /tmp \
    && rm -rf /tmp/TensorRT

RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools Cython wheel \
    && python3 -m pip install --no-cache-dir \
    --extra-index-url https://download.pytorch.org/whl/cu113 \
    numpy \
    opencv-python \
    torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1

WORKDIR /opt/tritonserver
