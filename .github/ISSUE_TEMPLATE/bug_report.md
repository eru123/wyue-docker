name: Bug report
about: Something in the image is broken
labels: bug
assignees: ''
body:
  - type: textarea
    id: what-happened
    attributes:
      label: What happened
      description: A clear description of the bug. Include error output where you have it.
    validations:
      required: true
  - type: textarea
    id: reproduce
    attributes:
      label: How to reproduce
      description: The docker commands or Dockerfile lines that trigger it. If it needs an app mounted in, say so.
    validations:
      required: true
  - type: input
    id: image
    attributes:
      label: Image tag or commit
      description: Which build, e.g. 8.4-apache or main-abc1234
    validations:
      required: true
  - type: textarea
    id: environment
    attributes:
      label: Host environment
      description: OS and docker version, if it matters.
  - type: markdown
    attributes:
      value: |
        Security problems do not go here. Read SECURITY.md for the reporting address.
