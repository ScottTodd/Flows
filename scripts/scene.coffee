# Constants
pi = 3.14159265358979323

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

# Add some Lights to the Scene
directionalLight1 = new THREE.DirectionalLight(0xFFDDDD, 0.8)
directionalLight1.position.set(0.5, -0.2, 0.5)
scene.add directionalLight1

directionalLight2 = new THREE.DirectionalLight(0xDDDDFF, 0.8)
directionalLight2.position.set(-0.5, 0.2, 0.5)
scene.add directionalLight2

# Define FlowSource class
class FlowSource
  constructor: (position, initialVelocity, particleColor) ->
    @position = position
    @initialVelocity = initialVelocity
    @color = particleColor

    @radius = 10
    @direction = new THREE.Vector3(@initialVelocity.x, @initialVelocity.y, 0)
    @direction.normalize()
    # Perpendicular Direction
    @pDirection = new THREE.Vector3(@direction.x, @direction.y, 0)
    @pDirection.applyEuler(new THREE.Euler(0, 0, pi/2))
    @createMeshes()

    @particleMaterial = new THREE.ParticleBasicMaterial
      color: particleColor
      size: 20
      map: THREE.ImageUtils.loadTexture "images/particle.png"
      blending: THREE.AdditiveBlending
      transparent: true

    @particleCount = 600
    @currentParticle = 0
    @initializeParticles()

  createMeshes: ->
    segments = 16
    rings = 16
    # Large sphere the color of this source
    @sphereGeometry = new THREE.SphereGeometry(@radius, segments, rings)
    @sphereMaterial = new THREE.MeshLambertMaterial(color: @color)
    @sphereMesh     = new THREE.Mesh(@sphereGeometry, @sphereMaterial)
    @sphereMesh.position = new THREE.Vector3(@position.x, @position.y, 0)
    scene.add @sphereMesh

    # Three small spheres around the large sphere, pointing in spawn direction
    @pointerGeometry = new THREE.SphereGeometry(@radius / 2.5, segments, rings)
    @pointerMaterial = new THREE.MeshLambertMaterial(color: 0x434B4E)
    @pointerMesh1 = new THREE.Mesh(@pointerGeometry, @pointerMaterial)
    @pointerMesh2 = new THREE.Mesh(@pointerGeometry, @pointerMaterial)
    @pointerMesh3 = new THREE.Mesh(@pointerGeometry, @pointerMaterial)
    @pointerMesh1.position.x = @position.x - @direction.x  * @radius * 1.2
    @pointerMesh1.position.y = @position.y - @direction.y  * @radius * 1.2
    @pointerMesh2.position.x = @position.x + @pDirection.x * @radius * 1.2
    @pointerMesh2.position.y = @position.y + @pDirection.y * @radius * 1.2
    @pointerMesh3.position.x = @position.x - @pDirection.x * @radius * 1.2
    @pointerMesh3.position.y = @position.y - @pDirection.y * @radius * 1.2
    scene.add @pointerMesh1
    scene.add @pointerMesh2
    scene.add @pointerMesh3

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
    particle.x = @position.x + (Math.random() * @radius) - @radius / 2.0
    particle.y = @position.y + (Math.random() * @radius) - @radius / 2.0
    particle.velocity = new THREE.Vector3(@initialVelocity.x,
                                          @initialVelocity.y,
                                          0)

    @currentParticle++

  updateParticles: (pushers)->
    for particle in @particlesGeometry.vertices

      for pusher in pushers
        if (particle.x >= pusher.position.x - pusher.radius and
            particle.x <= pusher.position.x + pusher.radius and
            particle.y >= pusher.position.y - pusher.radius and
            particle.y <= pusher.position.y + pusher.radius)
          particle.velocity.add pusher.pushVelocity

      particle.add particle.velocity

      # Add some jitter
      particle.add new THREE.Vector3(1.2 * (Math.random() - 0.5),
                                     1.2 * (Math.random() - 0.5),
                                     0)

  update: (pushers)->
    @createParticle()
    @updateParticles(pushers)

class Pusher
  constructor: (position, pushVelocity) ->
    @position = position
    @pushVelocity = new THREE.Vector3(pushVelocity.x, pushVelocity.y, 0)
    @radius = 20
    @direction = new THREE.Vector3(pushVelocity.x, pushVelocity.y, 0)
    @direction.normalize()

    @createMeshes()

  createMeshes: ->
    depthZ = -5

    # Back Plates to show area of influence
    @backPlate1Geometry = new THREE.CubeGeometry(@radius * 2, @radius * 2, 5)
    @backPlate1Material = new THREE.MeshLambertMaterial(color: 0x636B6E)
    @backPlate1Mesh     = new THREE.Mesh(@backPlate1Geometry, @backPlate1Material)
    @backPlate1Mesh.position = new THREE.Vector3(@position.x, @position.y,
                                                 depthZ)
    scene.add @backPlate1Mesh

    @backPlate2Geometry = new THREE.CubeGeometry(@radius * 1.6, @radius * 1.6, 5)
    @backPlate2Material = new THREE.MeshLambertMaterial(color: 0xB3BBBE)
    @backPlate2Mesh     = new THREE.Mesh(@backPlate2Geometry, @backPlate2Material)
    @backPlate2Mesh.position = new THREE.Vector3(@position.x, @position.y,
                                                 depthZ * 0.5)
    scene.add @backPlate2Mesh

    # Spheres positioned to show push direction
    segments = 16
    rings = 16
    @sphereGeometry = new THREE.SphereGeometry(@radius/4.0, segments, rings)
    @lightSphereMaterial = new THREE.MeshLambertMaterial(color: 0xE3EBEE)
    @darkSphereMaterial = new THREE.MeshLambertMaterial(color: 0x737B7E)

    @centerSphereMesh = new THREE.Mesh(@sphereGeometry, @lightSphereMaterial)
    @centerSphereMesh.position.x = @position.x
    @centerSphereMesh.position.y = @position.y
    @centerSphereMesh.position.z = depthZ * 0.5
    scene.add @centerSphereMesh

    @pointerSphereMesh = new THREE.Mesh(@sphereGeometry, @darkSphereMaterial)
    @pointerSphereMesh.position.x = @position.x + @direction.x * @radius / 1.5
    @pointerSphereMesh.position.y = @position.y + @direction.y * @radius / 1.5
    @pointerSphereMesh.position.z = depthZ * 0.5
    scene.add @pointerSphereMesh

  setPosition: (newPosition) ->
    @position = newPosition
    @backPlate1Mesh.position.x = newPosition.x
    @backPlate1Mesh.position.y = newPosition.y
    @backPlate2Mesh.position.x = newPosition.x
    @backPlate2Mesh.position.y = newPosition.y
    @centerSphereMesh.position.x = newPosition.x
    @centerSphereMesh.position.y = newPosition.y
    @pointerSphereMesh.position.x = newPosition.x + @direction.x * @radius / 1.5
    @pointerSphereMesh.position.y = newPosition.y + @direction.y * @radius / 1.5

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

# Create some Pushers
pushers = []
pushers.push new Pusher(new THREE.Vector2(0, 50),
                        new THREE.Vector2(0, 0.02))
pushers.push new Pusher(new THREE.Vector2(-100, -50),
                        new THREE.Vector2(0, -0.02))
pushers.push new Pusher(new THREE.Vector2(-100, 50),
                        new THREE.Vector2(0.02, -0.02))

# Update the Scene (Called Every Frame)
THREE.Scene::update = () ->
  for source in sources
    source.update(pushers)

# Listen for the Mouse Coordinates on Movement
window.addEventListener "mousemove", (event) ->
  # Temp scale values, will need a more sophisticated conversion for control
  scaledX = event.clientX / window.innerWidth * 600 - 300
  scaledY = event.clientY / window.innerHeight * -400 + 200
  newPosition = new THREE.Vector2(scaledX, scaledY)
  pushers[0].setPosition(newPosition)

# Forward Locals to Globals
window.scene  = scene
window.camera = camera
