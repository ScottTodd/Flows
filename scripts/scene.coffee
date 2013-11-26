# -----------------------------------------------------------------------------
# Define the Scene
scene = new THREE.Scene
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Camera Configuration
position = new THREE.Vector3(0, 0, 300)
aspect   = window.innerWidth / window.innerHeight
fov      = 70
near     = 1
far      = 1000
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Create the Camera
camera = new THREE.PerspectiveCamera(
  fov,    # Field of View
  aspect, # Aspect Ratio
  near,   # Near Clipping Plane
  far)    # Far  Clipping Plane
camera.position = position
camera.lookAt(scene.position)
scene.add(camera)
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Create particle variables
particleCount = 1800
particlesGeometry = new THREE.Geometry()
pMaterial = new THREE.ParticleBasicMaterial(
  color: 0xFFFFFF
  size: 20
  map: THREE.ImageUtils.loadTexture("images/particle.png")
  blending: THREE.AdditiveBlending
  transparent: true
)
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Create invidual particles
p = 0
while p < particleCount
  particle = new THREE.Vector3
  particle.x = Math.random() * window.innerWidth - window.innerWidth / 2
  particle.y = Math.random() * window.innerHeight - window.innerHeight / 2

  particle.velocity = new THREE.Vector3(0, -Math.random(), 0)

  particlesGeometry.vertices.push particle
  p++

# Create the particle system
particleSystem = new THREE.ParticleSystem(particlesGeometry, pMaterial)
particleSystem.sortParticles = true

# Add the particle system to the scene
scene.add particleSystem
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Forward Locals to Globals
window.scene  = scene
window.camera = camera
window.particleCount = particleCount
window.particlesGeometry = particlesGeometry
window.particleSystem = particleSystem
# -----------------------------------------------------------------------------
