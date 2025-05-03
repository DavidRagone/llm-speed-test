Creating a detailed representation of the solar system with interactive features using only HTML, CSS, and JavaScript in a single file can be quite complex. Below is a simplified version that includes the main planets and basic interactivity. This example will cover:

- Planets moving in their orbits.
- Zooming in and out.
- Speed control and pause functionality.
- Displaying information on hover or click.

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
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: black;
            color: white;
            font-family: Arial, sans-serif;
        }
        #solar-system {
            position: relative;
            width: 600px;
            height: 600px;
        }
        .orbit {
            position: absolute;
            border-radius: 50%;
            border: 1px dashed white;
        }
        .planet, .moon {
            position: absolute;
            background-color: #fff;
            border-radius: 50%;
            cursor: pointer;
        }
        #info-box {
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 10px;
            background-color: rgba(0, 0, 0, 0.8);
            color: white;
            border-radius: 5px;
            display: none;
        }
        #controls {
            position: fixed;
            top: 20px;
            left: 20px;
            padding: 10px;
            background-color: rgba(0, 0, 0, 0.8);
            color: white;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div id="controls">
        Zoom: <input type="range" id="zoom" min="0.1" max="2" step="0.1" value="1">
        Speed: <input type="range" id="speed" min="0.1" max="5" step="0.1" value="1">
        <button id="pause">Pause</button>
    </div>
    <div id="solar-system"></div>
    <div id="info-box"></div>

    <script>
        const solarSystem = document.getElementById('solar-system');
        const infoBox = document.getElementById('info-box');
        const zoomControl = document.getElementById('zoom');
        const speedControl = document.getElementById('speed');
        const pauseButton = document.getElementById('pause');

        let paused = false;
        let scale = 1;
        let speedFactor = 1;

        const planetsData = [
            { name: 'Mercury', radius: 3, orbitRadius: 70, rotation: 58.646, orbitalPeriod: 88, discoveredBy: 'Ancient astronomers' },
            { name: 'Venus', radius: 9, orbitRadius: 120, rotation: -243, orbitalPeriod: 225, discoveredBy: 'Ancient astronomers' },
            { name: 'Earth', radius: 10, orbitRadius: 180, rotation: 1, orbitalPeriod: 365.25, discoveredBy: 'Ancient astronomers' },
            { name: 'Mars', radius: 7, orbitRadius: 240, rotation: 1.026, orbitalPeriod: 687, discoveredBy: 'Ancient astronomers' },
            { name: 'Jupiter', radius: 30, orbitRadius: 320, rotation: 0.414, orbitalPeriod: 4331, discoveredBy: 'Galileo Galilei' },
            { name: 'Saturn', radius: 27, orbitRadius: 400, rotation: 0.445, orbitalPeriod: 10760, discoveredBy: 'Galileo Galilei' },
            { name: 'Uranus', radius: 23, orbitRadius: 480, rotation: -0.718, orbitalPeriod: 30685, discoveredBy: 'William Herschel' },
            { name: 'Neptune', radius: 22, orbitRadius: 560, rotation: 0.671, orbitalPeriod: 60190, discoveredBy: 'John Couch Adams & Urbain Le Verrier' }
        ];

        const createPlanet = (planet) => {
            const planetDiv = document.createElement('div');
            planetDiv.className = 'planet';
            planetDiv.style.width = `${planet.radius * 2}px`;
            planetDiv.style.height = `${planet.radius * 2}px`;
            planetDiv.style.background = `url(${`https://via.placeholder.com/${planet.radius * 2}x${planet.radius * 2}`}) no-repeat center/cover`;

            const orbit = document.createElement('div');
            orbit.className = 'orbit';
            orbit.style.width = `${planet.orbitRadius * 2}px`;
            orbit.style.height = `${planet.orbitRadius * 2}px`;
            orbit.style.transformOrigin = `center ${-planet.orbitRadius + solarSystem.offsetWidth / 2}px`;

            planetDiv.addEventListener('click', () => showInfo(planet));
            planetDiv.addEventListener('mouseover', () => showInfo(planet));
            planetDiv.addEventListener('mouseout', () => hideInfo());

            orbit.appendChild(planetDiv);
            solarSystem.appendChild(orbit);

            return { planetDiv, orbit };
        };

        const planets = planetsData.map(createPlanet);

        let angles = new Array(planets.length).fill(0);

        function animate() {
            if (!paused) {
                planets.forEach((planet, index) => {
                    angles[index] += (speedFactor / planet.data.orbitalPeriod);
                    planet.planetDiv.style.transform = `rotate(${angles[index] * 360}deg) translateX(${planet.data.orbitRadius * scale}px)`;
                });
            }
            requestAnimationFrame(animate);
        }

        animate();

        const showInfo = (planetData) => {
            infoBox.innerHTML = `
                <strong>${planetData.name}</strong><br>
                Radius: ${planetData.radius} km<br>
                Orbit Radius: ${planetData.orbitRadius} million km<br>
                Rotation Period: ${planetData.rotation} Earth days<br>
                Orbital Period: ${planetData.orbitalPeriod} Earth days<br>
                Discovered By: ${planetData.discoveredBy}
            `;
            infoBox.style.display = 'block';
        };

        const hideInfo = () => {
            infoBox.style.display = 'none';
        };

        zoomControl.addEventListener('input', (e) => {
            scale = parseFloat(e.target.value);
            solarSystem.style.transform = `scale(${scale})`;
        });

        speedControl.addEventListener('input', (e) => {
            speedFactor = parseFloat(e.target.value);
        });

        pauseButton.addEventListener('click', () => {
            paused = !paused;
            pauseButton.textContent = paused ? 'Resume' : 'Pause';
        });
    </script>
</body>
</html>
```

### Explanation:
1. **HTML Structure**: The HTML includes a `div` for the solar system, controls for zooming and controlling speed, and an info box to display details about planetary bodies.

2. **CSS Styling**: Basic styling is applied to center the solar system on the page, style the orbits, planets, and control elements.

3. **JavaScript**:
   - **Planets Data**: An array holds data about each planet, including its name, radius, orbit radius, rotation period, orbital period, and discovery details.
   - **Planet Creation**: A function `createPlanet` creates DOM elements for each planet and attaches event listeners to show information on hover or click.
   - **Animation**: The `animate` function updates the position of planets in their orbits using CSS transforms. The animation continues with `requestAnimationFrame`.
   - **Controls**: Event listeners handle zooming, speed control, and pausing/resuming the animation.

This example is a simplified version and can be expanded with more detailed planet data, additional moons, and improved aesthetics.