# Define Splitter class
#   - Pushes particles from FlowSources in a random of two given directions
#   - Splitters are passed in an array to the update method of each FlowSource
class Splitter
  constructor: (scene, position, pushVelocity1, pushVelocity2) ->
    @scene = scene
    @position = position
    @pushVelocity1 = new THREE.Vector3(pushVelocity1.x, pushVelocity1.y, 0)
    @pushVelocity2 = new THREE.Vector3(pushVelocity2.x, pushVelocity2.y, 0)
    @radius = 20
    @direction1 = new THREE.Vector3(pushVelocity1.x, pushVelocity1.y, 0)
    @direction1.normalize()
    @direction2 = new THREE.Vector3(pushVelocity2.x, pushVelocity2.y, 0)
    @direction2.normalize()

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

    # Spheres positioned to show push directions
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

    @pointerSphere1Mesh = new THREE.Mesh(@sphereGeometry, @darkSphereMaterial)
    @pointerSphere1Mesh.position.x = @position.x + @direction1.x * @radius / 1.5
    @pointerSphere1Mesh.position.y = @position.y + @direction1.y * @radius / 1.5
    @pointerSphere1Mesh.position.z = depthZ * 0.5
    @scene.add @pointerSphere1Mesh

    @pointerSphere2Mesh = new THREE.Mesh(@sphereGeometry, @darkSphereMaterial)
    @pointerSphere2Mesh.position.x = @position.x + @direction2.x * @radius / 1.5
    @pointerSphere2Mesh.position.y = @position.y + @direction2.y * @radius / 1.5
    @pointerSphere2Mesh.position.z = depthZ * 0.5
    @scene.add @pointerSphere2Mesh

  removeFromScene: ->
    @scene.remove @backPlate1Mesh
    @scene.remove @backPlate2Mesh
    @scene.remove @centerSphereMesh
    @scene.remove @pointerSphere1Mesh
    @scene.remove @pointerSphere2Mesh

  setPosition: (newPosition) ->
    @position = newPosition
    @backPlate1Mesh.position.x = newPosition.x
    @backPlate1Mesh.position.y = newPosition.y
    @backPlate2Mesh.position.x = newPosition.x
    @backPlate2Mesh.position.y = newPosition.y
    @centerSphereMesh.position.x = newPosition.x
    @centerSphereMesh.position.y = newPosition.y
    @pointerSphere1Mesh.position.x = newPosition.x + @direction1.x * @radius / 1.5
    @pointerSphere1Mesh.position.y = newPosition.y + @direction1.y * @radius / 1.5
    @pointerSphere2Mesh.position.x = newPosition.x + @direction2.x * @radius / 1.5
    @pointerSphere2Mesh.position.y = newPosition.y + @direction2.y * @radius / 1.5

  collidingWith: (otherPosition) ->
    return (otherPosition.x >= @position.x - @radius and
            otherPosition.x <= @position.x + @radius and
            otherPosition.y >= @position.y - @radius and
            otherPosition.y <= @position.y + @radius)

# Forward Locals to Globals
window.Splitter = Splitter
