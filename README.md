# Tex

Build tool and artifacts for LaTeX documents.


## Install

To avoid installing tex dependencies on the host machine, we use containers and a mounted volume to run the build in
a self-contained environment.

Docker is the default container tool. Podman also works through the Makefile targets.

## Build

Multiple Steps (for any document)
```shell
# build image
make build

# generate pdf for tex document
FileName="example.tex"
./run_tex.sh pdflatex --interaction=nonstopmode --output-dir=./output ${FileName}
```

Generate Resume (with custom script)
```shell
./build_resume.sh
```


## Releases

Dated resume PDFs are no longer committed to the repository. The latest PDF stays at
`output/resume_stadther_dillon.pdf`. Each released version is a GitHub Release with the PDF attached.

To cut a release, push a tag that starts with `resume-`:
```shell
git tag resume-YYYY.MM.DD
git push origin resume-YYYY.MM.DD
```

The GitHub Actions workflow builds `ds_resume.tex` and creates the release. The PDF in the release is named
`resume_stadther_dillon_<tag>.pdf`. Pull requests and pushes to `master` only build the PDF as a check. The PDF is
saved as a workflow artifact.


## Clean Up

Sometimes image builds or container executions may fail if given improper input. In these cases, the follow commands may
be required to get back to a clean slate.

```shell
# stop all containers
docker stop $(docker ps -q)

# delete containers
docker rm $(docker ps -a -q)

# delete dangling images
docker rmi -f $(docker images -f "dangling=true" -q)
```

For podman, use `podman` in place of `docker` in these commands.
