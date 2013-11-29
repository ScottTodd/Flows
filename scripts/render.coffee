# Render Settings
parameters =
  antialias: true
  alpha: true
  clearColor: 0x020404
  maxLights: 16
  precision: "highp"

# Create the Renderer
renderer = new THREE.WebGLRenderer(parameters) # Render
document.body.appendChild(renderer.domElement) # Canvas
renderer.setSize(window.innerWidth, window.innerHeight)
renderer.setClearColor(parameters.clearColor, 1.0)

# Define a Render Loop
render = () ->
  scene.update()                  # Handle events
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
