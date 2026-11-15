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
  A section file can start with a `\documentclass` preamble. The `standalone` package removes that preamble on
  import, so you can compile one section by itself.
- `output/`: The local build output. Only `resume_stadther_dillon.pdf` (the latest build) and `OUTPUT.md` are
  tracked. Git ignores the dated PDFs.
- `tex.dockerfile`: The default image, Debian bookworm with apt TeX Live packages. Its tag is `dlstadther/latex:tex`.
- `texlive.dockerfile`: A larger image, pinned to the islandoftex `TL2025-historic` tag. Its tag is
  `dlstadther/latex:texlive`.
- `run_tex.sh`: Runs a command in the container. It mounts the current directory at `/data` and disables the
  network.
- `build_resume.sh`: The full resume build. It builds the image if it is missing, compiles a dated PDF, copies it to
  the latest file, and runs a spell check.
- `.github/workflows/resume.yml`: The CI build and the release job.
- `example.tex`: A minimal document to test the toolchain.

## Commands

Build the resume:

```bash
make gen
```

Open the latest PDF (macOS):

```bash
make view
```

Build the container image. Set `REBUILD=1` with `make gen` to force a rebuild there:

```bash
make build
```

Compile any document in the container:

```bash
./run_tex.sh pdflatex --interaction=nonstopmode --output-dir=./output example.tex
```

Run the spell check, or remove LaTeX auxiliary files from `output/`:

```bash
make spell
```

```bash
make clean
```

## Configuration

These environment variables apply to `make`, `build_resume.sh`, and `run_tex.sh`:

- `ENGINE`: `docker` (default) or `podman`. `run_tex.sh` adds `--userns=keep-id` for podman.
- `IMAGE`: The image that `run_tex.sh` and `build_resume.sh` use. The default is `dlstadther/latex:tex`.
- `REBUILD`: If set, `build_resume.sh` rebuilds the image before the compile.

## Releases

Each resume version is a GitHub Release, not a committed file. To publish a version, push a tag that starts with
`resume-`, for example `resume-2026.11.15`. The workflow compiles `ds_resume.tex` and attaches
`resume_stadther_dillon_<tag>.pdf` to the release. Do not create tags or releases unless the user asks for it.

Pull requests and pushes to `master` run the same compile as a check. The CI compile uses `xu-cheng/latex-action`,
not the repository Dockerfiles. A passing CI build does not prove that the local image works.

## Caveats

- `build_resume.sh` exits with an error if pdflatex fails. It then does not update the latest PDF.
- The spell check needs `aspell` on the host (`brew install aspell`). It prints word counts and does not fail the
  build.
- Each local build writes a new dated PDF to `output/`. Commit `output/resume_stadther_dillon.pdf` only if the user
  asks for it.

## Check that output is unchanged

For a change that must not alter the PDF, compile the base branch and the change with fixed timestamps, then compare
the files byte for byte. Run this command two times in each tree, because hyperref needs a second pass:

```bash
docker run --rm --user "$(id -u):$(id -g)" --net=none -e SOURCE_DATE_EPOCH=1700000000 -e FORCE_SOURCE_DATE=1 \
  -v "$PWD":/data -w /data dlstadther/latex:tex \
  pdflatex -interaction=nonstopmode -halt-on-error -jobname=ds_resume -output-directory=output ds_resume.tex
```

If the files differ, compile again with `'\pdfcompresslevel=0\pdfobjcompresslevel=0\input{ds_resume.tex}'` as the
input and diff the two PDFs as text. This shows which lines of the page moved.

## Commits

Use Conventional Commits, for example `fix(build): ...` or `chore(docker): ...`. Use `resume` as the scope for
content changes that the user makes.
