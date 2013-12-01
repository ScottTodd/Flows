levels =
  [
    sources:
      [
        position: [-300, 50]
        initialVelocity: [1, 0]
        hue: 0
      ,
        position: [300, -50]
        initialVelocity: [-1, 0]
        hue: 0.3
      ]
    sinks:
      [
        position: [200, -50]
        hue: 0.3
      ]
    pushers:
      [
        position: [-200, 50]
        pushVelocity: [0, -0.02]
      ]
    splitters:
      [
        position: [-135, 0]
        pushVelocity1: [-0.02, 0]
        pushVelocity2: [ 0.02, 0]
      ]
    walls:
      [
        dimensions: [200, 10, 30]
        position: [0, 150, 0]
      ]
  ,
    sources:
      [
        position: [-300, 50]
        initialVelocity: [1, 0]
        hue: 0
      ]
  ]

# Forward Locals to Globals
window.levels = levels
