#!/bin/bash

set -eu

Now=$(date +"%Y%m%d-%H%M%S")

TexMode="nonstopmode"

Name="resume"  # TODO: have this be a CLI arg
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
make build

# generate tex output
echo "# Building tex ..."
./run_tex.sh \
    pdflatex \
        --interaction=nonstopmode \
        --output-dir=${OutDir} \
        --jobname=${JobName} \
        ${Tex}
