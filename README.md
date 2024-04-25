# Custom docker triton

## Additional

- opencv
- [CMake](https://github.com/Kitware/CMake)
- [TensorRT](https://github.com/hiennguyen9874/TensorRT)

## Build

### Triton 23.03

- Build:
  ```
  DOCKER_BUILDKIT=1 docker build -t hiennguyen9874/triton-tensorrt:23.03-py3 \
      --build-arg TRITON_VERSION=23.03 \
      --build-arg TRT_OSS_CHECKOUT_TAG=release/8.5 \
      --build-arg TENSORRT_REPO=https://github.com/hiennguyen9874/TensorRT \
      -f Dockerfile \
      .
  ```
- Push: `docker push hiennguyen9874/triton-tensorrt:23.03-py3`

### Triton 23.02

- Build:
  ```
  DOCKER_BUILDKIT=1 docker build -t hiennguyen9874/triton-tensorrt:23.02-py3 \
      --build-arg TRITON_VERSION=23.02 \
      --build-arg TRT_OSS_CHECKOUT_TAG=release/8.5 \
      --build-arg TENSORRT_REPO=https://github.com/hiennguyen9874/TensorRT \
      -f Dockerfile \
      .
  ```
- Push: `docker push hiennguyen9874/triton-tensorrt:23.02-py3`
