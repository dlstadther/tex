NS = dlstadther
REPO = latex
IMAGE = $(NS)/$(REPO)

.PHONY: build

build: tex.dockerfile
	@podman build -f tex.dockerfile -t $(IMAGE):tex .

default: build
