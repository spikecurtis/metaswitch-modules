FROM mesosphere/mesos-modules-dev
MAINTAINER Spike Curtis <spike@projectcalico.org>

# This Dockerfile builds a Mesos image with net-modules Isolator and the
# Calico plug-in.  Unlike the main Dockerfile, which is used for the Docker
# Compose-based demo, this image is designed for a production Mesos system.

# Isolator
WORKDIR /isolator
ADD ./isolator/ /isolator/
RUN ./bootstrap && \
    rm -rf build && \
    mkdir build && \
    cd build && \
    export LD_LIBRARY_PATH=LD_LIBRARY_PATH:/usr/local/lib && \
    ../configure --with-mesos=/usr/local --with-protobuf=/usr && \
    make all

# Wrap agent to run in container.  This allows the agent to access
# containerization features of the OS, even when it is itself in a container.
ADD ./runagent /isolator/runagent

# Calico Plug-in.
COPY ./calico/ /calico/

