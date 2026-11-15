FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Debian bookworm ships TeX Live 2022. Stay on these apt packages so the PDF does not change.
#
# texlive-latex-extra: moresize, anyfontsize, titlesec, enumitem, standalone, import, csquotes.
#   It also pulls in texlive-latex-base/-recommended (geometry, hyperref, xcolor, pdflatex) and texlive-pictures.
# texlive-fonts-extra: sourcesanspro and mweights. The package is about 1.4GB, almost all of it fonts that
#   the resume does not use. A dpkg filter skips those font files while apt installs it. The filter keeps
#   all font map and encoding files, so the updmap step at install time still finds every map.
RUN printf '%s\n' \
        'path-exclude=/usr/share/doc/*' \
        'path-exclude=/usr/share/man/*' \
        'path-exclude=/usr/share/info/*' \
        > /etc/dpkg/dpkg.cfg.d/01-nodoc \
    && apt-get update -q \
    && apt-get install -qy --no-install-recommends texlive-latex-extra \
    && printf '%s\n' \
        'path-exclude=/usr/share/texlive/texmf-dist/fonts/*' \
        'path-include=/usr/share/texlive/texmf-dist/fonts/map/*' \
        'path-include=/usr/share/texlive/texmf-dist/fonts/enc/*' \
        'path-include=/usr/share/texlive/texmf-dist/fonts/*/sourcesanspro/*' \
        > /etc/dpkg/dpkg.cfg.d/02-fonts-extra \
    && apt-get install -qy --no-install-recommends texlive-fonts-extra \
    && rm /etc/dpkg/dpkg.cfg.d/02-fonts-extra \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# link local tex directory to container
ARG TEXSOURCE="/data"
RUN mkdir ${TEXSOURCE}
VOLUME ${TEXSOURCE}
WORKDIR ${TEXSOURCE}

CMD ["pdflatex", "--version"]
