# [Flows](http://github.com/ScottTodd/Flows)

![Flows](http://scotttodd.github.io/Flows/screenshots/level08.png)

## Summary
Based loosely on the theme of *Change*, Flows is a game about *changing* the flow of particles in the stage. To complete each level, you must position the pushers and splitters provided in such a way that each flow reaches the sink of the same color.

Best viewed in Google Chrome, also tested in Mozilla Firefox.

Submitted to [GitHub's Game Off 2013](https://github.com/github/game-off-2013) and completed as our [Computer Graphics](http://www.ecse.rpi.edu/~wrf/pmwiki/pmwiki.php/ComputerGraphicsFall2013/ComputerGraphicsFall2013) Term Project at RPI.

## Team Members
- [Kevin Fung](https://github.com/polytonic)
- [Scott Todd](https://github.com/ScottTodd)

## Getting Started
Running Flows Locally:
  1.  `git clone --recursive https://github.com/ScottTodd/Flows`
  2. `npm install -g jade`
  3. `cd build && jade index.jade && cd ..`
  4.  `python -m SimpleHTTPServer 8080`
  5.  Visit `http://localhost:8080/`

Running Flows Online:
  1.  Note: This is the latest version of our code, which may include changes after GitHub's Game Off deadline.
  2.  [Flows on GitHub Pages](http://scotttodd.github.io/Flows/)

## Controls
- Click and drag to move pushers and splitters.

## Dependencies
- [three.js](https://github.com/mrdoob/three.js/)
- [CoffeeScript](https://github.com/jashkenas/coffee-script)
- [Jade](https://github.com/visionmedia/jade)

## References / Other Links
- [js2coffee](http://js2coffee.org/)
- [three.js particles example](http://threejs.org/examples/webgl_particles_random.html)
- [three.js particles tutorial](http://www.aerotwist.com/tutorials/creating-particles-with-three-js/)
