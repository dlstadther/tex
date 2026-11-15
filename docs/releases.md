# Releases and CI

Each resume version is a GitHub Release, not a committed file. The workflow is
`.github/workflows/resume.yml`.

## Publish a version

Do not create tags or releases unless the user asks for it.

Push a tag that starts with `resume-`:

```bash
git tag resume-YYYY.MM.DD && git push origin resume-YYYY.MM.DD
```

The workflow compiles `ds_resume.tex` and creates a release for the tag. The release has the PDF attached as
`resume_stadther_dillon_<tag>.pdf`. If you publish two versions on one day, add a suffix to the second tag, for
example `resume-2022.04.16.2`.

## CI checks

Pull requests and pushes to `master` run the same compile as a check. The workflow saves the PDF as a workflow
artifact.

The CI compile uses `xu-cheng/latex-action`, not the repository Dockerfiles. A passing CI build does not prove that
the local image works. To test a Dockerfile change, run `make build` and `make gen` locally.
