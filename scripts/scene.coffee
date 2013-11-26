# Load the Physics Engine
Physijs.scripts.worker = "build/physijs/physijs_worker.js"
Physijs.scripts.ammo   = "examples/js/ammo.js"

# Scene Configuration
gravity = new THREE.Vector3(0, -9.81, 0)

# Define the Scene
scene = new Physijs.Scene()
scene.setGravity(gravity)

# Camera Configuration
aspect = window.innerWidth / window.innerHeight
fov    = 35
near   = 1
far    = 1000

# Create the Camera
camera = new THREE.PerspectiveCamera(
  fov,    # Field of View
  aspect, # Aspect Ratio
  near,   # Near Clipping Plane
  far)    # Far  Clipping Plane

camera.position.set(0, 10, 100) # X Y Z
scene.add camera
camera.lookAt(new THREE.Vector3(0,0,0))
console.log scene.position


# Add a Sample Box
box = new Physijs.BoxMesh(new THREE.CubeGeometry(5, 5, 5), new THREE.MeshBasicMaterial(color: 0x888888))
scene.add box

# Forward Locals to Globals
window.scene  = scene
window.camera = camera
