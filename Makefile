NS = dlstadther
REPO = latex
IMAGE = $(NS)/$(REPO)

ENGINE ?= docker
export ENGINE

.DEFAULT_GOAL := build
.PHONY: build build-podman gen view clean spell

build: tex.dockerfile
	@$(ENGINE) build -f tex.dockerfile -t $(IMAGE):tex .

build-podman:
	$(MAKE) build ENGINE=podman

gen:
	./build_resume.sh

view:
	@open ./output/resume_stadther_dillon.pdf

clean:
	rm -f output/*.aux output/*.log output/*.out

spell:
	for f in *.tex sections/*.tex; do echo "$$f"; aspell --mode=tex list < "$$f" | sort | uniq -c; done
