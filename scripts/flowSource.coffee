# Constants
pi = 3.14159265358979323

# Define FlowSource class
#   - Spawns particles over time of a given color in a given direction
#   - After particleCount # of particles are spawned, the oldest particles
#     are killed and reused
class FlowSource
  constructor: (scene, position, initialVelocity, particleHue) ->
    @scene = scene
    @position = position
    @initialVelocity = initialVelocity

    @hue = particleHue
    @particleColor = new THREE.Color()
    @particleColor.setHSL(@hue, 0.7, 0.3)
    @sourceColor = new THREE.Color()
    @sourceColor.setHSL(@hue, 0.6, 0.4)

    @radius = 10
    @direction = new THREE.Vector3(@initialVelocity.x, @initialVelocity.y, 0)
    @direction.normalize()
    # Perpendicular Direction
    @pDirection = new THREE.Vector3(@direction.x, @direction.y, 0)
    @pDirection.applyEuler(new THREE.Euler(0, 0, pi/2)) # 90 degrees
    @createMeshes()

    @particleMaterial = new THREE.ParticleBasicMaterial
      color: @particleColor
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
    @sphereMaterial = new THREE.MeshLambertMaterial(color: @sourceColor)
    @sphereMesh     = new THREE.Mesh(@sphereGeometry, @sphereMaterial)
    @sphereMesh.position = new THREE.Vector3(@position.x, @position.y, 0)
    @scene.add @sphereMesh

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
    @scene.add @pointerMesh1
    @scene.add @pointerMesh2
    @scene.add @pointerMesh3

  removeFromScene: ->
    @scene.remove @sphereMesh
    @scene.remove @pointerMesh1
    @scene.remove @pointerMesh2
    @scene.remove @pointerMesh3
    @scene.remove @particleSystem

  # Start all particles off-screen and move them on-screen in createParticle
  initializeParticles: ->
    @particlesGeometry = new THREE.Geometry

    # Create and initialize individual particles
    for i in [0..@particleCount] by 1
      particle = new THREE.Vector3
      particle.x = -2000 # offscreen
      particle.y = -2000 # offscreen
      particle.velocity = new THREE.Vector3(0, 0, 0)
      particle.splitChoice = 0
      @particlesGeometry.vertices.push particle

    # Create the particle system
    @particleSystem = new THREE.ParticleSystem(@particlesGeometry,
                                               @particleMaterial)
    @particleSystem.sortParticles = true
    @scene.add @particleSystem

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

  compareHue: (otherHue) ->
    return Math.abs(@hue - otherHue) < 0.01

  updateParticles: (walls, sinks, pushers, splitters) ->
    for particle in @particlesGeometry.vertices

      # Test walls
      for wall in walls
        if wall.collidingWith(particle)
          particle.x = -2000 # offscreen
          particle.y = -2000 # offscreen

      # Test sinks
      for sink in sinks
        if sink.collidingWith(particle) and @compareHue(sink.hue)
          particle.x = -2000 # offscreen
          particle.y = -2000 # offscreen
          sink.charge += sink.chargeAddRate

      # Test pushers
      for pusher in pushers
        if pusher.collidingWith(particle)
          particle.velocity.add pusher.pushVelocity

      # Test splitters
      collidedWithAnySplitters = false
      for splitter in splitters
        if splitter.collidingWith(particle)
          collidedWithAnySplitters = true

          if particle.splitChoice == 0
            particle.splitChoice = Math.floor(Math.random() * 2) + 1
          if particle.splitChoice == 1
            particle.velocity.add splitter.pushVelocity1
          if particle.splitChoice == 2
            particle.velocity.add splitter.pushVelocity2
      if not collidedWithAnySplitters
        particle.splitChoice = 0

      # Done testing, add current velocity to position
      particle.add particle.velocity

      # Add some jitter
      particle.add new THREE.Vector3(0.8 * (Math.random() - 0.5),
                                     0.8 * (Math.random() - 0.5),
                                     0)

  update: (walls, sinks, pushers, splitters) ->
    @createParticle()
    @updateParticles(walls, sinks, pushers, splitters)

# Forward Locals to Globals
window.FlowSource = FlowSource
