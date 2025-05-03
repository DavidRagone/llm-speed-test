Below is an HTML file with CSS and JavaScript to create a beautiful representation of our solar system:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solar System</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <canvas id="solar-system"></canvas>
    <script src="script.js"></script>
</body>
</html>
```

```css
#solar-system {
    width: 100%;
    height: 100vh;
    position: relative;
}
```

```javascript
let canvas = document.getElementById('solar-system');
let ctx = canvas.getContext('2d');

// Sun properties
let sun = {
    x: canvas.width / 2,
    y: canvas.height / 2,
    radius: 30,
    color: 'yellow',
};

// Planetary bodies data
const planets = [
    { name: "Mercury", size: 24, mass: 3.3022e23, orbitRadius: 57.909e6, orbitalSpeed: 47.4, discoveryYear: 1761, discoverer: "Johannes Kepler" },
    { name: "Venus", size: 30, mass: 4.8675e24, orbitRadius: 108.208e6, orbitalSpeed: 35.0, discoveryYear: 1757, discoverer: "Galileo Galilei" },
    { name: "Earth", size: 36, mass: 5.9723e24, orbitRadius: 149.597e6, orbitalSpeed: 29.78, discoveryYear: 1543, discoverer: "Nicolaus Copernicus" },
    { name: "Mars", size: 42, mass: 6.4171e23, orbitRadius: 227.939e6, orbitalSpeed: 24.07, discoveryYear: 1610, discoverer: "Galileo Galilei" },
    { name: "Jupiter", size: 48, mass: 1.8982e27, orbitRadius: 778.299e6, orbitalSpeed: 13.07, discoveryYear: 1610, discoverer: "Galileo Galilei" },
    { name: "Saturn", size: 54, mass: 5.6846e26, orbitRadius: 1.427e9, orbitalSpeed: 9.45, discoveryYear: 1610, discoverer: "Galileo Galilei" },
    { name: "Uranus", size: 60, mass: 8.6810e25, orbitRadius: 2.870e9, orbitalSpeed: 6.81, discoveryYear: 1781, discoverer: "William Herschel" },
    { name: "Neptune", size: 66, mass: 1.0241e26, orbitRadius: 4.497e9, orbitalSpeed: 5.43, discoveryYear: 1846, discoverer: "John Couch Adams" },
    { name: "Pluto", size: 72, mass: 1.3051e22, orbitRadius: 5.906e9, orbitalSpeed: 4.67, discoveryYear: 1930, discoverer: "Clyde Tombaugh" },
];

// Moons data
const moons = [
    { name: "Mercury", moonName: "None", orbitRadius: 57.909e6, orbitalSpeed: 47.4 },
    { name: "Venus", moonName: "None", orbitRadius: 108.208e6, orbitalSpeed: 35.0 },
    { name: "Earth", moonName: "Moon", orbitRadius: 384e6, orbitalSpeed: 1.022 },
    { name: "Mars", moonName: "Phobos", orbitRadius: 6.52e7, orbitalSpeed: 2.35 },
    { name: "Jupiter", moonsArray: [
            { name: "Io", size: 12, mass: 8.931e22, orbitRadius: 426.68e6, orbitalSpeed: 1.76 },
            { name: "Europa", size: 18, mass: 4.8675e22, orbitRadius: 671.04e6, orbitalSpeed: 2.33 },
            { name: "Ganymede", size: 24, mass: 3.2521e23, orbitRadius: 1.079e9, orbitalSpeed: 2.13 },
            { name: "Callisto", size: 30, mass: 1.8827e23, orbitRadius: 1.883e9, orbitalSpeed: 1.93 },
        ]
    },
    { name: "Saturn", moonsArray: [
            { name: "Titan", size: 36, mass: 5.6834e24, orbitRadius: 1.426e9, orbitalSpeed: 0.65 },
            { name: "Enceladus", size: 42, mass: 3.0938e22, orbitRadius: 238.06e6, orbitalSpeed: 1.17 },
            { name: "Dione", size: 48, mass: 4.2599e22, orbitRadius: 377.74e6, orbitalSpeed: 0.87 },
            { name: "Rhea", size: 54, mass: 2.0007e23, orbitRadius: 527.04e6, orbitalSpeed: 0.77 },
        ]
    },
    { name: "Uranus", moonsArray: [
            { name: "Titania", size: 60, mass: 5.8869e22, orbitRadius: 435.08e6, orbitalSpeed: 0.71 },
            { name: "Oberon", size: 66, mass: 2.5304e23, orbitRadius: 584.32e6, orbitalSpeed: 1.16 },
        ]
    },
];

let zoomLevel = 1;
let speedMultiplier = 1;

function init() {
    // Draw the Sun
    ctx.beginPath();
    ctx.arc(sun.x, sun.y, sun.radius * zoomLevel, 0, Math.PI*2);
    ctx.fillStyle = sun.color;
    ctx.fill();

    // Draw planetary bodies and their moons
    for (let i = 0; i < planets.length; i++) {
        const planet = planets[i];
        ctx.beginPath();
        ctx.arc(planet.x, planet.y, planet.size * zoomLevel, 0, Math.PI*2);
        ctx.fillStyle = 'black';
        ctx.fill();

        if (planet.moonsArray) {
            for (let j = 0; j < planet.moonsArray.length; j++) {
                const moon = planet.moonsArray[j];
                ctx.beginPath();
                ctx.arc(moon.x, moon.y, moon.size * zoomLevel, 0, Math.PI*2);
                ctx.fillStyle = 'grey';
                ctx.fill();

                // Draw the orbit of the planetary body
                ctx.strokeStyle = 'white';
                ctx.lineWidth = 1;
                ctx.beginPath();
                ctx.arc(planet.orbitRadius, planet.x, 20 * zoomLevel, 0, Math.PI*2);
                ctx.stroke();
            }
        }

        // Display information about the planet when hovered over
        const infoText = document.createElement('div');
        infoText.style.position = 'absolute';
        infoText.style.top = `${planet.y + planet.size * zoomLevel + 20}px`;
        infoText.style.left = `${planet.x - 150}px`;
        infoText.style.fontWeight = 'bold';
        infoText.textContent = `${planet.name}\nSize: ${planet.size} km\nMass: ${planet.mass / (1.989e30)} solar masses\nOrbital Speed: ${planet.orbitalSpeed} km/s\nOrbit Radius: ${planet.orbitRadius / (1.496e11)} AU`;
        infoText.style.display = 'none';
        canvas.appendChild(infoText);

        if (i == 0) {
            const mouseOverHandler = () => {
                // Set the display of the planet information text to visible
                infoText.style.display = 'block';
            };
            document.addEventListener('mouseover', mouseOverHandler);
            document.addEventListener('mouseout', () => {
                infoText.style.display = 'none';
            });
        }
    }

    function update() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        // Draw planetary bodies and their moons
        for (let i = 0; i < planets.length; i++) {
            const planet = planets[i];
            if (!planet.moonsArray) {
                const x = planet.x;
                const y = planet.y + Math.sin(Date.now() * speedMultiplier * 0.01) * 100;
                ctx.beginPath();
                ctx.arc(x, y, planet.size * zoomLevel, 0, Math.PI*2);
                ctx.fillStyle = 'black';
                ctx.fill();

                // Draw the orbit of the planetary body
                ctx.strokeStyle = 'white';
                ctx.lineWidth = 1;
                ctx.beginPath();
                ctx.arc(planet.orbitRadius, x, 20 * zoomLevel, 0, Math.PI*2);
                ctx.stroke();
            }
        }

        // Update planet positions
        for (let i = 0; i < planets.length; i++) {
            const planet = planets[i];
            if (planet.moonsArray) {
                for (let j = 0; j < planet.moonsArray.length; j++) {
                    const moon = planet.moonsArray[j];
                    // Draw the orbit of the moon
                    ctx.strokeStyle = 'white';
                    ctx.lineWidth = 1;
                    ctx.beginPath();
                    ctx.arc(moon.orbitRadius, moon.x, 10 * zoomLevel, 0, Math.PI*2);
                    ctx.stroke();

                    // Update the position of the moon
                    const angle = Date.now() * speedMultiplier * 0.01 + moon.angle;
                    const newX = moon.x + Math.cos(angle) * moon.orbitRadius * zoomLevel / (1.496e11);
                    const newY = moon.y + Math.sin(angle) * moon.orbitRadius * zoomLevel / (1.496e11);
                    moon.x = newX;
                    moon.y = newY;
                    moon.angle += 0.01;

                    // Check for collision with the Sun
                    if (Math.sqrt((newX - sun.x)**2 + (newY - sun.y)**2) < planet.size * zoomLevel) {
                        alert('Moon collision detected!');
                    }
                }
            }

            // Update the position of the planetary body
            const angle = Date.now() * speedMultiplier * 0.01 + planet.angle;
            const newX = planet.x + Math.cos(angle) * planet.orbitRadius * zoomLevel / (1.496e11);
            const newY = planet.y + Math.sin(angle) * planet.orbitRadius * zoomLevel / (1.496e11);
            planet.x = newX;
            planet.y = newY;
            planet.angle += 0.01;

            // Check for collision with the Sun
            if (Math.sqrt((newX - sun.x)**2 + (newY - sun.y)**2) < planet.size * zoomLevel) {
                alert('Planet collision detected!');
            }
        }

        requestAnimationFrame(update);
    }

    update();
}

init();

// Zoom in/out and speed control
document.addEventListener('keydown', event => {
    if (event.key == 'ArrowUp') {
        // Increase the zoom level
        zoomLevel++;
    } else if (event.key == 'ArrowDown') {
        // Decrease the zoom level
        zoomLevel--;
    } else if (event.key == '+') {
        // Increase the speed multiplier
        speedMultiplier += 0.1;
    } else if (event.key == '-') {
        // Decrease the speed multiplier
        speedMultiplier -= 0.1;
    }
});

document.addEventListener('keyup', event => {
    if (event.key == 'ArrowUp' || event.key == 'ArrowDown') {
        zoomLevel = Math.max(1, Math.min(zoomLevel, 10));
    } else if (event.key == '+' || event.key == '-') {
        speedMultiplier = Math.max(0.1, Math.min(speedMultiplier, 5));
    }
});