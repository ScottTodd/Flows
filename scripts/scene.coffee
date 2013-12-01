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
directionalLight1.position.set(0.5, -0.3, 0.5)
scene.add directionalLight1

directionalLight2 = new THREE.DirectionalLight(0xDDDDFF, 0.8)
directionalLight2.position.set(-0.5, 0.3, 0.5)
scene.add directionalLight2

# Add the floor and several walls
backgroundMaterial = new THREE.MeshLambertMaterial(color: 0x11171A)
foregroundMaterial = new THREE.MeshLambertMaterial(color: 0x31373A)
floorGeometry      = new THREE.CubeGeometry(700, 400, 10)
floorMesh          = new THREE.Mesh(floorGeometry, backgroundMaterial)
floorMesh.position.z = -20
scene.add floorMesh

# Game Entities
sources = []
sinks = []
pushers = []
splitters = []
walls = []

loadDefaultWalls = ->
  walls.push new Wall(scene, backgroundMaterial,
                      new THREE.Vector3(10, 400, 30),
                      new THREE.Vector3(-350, 0, 0)) # Left
  walls.push new Wall(scene, backgroundMaterial,
                      new THREE.Vector3(10, 400, 30),
                      new THREE.Vector3(350, 0, 0))  # Right
  walls.push new Wall(scene, backgroundMaterial,
                      new THREE.Vector3(700, 10, 30),
                      new THREE.Vector3(0, 200, 0))  # Top
  walls.push new Wall(scene, backgroundMaterial,
                      new THREE.Vector3(700, 10, 30),
                      new THREE.Vector3(0, -200, 0)) # Bottom

# Game State Variables
controlElement = -1
currentLevel = 4
levelLoaded = false
gameOver = false

emptyTheScene = ->
  for objectArray in [sources, sinks, pushers, splitters, walls]
    for object in objectArray
      object.removeFromScene()
    objectArray.length = 0

loadLevel = (levelNumber) ->
  if currentLevel >= levels.length
    levelLoaded = true
    gameOver = true
    return

  loadDefaultWalls()
  levelToLoad = levels[currentLevel]

  # FlowSources
  if levelToLoad.sources
    for source in levelToLoad.sources
      sources.push new FlowSource(scene,
          new THREE.Vector2(source.position[0], source.position[1]),
          new THREE.Vector2(source.initialVelocity[0],
                            source.initialVelocity[1]),
          source.hue)

  # FlowSinks
  if levelToLoad.sinks
    for sink in levelToLoad.sinks
      sinks.push new FlowSink(scene,
          new THREE.Vector2(sink.position[0], sink.position[1]),
          sink.hue)

  # Pushers
  if levelToLoad.pushers
    for pusher in levelToLoad.pushers
      pushers.push new Pusher(scene,
          new THREE.Vector2(pusher.position[0], pusher.position[1]),
          new THREE.Vector2(pusher.pushVelocity[0], pusher.pushVelocity[1]))

  # Splitters
  if levelToLoad.splitters
    for splitter in levelToLoad.splitters
      splitters.push new Splitter(scene,
          new THREE.Vector2(splitter.position[0], splitter.position[1]),
          new THREE.Vector2(splitter.pushVelocity1[0],
                            splitter.pushVelocity1[1]),
          new THREE.Vector2(splitter.pushVelocity2[0],
                            splitter.pushVelocity2[1]))

  # Walls
  if levelToLoad.walls
    for wall in levelToLoad.walls
      walls.push new Wall(scene, foregroundMaterial,
          new THREE.Vector3(wall.dimensions[0],
                            wall.dimensions[1],
                            wall.dimensions[2]),
          new THREE.Vector3(wall.position[0],
                            wall.position[1],
                            wall.position[2]))

  levelLoaded = true

testForVictory = ->
  for sink in sinks
    if sink.charge < 1 - 0.001
      return false
  return true

# Update the Scene (Called Every Frame)
THREE.Scene::update = () ->
  if gameOver
    # TODO: display 'You Win' or similar text
    #       stop the render loop?
    return

  if not levelLoaded
    emptyTheScene()
    loadLevel(currentLevel)

  for sink in sinks
    sink.update()

  for source in sources
    source.update(walls, sinks, pushers, splitters)

  if testForVictory()
    levelLoaded = false
    currentLevel++

# Listen for Keypresses
# 1 controls the first pusher, 2 controls the second, etc.
# splitters are ordered after pushers
window.addEventListener "keydown", (event) ->
  # key 0 -> keyCode 48
  # key 1 -> keyCode 49
  # ...
  # key 9 -> keyCode 57
  controlElement = event.which - 49
  console.log(controlElement)

# Listen for the Mouse Coordinates on Movement
window.addEventListener "mousemove", (event) ->
  # Temp scale values, will need a more sophisticated conversion for control
  scaledX = event.clientX / window.innerWidth * 600 - 300
  scaledY = event.clientY / window.innerHeight * -400 + 200
  newPosition = new THREE.Vector2(scaledX, scaledY)

  if controlElement >= 0 and controlElement < pushers.length
    pushers[controlElement].setPosition(newPosition)
  if (controlElement - pushers.length >= 0 and
      controlElement < pushers.length + splitters.length)
    splitters[controlElement - pushers.length].setPosition(newPosition)

# Forward Locals to Globals
window.scene  = scene
window.camera = camera
