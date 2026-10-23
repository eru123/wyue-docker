# Contributing

Small repo, simple rules.

## What gets accepted

- Version bumps for PHP, Node, httpd, yarn, pnpm, or Composer
- Build fixes and smaller images
- New PHP extensions, with a reason a Wyue app needs them
- Documentation corrections

## How to send something

1. Fork, branch, commit. One logical change per branch.
2. If you bump a version, check the table in the README and the `ENV` lines in the Dockerfile. httpd and Node also carry SHA256 checksums that have to be updated to match the new tarballs, otherwise the build fails on purpose.
3. Build the image before you send it:

```
cd 8.4-apache
docker build -t wyue-test .
docker run --rm --entrypoint php wyue-test -v
```

If that doesn't run, the PR isn't ready.

4. Open a pull request against main. Say what changed and why in a sentence or two. CI builds the image on top of your commit, so a green check there is the real test.

## Commit style

Conventional commits: `fix:`, `feat:`, `docs:`, `ci:`, `chore:`. Look at `git log` for the pattern.

## Security things

Do not open issues or PRs about vulnerabilities in public. Read SECURITY.md.
