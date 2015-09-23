FROM mesosphere/mesos-modules-dev
MAINTAINER Spike Curtis <spike@projectcalico.org>

#####################
# Isolator
####################
WORKDIR /isolator
ADD ./isolator/ /isolator/

# Build the isolator.
# We need libmesos which is located in /usr/local/lib.
RUN ./bootstrap && \
    rm -rf build && \
    mkdir build && \
    cd build && \
    export LD_LIBRARY_PATH=LD_LIBRARY_PATH:/usr/local/lib && \
    ../configure --with-mesos=/usr/local --with-protobuf=/usr && \
    make all

######################
# Calico
######################
COPY ./calico/ /calico/

# Wrap agent to run in container.
ADD ./runagent /isolator/runagent

####################
# Test framework
####################
ADD ./framework /framework
