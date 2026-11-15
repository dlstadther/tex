# Releases and CI

Each resume version is a GitHub Release, not a committed file. The workflow is
`.github/workflows/resume.yml`.

## Publish a version

Do not create tags or releases unless the user asks for it.

Run one command from an up-to-date `main` with a clean working tree:

```bash
make release
```

To see the tag first without creating it, run `DRY_RUN=1 make release`.

`make release` runs `release.sh`. The script does these steps:

1. It stops with an error if the current branch is not `main`, if the working tree has changes, or if the local
   `main` is not the same commit as `origin/main`.
2. It makes the tag from today's date.
3. It reads the local tags and the tags on `origin`. If a tag for today exists, it adds the next free suffix.
4. It prints the tag. With `DRY_RUN=1`, it stops here.
5. It creates an annotated tag and pushes the tag to `origin`.

The push starts the workflow. CI does the release. You do not build or upload the PDF yourself.

## Tag format

A release tag is `resume-YYYY.MM.DD`, for example `resume-2026.11.15`. The date is the local date when you run
`make release`. The version does not use semantic versioning.

If you publish more than one version on one day, the next tags get a suffix: `resume-2026.11.15.1`, then
`resume-2026.11.15.2`. The script picks the first free suffix.

The tag `resume-2022.04.16.2` is older than this rule. It was the second release on that day and has no `.1` tag.

## What CI does for a tag

When a tag that starts with `resume-` arrives, the workflow does these steps:

1. It checks that the tag matches `resume-YYYY.MM.DD` or `resume-YYYY.MM.DD.N`. If the tag does not match, the job
   fails with an error and no release is made.
2. It builds the PDF with the same image and the same `make gen` command as a local build.
3. It creates a GitHub Release for the tag. The release title is `Resume YYYY.MM.DD` (the tag without `resume-`).
   The PDF is attached as `resume_stadther_dillon_<tag>.pdf`, for example
   `resume_stadther_dillon_resume-2026.11.15.pdf`.

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
