# Render Settings
parameters =
  antialias: true
  clearColor: 0xFFFFFF
  maxLights: 16
  precision: "highp"

# Create the Renderer
renderer = new THREE.WebGLRenderer(parameters) # Render
document.body.appendChild(renderer.domElement) # Canvas
renderer.setSize(window.innerWidth, window.innerHeight)
# renderer.setClearColor(parameters.clearColor, 1.0)

updateParticles = () ->
  pCount = window.particleCount
  while pCount--
    particle = window.particlesGeometry.vertices[pCount]

    particle.add particle.velocity

    if particle.y < -100
      particle.velocity.add new THREE.Vector3(0.1, 0, 0)
    if particle.x > 100
      particle.velocity.add new THREE.Vector3(0, 0.1, 0)
    if particle.x > 400
      particle.x = -400
      particle.y = 200
      particle.velocity = new THREE.Vector3((Math.random() - 0.5)/2, -Math.random(), 0)

  # Flag to the particle system that we've changed its vertices.
  window.particleSystem.geometry.__dirtyVertices = true

# Define a Render Loop
render = () ->
  updateParticles()

  renderer.render(scene, camera)  # Render the Scene
  requestAnimationFrame(render)   # Call Next Frame

render() # Start Loop

# Adjust the Viewport on Window Resize
window.addEventListener "resize", ->
  renderer.setSize(window.innerWidth, window.innerHeight)
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()

# Record the Mouse Coordinates on Movement
window.addEventListener "mousemove", (event) ->
  console.log event.clientX
  console.log event.clientY
