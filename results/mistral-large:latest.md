```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solar System</title>
    <style>
        body {
            background: #000;
            color: #fff;
            font-family: Arial, sans-serif;
            overflow: hidden;
        }

        .container {
            position: relative;
            width: 100vw;
            height: 100vh;
        }

        .planet {
            position: absolute;
            border-radius: 50%;
            transition: transform 0.2s ease;
        }

        .orbit {
            position: absolute;
            border: 1px solid #fff;
            border-radius: 50%;
        }

        .info {
            display: none;
            position: absolute;
            background: rgba(0, 0, 0, 0.8);
            padding: 10px;
            border-radius: 5px;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <div class="container" id="solarSystem">
        <!-- Orbits and planets will be dynamically added here -->
    </div>
    <script>
        const solarSystem = document.getElementById('solarSystem');
        let animationSpeed = 1;
        let paused = false;
        let zoomLevel = 20; // Default zoom level (you can adjust this value)

        const planetsData = [
            { name: 'Mercury', color: '#8c735a', size: 4, distance: 60, orbitSpeed: 1.6, rotationPeriod: 59 },
            { name: 'Venus', color: '#ffe9a2', size: 10, distance: 110, orbitSpeed: 1.38, rotationPeriod: -243 },
            { name: 'Earth', color: '#2d6187', size: 10, distance: 150, orbitSpeed: 1, rotationPeriod: 1 },
            { name: 'Mars', color: '#d95b43', size: 5.3, distance: 220, orbitSpeed: 87.969 / 365, rotationPeriod: 1.026 },
            { name: 'Jupiter', color: '#cbaa95', size: 52, distance: 400, orbitSpeed: 11.86 * 12, rotationPeriod: 0.41 },
            { name: 'Saturn', color: '#d3b57f', size: 45, distance: 600, orbitSpeed: 29.4571 * 12, rotationPeriod: 0.45 },
            { name: 'Uranus', color: '#aedcf9', size: 23, distance: 800, orbitSpeed: 84.0205 * 12, rotationPeriod: -0.718 },
            { name: 'Neptune', color: '#647dbf', size: 22, distance: 950, orbitSpeed: 164.79132 * 12, rotationPeriod: 0.67 }
        ];

        function createOrbit(distance) {
            const orbit = document.createElement('div');
            orbit.className = 'orbit';
            orbit.style.width = `${distance * zoomLevel}px`;
            orbit.style.height = `${distance * zoomLevel}px`;
            solarSystem.appendChild(orbit);
        }

        function createPlanet(planetData) {
            const planet = document.createElement('div');
            planet.className = 'planet';
            planet.style.width = `${planetData.size}px`;
            planet.style.height = `${planetData.size}px`;
            planet.style.backgroundColor = planetData.color;
            planet.style.top = `calc(50% - ${planetData.size / 2}px)`;
            planet.style.left = `calc(${planetData.distance * zoomLevel + solarSystem.offsetWidth / 2 - planetData.size / 2}px)`;
            const info = document.createElement('div');
            info.className = 'info';
            info.innerHTML = `<strong>${planetData.name}</strong><br/>Size: ${planetData.size * 1000} km<br/>Orbit Period: ${planetData.orbitSpeed} years`;
            planet.appendChild(info);

            solarSystem.appendChild(planet);
        }

        planetsData.forEach((planet, index) => {
            createOrbit(planet.distance);
            createPlanet(planet);
        });

        function animate() {
            if (!paused) {
                const centerX = solarSystem.offsetWidth / 2;
                const centerY = solarSystem.offsetHeight / 2;

                planetsData.forEach((planet, index) => {
                    const planetElement = document.querySelectorAll('.planet')[index];
                    let angle = ((Date.now() * animationSpeed) / (365 * 1000)) % 360; // Degrees per year
                    angle *= planet.orbitSpeed;

                    const x = centerX + planet.distance * zoomLevel * Math.cos(angle * Math.PI / 180);
                    const y = centerY - planet.distance * zoomLevel * Math.sin(angle * Math.PI / 180);

                    planetElement.style.transform = `translate(${x}px, ${y}px)`;
                });
            }

            requestAnimationFrame(animate);
        }

        animate();

        document.addEventListener('keydown', (e) => {
            if (e.key === 'ArrowUp') {
                zoomLevel *= 1.05;
            } else if (e.key === 'ArrowDown') {
                zoomLevel /= 1.05;
            } else if (e.key === 'ArrowRight') {
                animationSpeed += 2;
            } else if (e.key === 'ArrowLeft') {
                animationSpeed -= 2;
            } else if (e.key === ' ') {
                paused = !paused;
            }
        });

        solarSystem.addEventListener('mouseover', (e) => {
            const planet = e.target.closest('.planet');
            if (planet) {
                const info = planet.querySelector('.info');
                info.style.display = 'block';
            }
        });

        solarSystem.addEventListener('mouseout', (e) => {
            const planet = e.target.closest('.planet');
            if (planet) {
                const info = planet.querySelector('.info');
                info.style.display = 'none';
            }
        });
    </script>
</body>
</html>
```

This code creates a simple yet functional representation of the Solar System using HTML, CSS, and JavaScript. Each planet orbits around an imaginary center point (the Sun), with their positions updated dynamically in real-time to simulate orbital movement. Users can zoom in/out, speed up/slow down, and pause the animation using keyboard controls. Hovering over a planet displays basic information about it. The script uses simple CSS for styling and JavaScript for functionality, making it easy to understand and modify.