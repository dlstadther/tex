#!/bin/bash

set -eu

Now=$(date +"%Y%m%d-%H%M%S")

TexMode="nonstopmode"

Name="ds_resume"  # TODO: have this be a CLI arg
Tex="${Name}.tex"
OutDir="./output"

Engine="${ENGINE:-docker}"
Image="${IMAGE:-dlstadther/latex:tex}"

mkdir -p "${OutDir}"

# build image only when missing; set REBUILD=1 to force
if [[ -n "${REBUILD:-}" ]] || ! "${Engine}" image inspect "${Image}" >/dev/null 2>&1; then
    echo "# Creating image ..."
    make build
fi

# Two passes: hyperref writes the PDF bookmarks to the .out file on pass 1 and reads them on pass 2.
# A fixed job name lets pass 2 find the files from pass 1, and keeps the PDF the same from run to run
# when SOURCE_DATE_EPOCH is set.
for Pass in 1 2; do
    echo "# Building tex (pass ${Pass}) ..."
    if ! ./run_tex.sh \
        pdflatex \
            --interaction="${TexMode}" \
            --halt-on-error \
            --output-dir="${OutDir}" \
            --jobname="${Name}" \
            "${Tex}"
    then
        echo "# ERROR: pdflatex failed; not updating 'latest'" >&2
        exit 1
    fi
done

BuildOutput="${OutDir}/${Name}.pdf"
DatedOutput="${OutDir}/${Name}_${Now}.pdf"
LatestFileName="resume_stadther_dillon.pdf"
LatestOutput="${OutDir}/${LatestFileName}"
echo "# Checking existence of ${BuildOutput} ..."
if [[ ! -f "${BuildOutput}" ]]; then
    echo "# ERROR: file did not exist: ${BuildOutput}" >&2
    exit 1
fi
cp -f "${BuildOutput}" "${DatedOutput}"
echo "# Overwriting 'latest' (${LatestOutput}) ..."
cp -f "${BuildOutput}" "${LatestOutput}"

# spell check
# on mac: `brew install aspell`
if ! command -v aspell >/dev/null 2>&1; then
    echo "# aspell not found; skipping spell check"
    exit 0
fi
shopt -s nullglob
for f in *.tex sections/*.tex ; do
    echo "${f}"
    aspell --mode=tex list < "${f}" | sort | uniq -c
done
