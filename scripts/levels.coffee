levels =
  [
    comment: "Level 1"
    sources:
      [
        position: [-250, 0]
        initialVelocity: [1, 0]
        hue: 0
      ]
    sinks:
      [
        position: [150, 100]
        hue: 0
      ]
    pushers:
      [
        position: [-300, -100]
        pushVelocity: [0, 0.02]
      ]
  ,

    comment: "Level 2"
    sources:
      [
        position: [-300, 0]
        initialVelocity: [1, 0]
        hue: 0
      ]
    sinks:
      [
        position: [300, 0]
        hue: 0
      ]
    pushers:
      [
        position: [-300, -100]
        pushVelocity: [0.02, 0]
      ]
  ,

    comment: "Level 3"
    sources:
      [
        position: [-150, -50]
        initialVelocity: [1, 0]
        hue: 0
      ]
    sinks:
      [
        position: [150, 150]
        hue: 0
      ]
    pushers:
      [
        position: [-300, -100]
        pushVelocity: [0, 0.02]
      ,
        position: [150, 50]
        pushVelocity: [-0.02, 0]
      ]
    walls:
      [
        dimensions: [10, 100, 30]
        position: [50, 50, 0]
      ]
  ]

# Forward Locals to Globals
window.levels = levels
