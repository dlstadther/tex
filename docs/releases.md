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

Pull requests and pushes to `main` run the same compile as a check. The workflow saves
`output/resume_stadther_dillon.pdf` as a workflow artifact named `ds_resume`.

CI builds the PDF the same way as a local build. It runs `make build` to build the image from `tex.dockerfile`, and
then `make gen`. CI sets `SOURCE_DATE_EPOCH` to the commit time and prints the value in the job log. To get the same
PDF bytes locally, run `make gen` with the same value:

```bash
SOURCE_DATE_EPOCH=<value from the log> FORCE_SOURCE_DATE=1 make gen
```

For a pull request, the commit is the merge commit that GitHub makes, not the head of the branch.
