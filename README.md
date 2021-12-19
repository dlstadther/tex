# Tex

Build tool and artifacts for LaTeX documents.


## Install

To avoid installing tex dependencies on the host machine, we'll use containers and mounted volume to run the build in a self-contained environment.

Setup to use `podman`, but can be easily updated to use `docker`.

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


## Clean Up

Sometimes image builds or container executions may fail if given improper input. In these cases, the follow commands may be required to get back to a clean slate.

```shell
# stop all containers
podman stop $(podman ps -q)

# delete containers
podman rm $(podman ps -a -q)

# delete dangling images
podman rmi -f $(podman images -f "dangling=true" -q)
```
