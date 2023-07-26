# Custom docker triton

## Additional

- opencv
- hiredis
- [Civetweb](https://github.com/civetweb/civetweb)
- [redis-plus-plus](https://github.com/sewenew/redis-plus-plus.git)
- [CMake](https://github.com/Kitware/CMake)
- [TensorRT](https://github.com/hiennguyen9874/TensorRT)

## Build

### Python

- Build:
  ```
  DOCKER_BUILDKIT=1 docker build -t hiennguyen9874/triton-tensorrt:21.10-py3 \
      --build-arg TRITON_VERSION=21.10 \
      --build-arg TRT_OSS_CHECKOUT_TAG=release/8.2 \
      --build-arg TENSORRT_REPO=https://github.com/hiennguyen9874/TensorRT \
      -f Dockerfile \
      .
  ```
- Push: `docker push hiennguyen9874/triton-tensorrt:21.10-py3`
