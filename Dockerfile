FROM debian:stretch-slim


WORKDIR /opt/
RUN apt-get update
RUN apt-get install -y build-essential libffi-dev git pkg-config python python3 gcc-arm-none-eabi
RUN rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/micropython/micropython.git && cd micropython && \
    git describe --tags `git rev-list --tags --max-count=1` && \
    git checkout $latest_tag && \
    git submodule update --init && \
    make -C mpy-cross && \
    cd ports/stm32 && \
    make submodules && \
    make BOARD=STM32L476DISC && \
    make
RUN apt-get update -y && apt-get install autoconf autogen libtool -y
RUN cd micropython/ports/unix && make submodules && make deplibs && make axtls && make && make install
#RUN cd ports/unix
#RUN make submodules
#RUN make
#RUN apt-get purge --auto-remove -y  build-essential libffi-dev git pkg-config python python3 && \
ENTRYPOINT ["/usr/local/bin/micropython"]
