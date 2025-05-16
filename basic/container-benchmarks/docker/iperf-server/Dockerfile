# Base image for benchmarks
FROM ubuntu:20.04

# Set DEBIAN_FRONTEND to noninteractive to avoid prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Install common tools needed for all performance tests
# Using --no-install-recommends reduces image size
RUN apt-get update && apt-get install --no-install-recommends -y \
    iperf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* # Clean up apt cache

# Create the directory for results inside the container
RUN mkdir /benchmark

# Set the working directory
WORKDIR /benchmark

CMD ["iperf", "--server"]
