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
- `tex.dockerfile`: The only image. It is Debian bookworm-slim with apt TeX Live 2022 packages. Its tag is
  `dlstadther/latex:tex`. CI builds and uses the same image.
- `run_tex.sh`: Runs a command in the container. It mounts the current directory at `/data` and disables the
  network.
- `build_resume.sh`: The full resume build. `make gen` runs it.
- `example.tex`: A minimal document to test the toolchain.

## What `make gen` does

1. It builds the image if the image is missing.
2. It runs pdflatex two times to make `output/ds_resume.pdf`. The second pass adds the PDF bookmarks.
3. If pdflatex fails, it exits with an error and stops.
4. It copies the PDF to a dated file, `output/ds_resume_<YYYYmmdd-HHMMSS>.pdf`, and to
   `output/resume_stadther_dillon.pdf`.
5. It runs `aspell` on the top-level `*.tex` files (this includes `contact.tex`) and `sections/*.tex` and prints
   word counts. The spell check does not fail the build. If `aspell` is not installed, the script skips the spell
   check.

CI runs the same `make build` and `make gen` commands. See [releases.md](releases.md).

Git ignores the dated PDFs. Commit `output/resume_stadther_dillon.pdf` only if the user asks for it.

## Environment variables

These variables apply to `make`, `build_resume.sh`, and `run_tex.sh`:

- `ENGINE`: `docker` (default) or `podman`. `run_tex.sh` adds `--userns=keep-id` for podman.
- `IMAGE`: The image that `run_tex.sh` and `build_resume.sh` use. The default is `dlstadther/latex:tex`.
- `REBUILD`: If set, `build_resume.sh` rebuilds the image before the compile.
- `SOURCE_DATE_EPOCH` and `FORCE_SOURCE_DATE=1`: If set, `run_tex.sh` passes them into the container. They fix the
  dates and the document ID in the PDF, so two builds of the same commit give the same bytes.

## Image size

The image installs `texlive-latex-extra` and `texlive-fonts-extra` from apt. `texlive-fonts-extra` is about 1.4GB,
but the resume uses only the Source Sans Pro fonts from it. A dpkg filter in `tex.dockerfile` skips the other font
files while apt installs the package. The filter also skips `/usr/share/doc`, `/usr/share/man`, and
`/usr/share/info`. The image is about 690MB.

If you add a `\usepackage` that needs a font from `texlive-fonts-extra`, add a `path-include` line for that font to
the filter.

Do not change the base image to a newer Debian or TeX Live release without a PDF check. A newer TeX Live changes the
output. For example, TeX Live 2025 uses Source Sans 3 in place of Source Sans Pro, and the text moves on the page.
See [pdf-comparison.md](pdf-comparison.md).

## Compile another document

```bash
./run_tex.sh pdflatex --interaction=nonstopmode --output-dir=./output example.tex
```
