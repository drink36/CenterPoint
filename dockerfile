FROM nvcr.io/nvidia/tensorrt:25.04-py3

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace/CenterPoint

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake ninja-build git pkg-config \
    libboost-all-dev \
    libopenmpi-dev openmpi-bin \
    libpcl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install -U pip
    # if [ -f requirements.txt ]; then pip3 install -r requirements.txt; fi

# sanity check: print TRT version when container starts (optional)
CMD ["bash", "-lc", "python3 -c \"import tensorrt as trt; print('TensorRT:', trt.__version__)\" && bash"]
