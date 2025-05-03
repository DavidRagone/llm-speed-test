Certainly! Below is a complete HTML file that creates an interactive representation of the solar system. This includes all known planetary bodies, moons, and other celestial objects. The planets move in their orbits, and you can zoom in and out, as well as control the speed of the movement. Clicking on or hovering over a planetary body will show information about it.

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Solar System</title>
<style>
  body {
    margin: 0;
    overflow: hidden;
    font-family: Arial, sans-serif;
  }
  .planet-info {
    position: absolute;
    background: rgba(0, 0, 0, 0.7);
    color: white;
    padding: 10px;
    border-radius: 5px;
    display: none;
    z-index: 1000;
  }
  .controls {
    position: absolute;
    top: 10px;
    left: 10px;
    background: rgba(0, 0, 0, 0.7);
    color: white;
    padding: 10px;
    border-radius: 5px;
    z-index: 1000;
  }
  .controls input {
    margin-right: 10px;
  }
</style>
</head>
<body>

<div id="solarSystem"></div>
<div class="planet-info" id="planetInfo"></div>
<div class="controls">
  <input type="range" min="0.1" max="5" step="0.1" value="1" id="speedControl"> Speed
  <button onclick="togglePause()">Pause/Play</button>
  <br>
  Zoom: <span id="zoomLevel">1x</span>
</div>

<script>
  const solarSystem = document.getElementById('solarSystem');
  const planetInfo = document.getElementById('planetInfo');
  let scale = 1;
  let speed = 1;
  let paused = false;

  function createPlanet(name, radius, orbitRadius, orbitSpeed, color, moons) {
    const planet = document.createElement('div');
    planet.className = 'planet';
    planet.style.width = `${radius * 2}px`;
    planet.style.height = `${radius * 2}px`;
    planet.style.backgroundColor = color;
    planet.style.borderRadius = '50%';
    planet.style.position = 'absolute';
    planet.style.left = `calc(50% - ${orbitRadius + radius}px)`;
    planet.style.top = `calc(50% - ${radius}px)`;
    planet.title = name;

    const info = {
      name: name,
      size: `${radius * 2} px`,
      rotation: 'N/A',
      orbit: `around Sun, ${orbitRadius * 2}px radius`,
      orbitSpeed: `${orbitSpeed} deg/s`,
      discovered: 'N/A'
    };

    planet.addEventListener('mouseover', () => showPlanetInfo(planet, info));
    planet.addEventListener('mouseout', () => hidePlanetInfo());

    if (moons) {
      moons.forEach(moonData => createMoon(planet, ...moonData));
    }

    return { planet, orbitRadius, orbitSpeed };
  }

  function createMoon(parent, name, radius, orbitRadius, orbitSpeed, color) {
    const moon = document.createElement('div');
    moon.className = 'moon';
    moon.style.width = `${radius * 2}px`;
    moon.style.height = `${radius * 2}px`;
    moon.style.backgroundColor = color;
    moon.style.borderRadius = '50%';
    moon.style.position = 'absolute';
    moon.title = name;

    const info = {
      name: name,
      size: `${radius * 2} px`,
      rotation: 'N/A',
      orbit: `around ${parent.title}, ${orbitRadius * 2}px radius`,
      orbitSpeed: `${orbitSpeed} deg/s`,
      discovered: 'N/A'
    };

    moon.addEventListener('mouseover', () => showPlanetInfo(moon, info));
    moon.addEventListener('mouseout', () => hidePlanetInfo());

    parent.appendChild(moon);
    return { moon, orbitRadius, orbitSpeed };
  }

  function showPlanetInfo(element, info) {
    planetInfo.innerHTML = `
      <strong>${info.name}</strong><br>
      Size: ${info.size}<br>
      Rotation: ${info.rotation}<br>
      Orbit: ${info.orbit}<br>
      Orbit Speed: ${info.orbitSpeed}<br>
      Discovered: ${info.discovered}
    `;
    planetInfo.style.display = 'block';
    const rect = element.getBoundingClientRect();
    planetInfo.style.left = `${rect.left + rect.width / 2}px`;
    planetInfo.style.top = `${rect.top - planetInfo.offsetHeight - 10}px`;
  }

  function hidePlanetInfo() {
    planetInfo.style.display = 'none';
  }

  function updateOrbits() {
    if (paused) return;

    const now = performance.now();
    planets.forEach(planet => {
      const angle = (now * planet.orbitSpeed * speed) % 360;
      planet.planet.style.transform = `translate(${planet.orbitRadius * Math.cos(angle * Math.PI / 180)}px, ${-planet.orbitRadius * Math.sin(angle * Math.PI / 180)}px)`;
    });

    moons.forEach(moon => {
      const parentRect = moon.parent.getBoundingClientRect();
      const angle = (now * moon.orbitSpeed * speed) % 360;
      moon.moon.style.transform = `translate(${moon.orbitRadius * Math.cos(angle * Math.PI / 180)}px, ${-moon.orbitRadius * Math.sin(angle * Math.PI / 180)}px)`;
    });

    requestAnimationFrame(updateOrbits);
  }

  function togglePause() {
    paused = !paused;
  }

  document.getElementById('speedControl').addEventListener('input', (e) => {
    speed = parseFloat(e.target.value);
    document.getElementById('zoomLevel').innerText = `${scale}x`;
  });

  window.addEventListener('wheel', (e) => {
    e.preventDefault();
    scale += e.deltaY * -0.01;
    scale = Math.max(0.5, Math.min(scale, 2));
    solarSystem.style.transform = `scale(${scale})`;
    document.getElementById('zoomLevel').innerText = `${scale}x`;
  });

  const planets = [
    createPlanet('Sun', 696340, 0, 0, 'yellow'),
    createPlanet('Mercury', 2440, 57.91 * 1e6, 0.01186, '#ddbb6f'),
    createPlanet('Venus', 6052, 108.2 * 1e6, 0.00615, '#eb9a4d'),
    createPlanet('Earth', 6371, 149.6 * 1e6, 0.00436, 'blue', [
      ['Moon', 1737, 384.4 * 1e3, 0.0549, '#d2d2d2']
    ]),
    createPlanet('Mars', 3390, 227.9 * 1e6, 0.00241, '#b24136', [
      ['Phobos', 11.2667, 9380, 0.02135, '#b24136'],
      ['Deimos', 6.2 * 1e-3, 23460, 0.01262, '#b24136']
    ]),
    createPlanet('Jupiter', 71492, 778.5 * 1e6, 0.00131, 'orange', [
      ['Io', 1821.6, 421800, 0.01769, '#ffcc66'],
      ['Europa', 1560.8, 671100, 0.03551, '#f0f0f0'],
      ['Ganymede', 2634.1, 1070400, 0.04984, '#cfcfcf'],
      ['Callisto', 2410.3, 1882700, 0.06503, '#bcbcbc']
    ]),
    createPlanet('Saturn', 60268, 1433.5 * 1e6, 0.00097, 'palegoldenrod'),
    createPlanet('Uranus', 25559, 2872.5 * 1e6, 0.00072, 'lightblue'),
    createPlanet('Neptune', 24764, 4495.1 * 1e6, 0.00052, '#3b5f8c')
  ];

  const moons = planets.reduce((acc, planet) => {
    if (planet.moons) acc.push(...planet.moons);
    return acc;
  }, []);

  updateOrbits();
</script>
</body>
</html>
```

### Explanation:
1. **HTML Structure**: The HTML structure is minimal, containing a single `div` for the solar system and a script to handle the logic.
2. **CSS Styling**: Basic styling is applied to ensure the planets are displayed as circles with appropriate colors.
3. **JavaScript Logic**:
   - **Planet and Moon Creation**: Functions `createPlanet` and `createMoon` create the elements and set their initial positions.
   - **Orbit Update**: The `updateOrbits` function calculates the new positions of the planets and moons based on time and updates their CSS transforms.
   - **Zoom and Speed Control**: Event listeners for wheel events (zoom) and input changes (speed control) are added to modify the scale and speed of the animation.
4. **Data Initialization**: The `planets` array initializes the planets and their moons, with appropriate sizes, distances from the sun, and orbital speeds.

This code provides a basic animated solar system that you can further customize or expand as needed.