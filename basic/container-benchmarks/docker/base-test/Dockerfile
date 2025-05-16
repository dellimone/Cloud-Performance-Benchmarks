# Base image for benchmarks
FROM ubuntu:20.04

# Set DEBIAN_FRONTEND to noninteractive to avoid prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Install common tools needed for all performance tests
RUN apt-get update && apt-get install --no-install-recommends -y \
    vim \
    stress-ng \
    sysbench \
    iperf \
    iozone3 \
    fio \
    iputils-ping \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* # Clean up apt cache


# Create the directory for results inside the container
RUN mkdir /benchmark

# Set the working directory
WORKDIR /benchmark

# Create scripts directory
RUN mkdir -p /scripts

# Copy benchmark scripts
COPY scripts ./scripts

# Make scripts executable
RUN chmod +x ./scripts/tests/*.sh
RUN chmod +x ./scripts/*.sh
# Default command to keep the container running
CMD ["sleep", "infinity"]
