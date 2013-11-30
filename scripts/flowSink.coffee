# Define FlowSink class
#   - Gains charge by absorbing particles
class FlowSink
  constructor: (scene, position, receptorHue) ->
    @scene = scene
    @position = position

    @charge = 0.0
    @chargeAddRate = 0.008
    @chargeDecayRate = 0.004

    @hue = receptorHue
    # Fixed color representing what this sink receives
    @color = new THREE.Color()
    @color.setHSL(@hue, 0.7, 0.4)

    # Varying color that glows, showing the charge of this sink
    @glowColor = new THREE.Color()
    @minBrightness = 0.04
    @maxBrightness = 0.5
    @brightness = @minBrightness
    @glowColor.setHSL(@hue, 0.7, @brightness)

    @radius = 10
    @createMeshes()

  createMeshes: ->
    # Large box the color of this sink
    @cubeGeometry = new THREE.CubeGeometry(@radius * 2, @radius * 2, 5)
    @cubeMaterial = new THREE.MeshLambertMaterial(color: @glowColor)
    @cubeMesh     = new THREE.Mesh(@cubeGeometry, @cubeMaterial)
    @cubeMesh.position = new THREE.Vector3(@position.x, @position.y, -5)
    @scene.add @cubeMesh

    # Four small spheres around the large box
    segments = 16
    rings = 16
    @supportGeometry = new THREE.SphereGeometry(@radius / 2.5, segments, rings)
    @supportMaterial = new THREE.MeshLambertMaterial(color: @color)
    @supportMesh1 = new THREE.Mesh(@supportGeometry, @supportMaterial)
    @supportMesh2 = new THREE.Mesh(@supportGeometry, @supportMaterial)
    @supportMesh3 = new THREE.Mesh(@supportGeometry, @supportMaterial)
    @supportMesh4 = new THREE.Mesh(@supportGeometry, @supportMaterial)
    @supportMesh1.position.x = @position.x + @radius * 1.2
    @supportMesh1.position.y = @position.y + @radius * 1.2
    @supportMesh2.position.x = @position.x + @radius * 1.2
    @supportMesh2.position.y = @position.y - @radius * 1.2
    @supportMesh3.position.x = @position.x - @radius * 1.2
    @supportMesh3.position.y = @position.y + @radius * 1.2
    @supportMesh4.position.x = @position.x - @radius * 1.2
    @supportMesh4.position.y = @position.y - @radius * 1.2
    @scene.add @supportMesh1
    @scene.add @supportMesh2
    @scene.add @supportMesh3
    @scene.add @supportMesh4

  removeFromScene: ->
    @scene.remove @cubeMesh
    @scene.remove @supportMesh1
    @scene.remove @supportMesh2
    @scene.remove @supportMesh3
    @scene.remove @supportMesh4

  collidingWith: (otherPosition) ->
    return (otherPosition.x >= @position.x - @radius and
            otherPosition.x <= @position.x + @radius and
            otherPosition.y >= @position.y - @radius and
            otherPosition.y <= @position.y + @radius)

  update: ->
    @charge -= @chargeDecayRate
    if @charge < 0
      @charge = 0
    if @charge > 1
      @charge = 1

    @brightness = @minBrightness + @charge * (@maxBrightness - @minBrightness)
    @glowColor.setHSL(@hue, 0.7, @brightness)

    @cubeMaterial.color = @glowColor

# Forward Locals to Globals
window.FlowSink = FlowSink
