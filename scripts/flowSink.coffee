# Define FlowSink class
#   - Gains charge by absorbing particles
class FlowSink
  constructor: (scene, position, receptorHue) ->
    @scene = scene
    @position = position

    @hue = receptorHue
    @color = new THREE.Color()
    @color.setHSL(@hue, 0.6, 1)
    @brightness = 0.0
    @glowRate = 0.005
    @glowDirection = 1

    @radius = 10
    @createMeshes()

  createMeshes: ->
    segments = 16
    rings = 16
    # Large sphere the color of this sink
    @sphereGeometry = new THREE.SphereGeometry(@radius, segments, rings)
    @sphereMaterial = new THREE.MeshLambertMaterial(color: @color)
    @sphereMesh     = new THREE.Mesh(@sphereGeometry, @sphereMaterial)
    @sphereMesh.position = new THREE.Vector3(@position.x, @position.y, 0)
    @scene.add @sphereMesh

  update: ->
    @color.setHSL(@hue, 1, @brightness)
    @brightness += @glowDirection * @glowRate
    if @brightness >= 0.4
      @glowDirection = -1
    if @brightness <= 0.2
      @glowDirection = 1

    @sphereMaterial.color = @color

# Forward Locals to Globals
window.FlowSink = FlowSink
