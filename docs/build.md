# Build

The build compiles `ds_resume.tex` with pdflatex inside a container. The host needs Docker or Podman, and `aspell`
for the spell check (`brew install aspell`).

## Files

- `contact.tex`: The personal details: `\author` and the `\phone`, `\city`, `\email`, `\LinkedInUrl`,
  `\GithubUrl`, and `\role` macros. `ds_resume.tex` loads it with `\input{contact}`.
- `ds_resume.sty`: The style package. It defines the `\skills`, `\subtext`, and `zitemize` helpers. It is adapted
  from TimmyChan/data-science-tech-resume-template.
- `sections/*.tex`: Each section file starts with a `\documentclass` preamble. The `standalone` package removes that
  preamble when `ds_resume.tex` imports the file with `\import{sections/}{name}`. This lets you compile one section
  by itself.
- `tex.dockerfile`: The default image, Debian bookworm with apt TeX Live packages. Its tag is `dlstadther/latex:tex`.
- `texlive.dockerfile`: A larger image, pinned to the islandoftex `TL2025-historic` tag. Its tag is
  `dlstadther/latex:texlive`.
- `run_tex.sh`: Runs a command in the container. It mounts the current directory at `/data` and disables the
  network.
- `build_resume.sh`: The full resume build. `make gen` runs it.
- `example.tex`: A minimal document to test the toolchain.

## What `make gen` does

1. It builds the image if the image is missing.
2. It compiles a dated PDF, `output/ds_resume_<YYYYmmdd-HHMMSS>.pdf`.
3. If pdflatex fails, it exits with an error and stops.
4. It copies the dated PDF to `output/resume_stadther_dillon.pdf`.
5. It runs `aspell` on the top-level `*.tex` files (this includes `contact.tex`) and `sections/*.tex` and prints
   word counts. The spell check does not fail the build.

Git ignores the dated PDFs. Commit `output/resume_stadther_dillon.pdf` only if the user asks for it.

## Environment variables

These variables apply to `make`, `build_resume.sh`, and `run_tex.sh`:

- `ENGINE`: `docker` (default) or `podman`. `run_tex.sh` adds `--userns=keep-id` for podman.
- `IMAGE`: The image that `run_tex.sh` and `build_resume.sh` use. The default is `dlstadther/latex:tex`.
- `REBUILD`: If set, `build_resume.sh` rebuilds the image before the compile.

## Compile another document

```bash
./run_tex.sh pdflatex --interaction=nonstopmode --output-dir=./output example.tex
```
