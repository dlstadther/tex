NS = dlstadther
REPO = latex
IMAGE = $(NS)/$(REPO)

.PHONY: build

build: tex.dockerfile
	@podman build -f tex.dockerfile -t $(IMAGE):tex .

build-texlive: texlive.dockerfile
	@podman build -f texlive.dockerfile -t $(IMAGE):texlive .

default: build
