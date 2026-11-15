FROM registry.gitlab.com/islandoftex/images/texlive:TL2025-historic

# link local tex directory to container
ARG TEXSOURCE="/data"
RUN mkdir ${TEXSOURCE}
VOLUME ${TEXSOURCE}
WORKDIR ${TEXSOURCE}

CMD ["pdflatex", "--version"]
