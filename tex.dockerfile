FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

RUN \
    # install full texlive
    apt-get update -q && apt-get install -qy \
        texlive \
        texlive-extra-utils \
        texlive-fonts-recommended \
        texlive-fonts-extra \
        python-pygments \
        gnuplot \
        make \
        git \
    # cleanup
    && apt-get autoclean && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# link local tex directory to container
ARG TEXSOURCE="/data"
RUN mkdir ${TEXSOURCE}
VOLUME ${TEXSOURCE}
WORKDIR ${TEXSOURCE}

# enter bash if no other cmd is provided
CMD ["/bin/bash", "-c", "sleep 300"]
