# Custom docker triton

## Additional

- opencv
- [CMake](https://github.com/Kitware/CMake)
- [TensorRT](https://github.com/hiennguyen9874/TensorRT)

### Triton 23.02-py3-tensorrt-pytorch-dali

##### Build custom triton image

- `git clone https://github.com/triton-inference-server/server.git && git fetch && git checkout r23.02`
- `mv server triton-inference-server && cd triton-inference-server`
- `sudo ./build.py -v --backend dali --backend python --backend tensorrt --backend pytorch --enable-logging --enable-stats --enable-metrics --enable-gpu-metrics --enable-cpu-metrics --enable-tracing --enable-gpu --endpoint grpc --endpoint http`
- `docker image tag tritonserver:latest hiennguyen9874/tritonserver:23.02-py3-tensorrt-pytorch-dali`
- `docker push hiennguyen9874/tritonserver:23.02-py3-tensorrt-pytorch-dali`

##### Build custom triton + tensorrt image

- Build:
  ```
  DOCKER_BUILDKIT=1 docker build -t hiennguyen9874/triton-tensorrt:23.02-py3-tensorrt-pytorch-dali \
      --build-arg BASE_IMAGE=hiennguyen9874/tritonserver:23.02-py3-tensorrt-pytorch-dali \
      --build-arg TRT_OSS_CHECKOUT_TAG=release/8.5 \
      --build-arg TENSORRT_REPO=https://github.com/hiennguyen9874/TensorRT \
      -f Dockerfile \
      .
  ```
- Push: `docker push hiennguyen9874/triton-tensorrt:23.02-py3-tensorrt-pytorch-dali`

### Triton 23.02-py3-tensorrt-dali

##### Build custom triton image

- `git clone https://github.com/triton-inference-server/server.git && git fetch && git checkout r23.02`
- `mv server triton-inference-server && cd triton-inference-server`
- `sudo ./build.py -v --backend dali --backend python --backend tensorrt --enable-logging --enable-stats --enable-metrics --enable-gpu-metrics --enable-cpu-metrics --enable-tracing --enable-gpu --endpoint grpc --endpoint http`
- `docker image tag tritonserver:latest hiennguyen9874/tritonserver:23.02-py3-tensorrt-dali`
- `docker push hiennguyen9874/tritonserver:23.02-py3-tensorrt-dali`

##### Build custom triton + tensorrt image

- Build:
  ```
  DOCKER_BUILDKIT=1 docker build -t hiennguyen9874/triton-tensorrt:23.02-py3-tensorrt-dali \
      --build-arg BASE_IMAGE=hiennguyen9874/tritonserver:23.02-py3-tensorrt-dali \
      --build-arg TRT_OSS_CHECKOUT_TAG=release/8.5 \
      --build-arg TENSORRT_REPO=https://github.com/hiennguyen9874/TensorRT \
      -f Dockerfile \
      .
  ```
- Push: `docker push hiennguyen9874/triton-tensorrt:23.02-py3-tensorrt-dali`
