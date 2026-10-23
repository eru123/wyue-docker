name: Feature request
about: An extension, a component version, a build change
labels: enhancement
body:
  - type: textarea
    id: proposal
    attributes:
      label: What are you proposing
      description: The change in a few sentences.
    validations:
      required: true
  - type: textarea
    id: why
    attributes:
      label: Why does a Wyue app need it
      description: The use case. Requests without one sit at the bottom of the pile.
    validations:
      required: true
