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
        position: [-300, -150]
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
        position: [-300, -150]
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
        position: [-300, -150]
        pushVelocity: [0, 0.02]
      ,
        position: [-240, -150]
        pushVelocity: [-0.02, 0]
      ]
    walls:
      [
        dimensions: [10, 100, 30]
        position: [50, 50, 0]
      ]
  ,

    comment: "Level 4"
    sources:
      [
        position: [-150, -50]
        initialVelocity: [1, 0]
        hue: 0
      ,
        position: [150, -50]
        initialVelocity: [-1, 0]
        hue: 0.6
      ]
    sinks:
      [
        position: [-150, 50]
        hue: 0.6
      ,
        position: [150, 50]
        hue: 0
      ]
    pushers:
      [
        position: [-300, -150]
        pushVelocity: [0, 0.02]
      ]
    walls:
      [
        dimensions: [350, 10, 30]
        position: [0, -100, 0]
      ,
        dimensions: [10, 100, 30]
        position: [-50, 100, 0]
      ,
        dimensions: [10, 100, 30]
        position: [50, 100, 0]
      ]
  ,

    comment: "Level 5"
    sources:
      [
        position: [-200, 0]
        initialVelocity: [1, 0]
        hue: 0
      ,
        position: [0, -150]
        initialVelocity: [0, 1]
        hue: 0.6
      ]
    sinks:
      [
        position: [0, 150]
        hue: 0
      ,
        position: [200, 0]
        hue: 0.6
      ]
    pushers:
      [
        position: [-300, -150]
        pushVelocity: [0, 0.02]
      ,
        position: [-240, -150]
        pushVelocity: [-0.02, 0]
      ,
        position: [-180, -150]
        pushVelocity: [0.02, 0]
      ,
        position: [-120, -150]
        pushVelocity: [0, -0.02]
      ]
  ,

    comment: "Level 6"
    sources:
      [
        position: [-200, 0]
        initialVelocity: [1, 0]
        hue: 0
      ]
    sinks:
      [
        position: [100, 100]
        hue: 0
      ,
        position: [100, -100]
        hue: 0
      ]
    splitters:
      [
        position: [-300, -150]
        pushVelocity1: [0, 0.02]
        pushVelocity2: [0, -0.02]
      ]
  ,

    comment: "Level 7"
    sources:
      [
        position: [-200, 0]
        initialVelocity: [1, 0]
        hue: 0
      ]
    sinks:
      [
        position: [100, 150]
        hue: 0
      ,
        position: [100, -100]
        hue: 0
      ]
    pushers:
      [
        position: [-300, -150]
        pushVelocity: [0, 0.02]
      ]
    splitters:
      [
        position: [-240, -150]
        pushVelocity1: [0, 0.02]
        pushVelocity2: [0, -0.02]
      ]
  ,

    comment: "Level 8"
    sources:
      [
        position: [-250, 0]
        initialVelocity: [1, 0]
        hue: 0
      ,
        position: [-250, -80]
        initialVelocity: [1, 0]
        hue: 0.6
      ]
    sinks:
      [
        position: [100, 150]
        hue: 0.6
      ,
        position: [150, 100]
        hue: 0
      ]
    pushers:
      [
        position: [-300, -150]
        pushVelocity: [0, 0.02]
      ]
    splitters:
      [
        position: [-240, -150]
        pushVelocity1: [0, 0.02]
        pushVelocity2: [0, -0.02]
      ]
  ,

    comment: "Level 9"
    sources:
      [
        position: [-250, 50]
        initialVelocity: [1, 0]
        hue: 0
      ,
        position: [250, 50]
        initialVelocity: [-1, 0]
        hue: 0.6
      ]
    sinks:
      [
        position: [-100, -100]
        hue: 0.6
      ,
        position: [100, -100]
        hue: 0
      ]
    pushers:
      [
        position: [-300, -150]
        pushVelocity: [0, -0.02]
      ,
        position: [-240, -150]
        pushVelocity: [0, -0.02]
      ]
    splitters:
      [
        position: [-180, -150]
        pushVelocity1: [0.02, 0]
        pushVelocity2: [-0.02, 0]
      ]
    walls:
      [
        dimensions: [10, 100, 30]
        position: [0, -50, 0]
      ]
  ]

# Forward Locals to Globals
window.levels = levels
