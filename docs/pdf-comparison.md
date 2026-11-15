# Prove that a change does not alter the PDF

Use this check for a build, style, or tooling change that must not change the resume output. It needs the local
image (`make build`).

## Compare the PDFs byte for byte

1. Make two working trees: one for the base branch and one for the change.
2. In each tree, run this command two times. Hyperref needs the second pass.

   ```bash
   docker run --rm --user "$(id -u):$(id -g)" --net=none -e SOURCE_DATE_EPOCH=1700000000 -e FORCE_SOURCE_DATE=1 \
     -v "$PWD":/data -w /data dlstadther/latex:tex \
     pdflatex -interaction=nonstopmode -halt-on-error -jobname=ds_resume -output-directory=output ds_resume.tex
   ```

3. Compare the two `output/ds_resume.pdf` files with `shasum`.

`SOURCE_DATE_EPOCH` and `FORCE_SOURCE_DATE` fix the dates and the document ID in the PDF. With the same inputs, the
output is the same file.

## Find what changed

If the files differ, run the command again in each tree with `-jobname=u` and with
`'\pdfcompresslevel=0\pdfobjcompresslevel=0\input{ds_resume.tex}'` in place of `ds_resume.tex`. Then diff the two
`output/u.pdf` files as text. The diff shows which lines of the page moved and by how many points.
