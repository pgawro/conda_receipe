#!/usr/bin/env bash

set -e 



cd ${SRC_DIR}
echo "Configuring TensorFlow build..."
export PYTHON_BIN_PATH=$(which python)
export TF_NEED_CUDA=${TF_NEED_CUDA}
export TF_CUDA_VERSION=${CUDA_VERSION}
export TF_CUDNN_VERSION=${CUDNN_VERSION}
export CC_OPT_FLAGS="-march=native"
export TF_CONFIGURE_IOS=0

yes "" | python configure.py

echo "Building TensorFlow..."
bazel build --python_path=${PYTHON_BIN_PATH} --linkopt=-Wl,--no-keep-memory --copt=-Wno-error --copt=-Wno-gnu-offsetof-extensions //tensorflow/tools/pip_package:wheel --repo_env=WHEEL_NAME=tensorflow_cpu


mkdir -p ${SRC_DIR}/tensorflow_pkg
bazel-bin/tensorflow/tools/pip_package/build_pip_package ${SRC_DIR}/tensorflow_pkg

pip install ${SRC_DIR}/tensorflow_pkg/*.whl
