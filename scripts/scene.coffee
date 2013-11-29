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
  constructor: (position, initialVelocity, particleColor) ->
    @position = position
    @initialVelocity = initialVelocity
    @color = particleColor

    @particleMaterial = new THREE.ParticleBasicMaterial
      color: particleColor
      size: 20
      map: THREE.ImageUtils.loadTexture "images/particle.png"
      blending: THREE.AdditiveBlending
      transparent: true

    @particleCount = 600
    @currentParticle = 0

    @initializeParticles()

  # Start all particles off-screen and move them on-screen in createParticle
  initializeParticles: ->
    @particlesGeometry = new THREE.Geometry

    # Create and initialize individual particles
    for i in [0..@particleCount] by 1
      particle = new THREE.Vector3
      particle.x = -2000 # offscreen
      particle.y = -2000 # offscreen
      particle.velocity = new THREE.Vector3(0, 0, 0)
      @particlesGeometry.vertices.push particle

    # Create the particle system
    @particleSystem = new THREE.ParticleSystem(@particlesGeometry,
                                               @particleMaterial)
    @particleSystem.sortParticles = true
    scene.add @particleSystem

  # Reset particle @currentParticle to initial conditions, "creating" it
  createParticle: ->
    # If the maximum number of particles is reached, start reusing particles
    if @currentParticle >= @particleCount
      @currentParticle = 0

    particle = @particlesGeometry.vertices[@currentParticle]
    particle.x = @position.x
    particle.y = @position.y
    particle.velocity = new THREE.Vector3(@initialVelocity.x,
                                          @initialVelocity.y,
                                          0)
    @particleSystem.geometry.__dirtyVertices = true

    @currentParticle++

  updateParticles: (pushers)->
    for particle in @particlesGeometry.vertices

      for pusher in pushers
        if (particle.x > pusher.position.x - pusher.radius and
            particle.x < pusher.position.x + pusher.radius and
            particle.y > pusher.position.y - pusher.radius and
            particle.y < pusher.position.y + pusher.radius)
          particle.velocity.add pusher.pushVelocity

      particle.add particle.velocity

      # Add some jitter
      particle.add new THREE.Vector3(1.2 * (Math.random() - 0.5),
                                     1.2 * (Math.random() - 0.5),
                                     0)

    # Flag to the particle system that we have changed its vertices.
    @particleSystem.geometry.__dirtyVertices = true

  update: (pushers)->
    @createParticle()
    @updateParticles(pushers)

class Pusher
  constructor: (position, pushVelocity) ->
    @position = position
    @pushVelocity = new THREE.Vector3(pushVelocity.x, pushVelocity.y, 0)
    @radius = 20

# Create some FlowSources
sources = []
sources.push new FlowSource(new THREE.Vector2(-300, 50),
                           new THREE.Vector2(1, 0),
                           0xCC3333)
sources.push new FlowSource(new THREE.Vector2(300, -50),
                            new THREE.Vector2(-1, 0),
                            0x3333CC)
sources.push new FlowSource(new THREE.Vector2(0, -150),
                            new THREE.Vector2(0, 1),
                            0x33CC33)

pushers = []
pushers.push new Pusher(new THREE.Vector2(0, 50), new THREE.Vector2(0, 0.02))
pushers.push new Pusher(new THREE.Vector2(-100, -50), new THREE.Vector2(0, -0.02))

# Update the Scene (Called Every Frame)
THREE.Scene::update = () ->
  for source in sources
    source.update(pushers)

# Forward Locals to Globals
window.scene  = scene
window.camera = camera
