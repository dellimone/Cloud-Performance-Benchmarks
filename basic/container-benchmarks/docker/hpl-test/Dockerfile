# Base image: Ubuntu 20.04 LTS
FROM ubuntu:20.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

###########################################
# Version and directory configurations
###########################################
ENV OPENBLAS_VERSION=v0.3.26
ENV OPENMPI_VERSION=4.1.4
ENV HPL_VERSION=2.3
ENV OPT_DIR=/opt
ENV OPENBLAS_DIR=${OPT_DIR}/OpenBLAS
ENV MPI_HOME=${OPT_DIR}/OpenMPI
ENV HPL_DIR=${OPT_DIR}/hpl
ENV HPL_ARCH=linux

###########################################
# Install required build dependencies
###########################################
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    hwloc \
    libhwloc-dev \
    libevent-dev \
    gfortran \
    git \
    wget \
    tar \
    ca-certificates \
    openssh-client \
    vim \
    && rm -rf /var/lib/apt/lists/*

###########################################
# Build and install OpenBLAS
###########################################
WORKDIR /tmp
RUN git clone https://github.com/xianyi/OpenBLAS.git && \
    cd OpenBLAS && \
    git checkout ${OPENBLAS_VERSION} && \
    # Use all available CPU cores for faster build
    make -j$(nproc) && \
    make PREFIX=${OPENBLAS_DIR} install && \
    cd / && \
    # Clean up source directory to reduce image size
    rm -rf /tmp/OpenBLAS

###########################################
# Build and install OpenMPI
###########################################
WORKDIR /tmp
RUN wget https://download.open-mpi.org/release/open-mpi/v${OPENMPI_VERSION%.*}/openmpi-${OPENMPI_VERSION}.tar.gz && \
    tar xzf openmpi-${OPENMPI_VERSION}.tar.gz && \
    cd openmpi-${OPENMPI_VERSION} && \
    # Enable aggressive optimization
    CFLAGS="-Ofast" ./configure --prefix=${MPI_HOME} --enable-mpi-cxx && \
    make -j$(nproc) all && \
    make install && \
    cd / && \
    # Clean up source files to reduce image size
    rm -rf /tmp/openmpi-${OPENMPI_VERSION}.tar.gz /tmp/openmpi-${OPENMPI_VERSION}

# Add OpenMPI binaries and libraries to PATH and LD_LIBRARY_PATH
ENV PATH=${PATH:-}:${MPI_HOME}/bin
ENV LD_LIBRARY_PATH=${MPI_HOME}/lib

###########################################
# Download and compile HPL benchmark
###########################################
WORKDIR ${OPT_DIR}
RUN wget https://netlib.org/benchmark/hpl/hpl-${HPL_VERSION}.tar.gz && \
    tar xzf hpl-${HPL_VERSION}.tar.gz && \
    mv hpl-${HPL_VERSION} ${HPL_DIR} && \
    rm hpl-${HPL_VERSION}.tar.gz && \
    cd ${HPL_DIR}/setup && \
    sh make_generic && \
    cp Make.UNKNOWN ../Make.${HPL_ARCH} && \
    cd .. && \
    # Configure HPL Makefile for our environment
    sed -i "s|^ARCH\s* =.*|ARCH = ${HPL_ARCH}|" Make.${HPL_ARCH} && \
    sed -i "s|^TOPdir\s* =.*|TOPdir = ${HPL_DIR}|" Make.${HPL_ARCH} && \
    # Configure MPI settings
    sed -i "s|^MPdir\s* =.*|MPdir = ${MPI_HOME}|" Make.${HPL_ARCH} && \
    sed -i "s|^MPinc\s* =.*|MPinc = -I\$(MPdir)/include|" Make.${HPL_ARCH} && \
    sed -i "s|^MPlib\s* =.*|MPlib = \$(MPdir)/lib/libmpi.so|" Make.${HPL_ARCH} && \
    # Configure Linear Algebra library (OpenBLAS) settings
    sed -i "s|^LAdir\s* =.*|LAdir = ${OPENBLAS_DIR}|" Make.${HPL_ARCH} && \
    sed -i "s|^LAinc\s* =.*|LAinc =|" Make.${HPL_ARCH} && \
    # Use static OpenBLAS library for better performance
    sed -i "s|^LAlib\s* =.*|LAlib = \$(LAdir)/lib/libopenblas.a|" Make.${HPL_ARCH} && \
    # Build HPL with all available cores
    make arch=${HPL_ARCH} -j$(nproc)

# Set working directory to HPL binary location
WORKDIR ${HPL_DIR}/bin/${HPL_ARCH}

# Copy the HPL configuration file with proper ownership
#COPY ./docker/hpl-test/HPL.dat .

CMD ["sleep", "infinity"]