FROM registry.gitlab.com/islandoftex/images/texlive:latest-with-cache

# link local tex directory to container
ARG TEXSOURCE="/data"
RUN mkdir ${TEXSOURCE}
VOLUME ${TEXSOURCE}
WORKDIR ${TEXSOURCE}

# enter bash if no other cmd is provided
CMD ["/bin/bash", "-c", "sleep 300"]
