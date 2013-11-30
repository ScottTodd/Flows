# Define Pusher class
#   - Pushes particles from FlowSources in a given direction
#   - Pushers are passed in an array to the update method of each FlowSource
class Pusher
  constructor: (scene, position, pushVelocity) ->
    @scene = scene
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
    @backPlate1Material = new THREE.MeshLambertMaterial(color: 0x434B4E)
    @backPlate1Mesh     = new THREE.Mesh(@backPlate1Geometry, @backPlate1Material)
    @backPlate1Mesh.position = new THREE.Vector3(@position.x, @position.y,
                                                 depthZ)
    @scene.add @backPlate1Mesh

    @backPlate2Geometry = new THREE.CubeGeometry(@radius * 1.6, @radius * 1.6, 5)
    @backPlate2Material = new THREE.MeshLambertMaterial(color: 0x737B7E)
    @backPlate2Mesh     = new THREE.Mesh(@backPlate2Geometry, @backPlate2Material)
    @backPlate2Mesh.position = new THREE.Vector3(@position.x, @position.y,
                                                 depthZ * 0.5)
    @scene.add @backPlate2Mesh

    # Spheres positioned to show push direction
    segments = 16
    rings = 16
    @sphereGeometry = new THREE.SphereGeometry(@radius/4.0, segments, rings)
    @lightSphereMaterial = new THREE.MeshLambertMaterial(color: 0xC3CBCE)
    @darkSphereMaterial = new THREE.MeshLambertMaterial(color: 0x636B6E)

    @centerSphereMesh = new THREE.Mesh(@sphereGeometry, @lightSphereMaterial)
    @centerSphereMesh.position.x = @position.x
    @centerSphereMesh.position.y = @position.y
    @centerSphereMesh.position.z = depthZ * 0.5
    @scene.add @centerSphereMesh

    @pointerSphereMesh = new THREE.Mesh(@sphereGeometry, @darkSphereMaterial)
    @pointerSphereMesh.position.x = @position.x + @direction.x * @radius / 1.5
    @pointerSphereMesh.position.y = @position.y + @direction.y * @radius / 1.5
    @pointerSphereMesh.position.z = depthZ * 0.5
    @scene.add @pointerSphereMesh

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

# Forward Locals to Globals
window.Pusher = Pusher
