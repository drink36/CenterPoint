cmake_minimum_required(VERSION 3.18)
project(centerpoint LANGUAGES CXX CUDA)
set(CMAKE_DISABLE_FIND_PACKAGE_MPI TRUE)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# =========================
# CUDA Toolkit
# =========================
find_package(CUDAToolkit REQUIRED)

# =========================
# Boost
# =========================
find_package(Boost COMPONENTS program_options REQUIRED)

# =========================
# PCL
# =========================
# find_package(PCL REQUIRED COMPONENTS common io)

# =========================
# TensorRT
# =========================
find_library(NVINFER NAMES nvinfer REQUIRED)
find_library(NVONNXPARSER NAMES nvonnxparser REQUIRED)

message(STATUS "NVINFER: ${NVINFER}")
message(STATUS "NVONNXPARSER: ${NVONNXPARSER}")

# =========================
# Include Directories
# =========================
include_directories(
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/include/trt10_common
    ${PROJECT_SOURCE_DIR}/include/utils
    ${Boost_INCLUDE_DIRS}
    ${PCL_INCLUDE_DIRS}
)

# =========================
# Source Files
# =========================
file(GLOB CPP_SOURCES ${PROJECT_SOURCE_DIR}/src/*.cpp)
file(GLOB CUDA_SOURCES ${PROJECT_SOURCE_DIR}/src/*.cu)

# =========================
# pointpillars library (C++)
# =========================
add_library(pointpillars SHARED ${CPP_SOURCES})

target_link_libraries(pointpillars
    ${NVINFER}
    ${NVONNXPARSER}
    CUDA::cudart
    dl
    pthread
)

# =========================
# CUDA library
# =========================
add_library(pointpillarsCU SHARED ${CUDA_SOURCES})

target_link_libraries(pointpillarsCU
    CUDA::cudart
)

# =========================
# Executable
# =========================
add_executable(centerpoint
    ${PROJECT_SOURCE_DIR}/src/samplecenterpoint.cpp
    ${PROJECT_SOURCE_DIR}/include/trt10_common/logger.cpp
)

target_link_libraries(centerpoint
    pointpillars
    pointpillarsCU
    ${NVINFER}
    ${NVONNXPARSER}
    Boost::program_options
    ${PCL_COMMON_LIBRARIES}
    ${PCL_IO_LIBRARIES}
    CUDA::cudart
    dl
    pthread
)
