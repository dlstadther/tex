NS = dlstadther
REPO = latex
IMAGE = $(NS)/$(REPO)

.PHONY: build

build: tex.dockerfile
	@docker build -f tex.dockerfile -t $(IMAGE):tex .

build-texlive: texlive.dockerfile
	@docker build -f texlive.dockerfile -t $(IMAGE):texlive .

build-podman: tex.dockerfile
	@podman build -f tex.dockerfile -t $(IMAGE):tex .

build-podman-texlive: texlive.dockerfile
	@podman build -f texlive.dockerfile -t $(IMAGE):texlive .

gen:
	./build_resume.sh

view:
	@open ./output/resume_stadther_dillon.pdf

default: build
