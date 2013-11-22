# Load the Physics Engine
Physijs.scripts.worker = "build/physijs/physijs_worker.js"
Physijs.scripts.ammo   = "examples/js/ammo.js"

# Setup the Camera
camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000)
camera.position.set 60, 50, 60

# Setup the Scene
scene = new Physijs.Scene
scene.setGravity(new THREE.Vector3( 1, 1, 1))
scene.add camera
camera.lookAt scene.position

# Add a Sample Box
box = new Physijs.BoxMesh(new THREE.CubeGeometry(5, 5, 5), new THREE.MeshBasicMaterial(color: 0x888888))
scene.add box

# Forward Locals to Globals
window.scene  = scene
window.camera = camera
