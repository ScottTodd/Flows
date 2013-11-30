# Define Wall class
#   - Destroys particles that come into contact with it
#   - ignores z values for collision
#   - Walls are passed in an array to the update method of each FlowSource
class Wall
  constructor: (scene, material, dimensions, position) ->
    @scene = scene
    @material = material
    @dimensions = dimensions
    @position = position

    @geometry = new THREE.CubeGeometry(dimensions.x, dimensions.y, dimensions.z)
    @mesh     = new THREE.Mesh(@geometry, @material)
    @mesh.position.x = position.x
    @mesh.position.y = position.y
    @mesh.position.z = position.z
    @scene.add @mesh

  collidingWith: (otherPosition) ->
    return (otherPosition.x >= @position.x - @dimensions.x / 2 and
            otherPosition.x <= @position.x + @dimensions.x / 2 and
            otherPosition.y >= @position.y - @dimensions.y / 2 and
            otherPosition.y <= @position.y + @dimensions.y / 2)

  removeFromScene: ->
    @scene.remove @mesh

# Forward Locals to Globals
window.Wall = Wall
