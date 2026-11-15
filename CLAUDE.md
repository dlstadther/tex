# CLAUDE.md

This repository builds a one-page LaTeX resume into a PDF. The build runs pdflatex inside a container, so the host
does not need a TeX install.

## Content boundary

The text in `sections/*.tex` and the contact block in `ds_resume.tex` are personal resume content. Do not change,
rewrite, or comment on this content unless the user asks for it. Changes to layout, macros, build scripts, and
tooling are in scope.

## Layout

- `ds_resume.tex`: The main document. It sets the contact macros and imports each section in order.
- `ds_resume.sty`: The style package (fonts, margins, colors, section format, and helper macros).
- `sections/*.tex`: One file for each resume section.
- `output/`: The local build output. Only the latest PDF, `resume_stadther_dillon.pdf`, is tracked.

## Verify a change

Build the resume. The command exits with an error if pdflatex fails:

```bash
make gen
```

The `Makefile` lists the other targets (`build`, `view`, `spell`, `clean`, and the podman variants).

## Docs

Read the file that matches the task:

| Task | File |
| --- | --- |
| Build details, container images, environment variables, caveats | [docs/build.md](docs/build.md) |
| Publish a resume version, CI workflow | [docs/releases.md](docs/releases.md) |
| Prove that a change does not alter the PDF | [docs/pdf-comparison.md](docs/pdf-comparison.md) |

## Commits

Use `resume` as the commit scope for content changes that the user makes.
