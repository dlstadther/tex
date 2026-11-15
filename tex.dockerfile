FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# texlive-latex-extra: moresize, anyfontsize, titlesec, enumitem, standalone, import, csquotes
# texlive-fonts-extra: sourcesanspro
# texlive (base, recommended): babel, geometry, hyperref, xcolor, pdflatex
RUN apt-get update -q && apt-get install -qy --no-install-recommends \
        texlive \
        texlive-latex-extra \
        texlive-fonts-recommended \
        texlive-fonts-extra \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# link local tex directory to container
ARG TEXSOURCE="/data"
RUN mkdir ${TEXSOURCE}
VOLUME ${TEXSOURCE}
WORKDIR ${TEXSOURCE}

CMD ["pdflatex", "--version"]
