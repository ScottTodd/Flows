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

walls = []
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

walls.push new Wall(scene, foregroundMaterial,
                    new THREE.Vector3(200, 10, 30),
                    new THREE.Vector3(0, 150, 0))

# Create some FlowSources
sources = []
sources.push new FlowSource(scene, new THREE.Vector2(-300, 50),
                            new THREE.Vector2(1, 0), 0xCC3333)
sources.push new FlowSource(scene, new THREE.Vector2(300, -50),
                            new THREE.Vector2(-1, 0), 0x3333CC)
sources.push new FlowSource(scene, new THREE.Vector2(0, -150),
                            new THREE.Vector2(0, 1), 0x33CC33)

# Create some Pushers
pushers = []
pushers.push new Pusher(scene, new THREE.Vector2(0, 50),
                        new THREE.Vector2(0, 0.02))
pushers.push new Pusher(scene, new THREE.Vector2(-100, -50),
                        new THREE.Vector2(0, -0.02))
pushers.push new Pusher(scene, new THREE.Vector2(-100, 50),
                        new THREE.Vector2(0.02, -0.02))

# Update the Scene (Called Every Frame)
THREE.Scene::update = () ->
  for source in sources
    source.update(walls, pushers)

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
