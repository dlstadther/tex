# CLAUDE.md

This repository builds a one-page LaTeX resume into a PDF. The build runs pdflatex inside a container, so the host
does not need a TeX install.

## Content boundary

The text in `sections/*.tex` and the contact details in `contact.tex` are personal resume content. Do not change,
rewrite, or comment on this content unless the user asks for it. Changes to layout, macros, build scripts, and
tooling are in scope.

## Layout

- `ds_resume.tex`: The main document. It loads `contact.tex` and imports each section in order. It holds no
  personal details.
- `contact.tex`: The name, contact macros (`\phone`, `\city`, `\email`, `\LinkedInUrl`, `\GithubUrl`), and
  `\role`. `sections/_header.tex` prints them.
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
| Write commit messages and PR titles | [docs/commits.md](docs/commits.md) |

## Commits

Use Conventional Commits, `type(scope): message`, for every commit and every squash-merge PR title. Use `resume` as
the scope for resume content changes that the user makes. See [docs/commits.md](docs/commits.md) for the full rules.
