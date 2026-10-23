# Security

## Reporting

Email jericho@skiddph.com. Include "wyue-docker" in the subject so it lands in the right inbox.

Do not open a public GitHub issue for anything security related. Public reports about an unpatched image put everyone running it at risk.

## What to report

- Vulnerabilities in how this image is built (checksums, permissions, secrets in layers)
- Apache or PHP compiled with a dangerous default
- Anything in the entrypoint or httpd config that widens attack surface

## What not to report here

CVEs in PHP, Apache, Node, or any other bundled software belong upstream. This repo tracks them and ships patched versions, usually within days of an upstream release. Check the Dockerfile versions and recent commits before reporting; it may already be fixed.

## Response times

Reports get a reply within 48 hours. If the report is valid and fixable here, a patched image ships and the release notes credit you, unless you prefer otherwise.

## Disclosure

Please wait 90 days before publishing anything about a reported issue, or until the fix ships, whichever comes first.
