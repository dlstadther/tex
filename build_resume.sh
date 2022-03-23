#!/bin/bash

set -eu

Now=$(date +"%Y%m%d-%H%M%S")

TexMode="nonstopmode"

Name="ds_resume"  # TODO: have this be a CLI arg
Tex="${Name}.tex"
JobName="${Name}_${Now}"
OutDir="./output"

UserId=$(id -u)
GroupId=$(id -g)

# check if "output" dir exists; create if not
if [ ! -d "/path/to/dir" ]; then
    echo "# Creating output directory: ${OutDir} ..."
    mkdir -p ${OutDir}
fi

# recreate docker image
echo "# Creating image ..."
make build  # TODO: add CLI arg for small vs large image
# make build-texlive  # larger, pre-compiled image

# generate tex output
echo "# Building tex ..."
./run_tex.sh \
    pdflatex \
        --interaction=nonstopmode \
        --output-dir=${OutDir} \
        --jobname=${JobName} \
        ${Tex} \
    || true  # ignore exit code

DatedOutput="${OutDir}/${JobName}.pdf"
LatestFileName="resume_stadther_dillon.pdf"
LatestOutput="${OutDir}/${LatestFileName}"
echo "# Checking existence of ${DatedOutput} ..."
if [[ -f "${DatedOutput}" ]]; then
    echo "# Overwriting 'latest' (${LatestOutput}) ..."
    cp -f ${DatedOutput} ${LatestOutput}
else
    echo "# File did not exist: ${DatedOutput}"
fi
