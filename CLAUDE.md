# CLAUDE.md

This repository builds a one-page LaTeX resume into a PDF. The build runs pdflatex inside a container, so the host
does not need a TeX install.

## Content boundary

The text in `sections/*.tex` and the contact block in `ds_resume.tex` are personal resume content. Do not change,
rewrite, or comment on this content unless the user asks for it. Changes to layout, macros, build scripts, and
tooling are in scope.

## Layout

- `ds_resume.tex`: The main document. It sets the contact macros (`\phone`, `\email`, `\role`, and others) and
  imports each section in order.
- `ds_resume.sty`: The style package. It sets fonts, margins, colors, and section format. It also defines the
  `\skills`, `\subtext`, and `zitemize` helpers. It is adapted from TimmyChan/data-science-tech-resume-template.
- `sections/*.tex`: One file for each resume section. `ds_resume.tex` loads them with `\import{sections/}{name}`.
- `output/`: The build output. It holds dated PDFs and `resume_stadther_dillon.pdf`, which is the latest build.
  These files are committed.
- `tex.dockerfile`: The default image (Debian with apt TeX Live packages). Its tag is `dlstadther/latex:tex`.
- `texlive.dockerfile`: A larger image from the islandoftex TeX Live image. Its tag is `dlstadther/latex:texlive`.
- `run_tex.sh`: Runs a command in the container. It mounts the current directory at `/data` and disables the
  network.
- `build_resume.sh`: The full resume build. It builds the image, compiles the PDF, copies it to the latest file,
  and runs a spell check.
- `example.tex`: A minimal document to test the toolchain.

Some section files start with `\documentclass` and `\begin{document}`. The `standalone` package removes these
preambles when the main file imports them. This lets you compile one section by itself.

## Commands

Build the resume. This also rebuilds the image and runs the spell check:

```bash
make gen
```

Open the latest PDF (macOS):

```bash
make view
```

Compile any document in the container:

```bash
./run_tex.sh pdflatex --interaction=nonstopmode --output-dir=./output example.tex
```

Build the container image by itself:

```bash
make build
```

## Requirements and caveats

- `run_tex.sh` calls `docker`. The Makefile also has `build-podman` targets, but `run_tex.sh` does not use podman
  unless you edit it.
- The spell check needs `aspell` on the host (`brew install aspell`). It prints word counts and does not fail the
  build.
- `build_resume.sh` ignores the pdflatex exit code. Read the pdflatex output for errors after each build. Do not
  trust a PDF only because the file exists.
- Each build writes a new dated PDF to `output/`. Commit the new PDF only if the user asks for it.

## Commits

Use Conventional Commits, for example `fix(build): ...` or `chore(docker): ...`. Use `resume` as the scope for
content changes that the user makes.
