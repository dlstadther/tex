#!/bin/bash

set -eu

Now=$(date +"%Y%m%d-%H%M%S")

TexMode="nonstopmode"

Name="ds_resume"  # TODO: have this be a CLI arg
Tex="${Name}.tex"
JobName="${Name}_${Now}"
OutDir="./output"

Engine="${ENGINE:-docker}"
Image="${IMAGE:-dlstadther/latex:tex}"

mkdir -p "${OutDir}"

# build image only when missing; set REBUILD=1 to force
if [[ -n "${REBUILD:-}" ]] || ! "${Engine}" image inspect "${Image}" >/dev/null 2>&1; then
    echo "# Creating image ..."
    make build  # TODO: add CLI arg for small vs large image
    # make build-texlive  # larger, pre-compiled image
fi

# generate tex output
echo "# Building tex ..."
if ! ./run_tex.sh \
    pdflatex \
        --interaction="${TexMode}" \
        --output-dir="${OutDir}" \
        --jobname="${JobName}" \
        "${Tex}"
then
    echo "# ERROR: pdflatex failed; not updating 'latest'" >&2
    exit 1
fi

DatedOutput="${OutDir}/${JobName}.pdf"
LatestFileName="resume_stadther_dillon.pdf"
LatestOutput="${OutDir}/${LatestFileName}"
echo "# Checking existence of ${DatedOutput} ..."
if [[ ! -f "${DatedOutput}" ]]; then
    echo "# ERROR: file did not exist: ${DatedOutput}" >&2
    exit 1
fi
echo "# Overwriting 'latest' (${LatestOutput}) ..."
cp -f "${DatedOutput}" "${LatestOutput}"

# spell check
# on mac: `brew install aspell`
shopt -s nullglob
for f in *.tex sections/*.tex ; do
    echo "${f}"
    aspell --mode=tex list < "${f}" | sort | uniq -c
done
