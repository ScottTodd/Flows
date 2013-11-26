# Load the Physics Engine
Physijs.scripts.worker = "build/physijs/physijs_worker.js"
Physijs.scripts.ammo   = "examples/js/ammo.js"

# Scene Configuration
gravity = new THREE.Vector3(0, -9.81, 0)

# Define the Scene
scene = new Physijs.Scene()
scene.setGravity(gravity)

# Camera Configuration
position = new THREE.Vector3(0, 10, 50)
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

# Add a Sample Box
box2 = new Physijs.BoxMesh(new THREE.CubeGeometry(5, 5, 5), new THREE.MeshBasicMaterial(color: 0x888888), 10)
box2.position.y = 70
box2.rotation.x = 1
box2.rotation.z = 1
box2.rotation.y = 1
box = new Physijs.BoxMesh(new THREE.CubeGeometry(10, 1, 10), new THREE.MeshBasicMaterial(color: 0x888888), 0)
#box.position.z = 50
scene.add box
scene.add box2

# Forward Locals to Globals
window.scene  = scene
window.camera = camera
