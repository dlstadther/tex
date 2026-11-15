# Commit messages

Every commit and every squash-merge PR title uses Conventional Commits:

```text
type(scope): message
```

The repository squash-merges, so the PR title becomes the commit on `main`.

## Types

Use one of: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `ci`, `build`, `style`.

## Scope

- Write the scope in lowercase.
- If the branch name or the user's prompt has a Jira-style ticket (for example `ABC-123`), use it as the scope:
  `feat(abc-123): add login flow`.
- For resume content changes that the user makes, use `resume`: `docs(resume): update summary`.
- Otherwise, use a short noun for the area, for example `build`, `make`, `docker`, `style`, `ci`, or `claude`.

## Message

- Write the subject in the imperative mood ("add", not "added").
- Start the text after the colon with a lowercase letter.
- Do not end the subject with a period.

## Examples

- `fix(build): harden build_resume.sh`
- `ci(release): build resume in CI and publish PDFs as GitHub Releases`
- `docs(resume): update experience section`
