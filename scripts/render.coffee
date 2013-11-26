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

# Define a Render Loop
render = () ->
  scene.simulate()                # Handle Physics
  renderer.render(scene, camera)  # Render the Scene
  requestAnimationFrame(render)   # Call Next Frame

render() # Start Loop

# Adjust the Viewport on Window Resize
window.addEventListener "resize", ->
  renderer.setSize(window.innerWidth, window.innerHeight)
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
