# Define the Scene
scene = new THREE.Scene

# Camera Configuration
position = new THREE.Vector3(0, 0, 300)
aspect   = window.innerWidth / window.innerHeight
fov      = 70
near     = 1
far      = 1000

# Create the Camera
camera = new THREE.PerspectiveCamera(
  fov,    # Field of View
  aspect, # Aspect Ratio
  near,   # Near Clipping Plane
  far)    # Far  Clipping Plane
camera.position = position
camera.lookAt(scene.position)
scene.add(camera)

# Define FlowSource class
class FlowSource
  constructor: (position, particleColor, rotation) ->
    @position = position
    @color = particleColor
    @rotation = rotation # currently unused

    @particleMaterial = new THREE.ParticleBasicMaterial(
      color: particleColor
      size: 20
      map: THREE.ImageUtils.loadTexture "images/particle.png"
      blending: THREE.AdditiveBlending
      transparent: true
    )

    @particleCount = 1800
    @particlesGeometry = new THREE.Geometry

  createParticles: ->
    # create and initialize individual particles
    for i in [0..@particleCount] by 1
      particle = new THREE.Vector3
      particle.x = @position.x
      particle.y = @position.y
      particle.velocity = new THREE.Vector3(-Math.random() + 0.5, -Math.random() + 0.5, 0)
      @particlesGeometry.vertices.push particle

    # create the particle system
    @particleSystem = new THREE.ParticleSystem(@particlesGeometry, @particleMaterial)
    @particleSystem.sortParticles = true
    scene.add @particleSystem

  updateParticles: ->
    for i in [@particleCount-1..0] by -1
      particle = @particlesGeometry.vertices[i]

      particle.add particle.velocity

    # Flag to the particle system that we have changed its vertices.
    @particleSystem.geometry.__dirtyVertices = true

# Create some FlowSources
redSource = new FlowSource(new THREE.Vector2(-300, 0), 0xCC3333, 0)
redSource.createParticles()
blueSource = new FlowSource(new THREE.Vector2(300, 0), 0x3333CC, 0)
blueSource.createParticles()

# Update the Scene (Called Every Frame)
THREE.Scene::update = () ->
  redSource.updateParticles()
  blueSource.updateParticles()

# Forward Locals to Globals
window.scene  = scene
window.camera = camera
