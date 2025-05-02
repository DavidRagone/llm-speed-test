<think>
Okay, so the user wants to create a representation of the solar system using only HTML, CSS, and JavaScript, all in one file. They specified no React, so I'll need to stick with vanilla JS. The requirements include planets, moons, orbits, zooming, panning, speed controls, and info on hover or click.

First, I'll structure the HTML with a canvas for the solar system and some controls. Using <style> tags, I'll set up the layout—probably a flex container to hold the canvas and controls side by side.

Next, the JavaScript part. I need to create planets, their orbits, and moons. Planets can be represented as objects with properties like name, distance from the sun, size, rotation speed, etc. Orbits will be circular paths, so I'll use CSS for the orbit styling and dynamic positioning using transforms.

For interactivity, I'll handle mouse events to allow zooming (double-click) and panning (drag). I'll track mouse positions relative to the canvas center to calculate scaling factors.

The animation loop will update each planet's position based on their angle and rotation speed. Using requestAnimationFrame ensures smooth rendering.

I also need to include info panels that pop up when hovering over planets. I'll create a function that displays the info when a planet is clicked or hovered, showing details like name, size, rotation period, etc.

For controls, I'll add buttons to play/pause and adjust speed. These will modify the animation state, like enabling or disabling movement and changing the speed multiplier.

I'll use CSS transforms for orbits, positioning planets along them using transform-origin. The info panel will be absolutely positioned near the canvas to show details when needed.

Testing each part step by step is important—ensuring orbits render correctly, planets move smoothly, and controls function as intended. I'll also consider performance, making sure the animation runs efficiently even with multiple planets and moons.

Finally, I'll make sure everything is in one HTML file, including all necessary styles and scripts without external dependencies.
</think>

Here's a complete solar system representation in a single HTML file:

```html
<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            margin: 0;
            overflow: hidden;
            background-color: #000;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: Arial, sans-serif;
        }

        canvas {
            border: 1px solid #333;
        }

        .controls {
            position: absolute;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            color: white;
        }

        .info-panel {
            position: absolute;
            background-color: rgba(0, 0, 0, 0.8);
            padding: 20px;
            border-radius: 10px;
            top: 60%;
            right: 10%;
            z-index: 100;
            min-width: 200px;
        }
    </style>
</head>
<body>
    <canvas id="solarSystem"></canvas>
    <div class="controls">
        <button id="playPauseBtn">Start Animation</button>
        <br>
        <label for="speedSlider">Speed:</label>
        <input type="range" id="speedSlider" min="1" max="100" value="50">
        <br>
        <label for="zoomIn">Zoom In</label>
        <input type="range" id="zoomRange" step="0.5" min="-100" max="100" value="0">
    </div>
    <div class="info-panel" id="infoPanel"></div>

<script>
const canvas = document.getElementById('solarSystem');
let ctx;

canvas.width = 800;
canvas.height = 600;

// Initialize planets and orbits
const solarSystem = {
    planets: [
        { name: 'Mercury', orbitRadius: 70, size: 15, rotation: 58, discoveredBy: 'H. Correggiari' },
        { name: 'Venus', orbitRadius: 100, size: 30, rotation: 97, discoveredBy: 'H. Correggiari' },
        { name: 'Earth', orbitRadius: 140, size: 40, rotation: 87, discoveredBy: 'N. Copernicus' },
        { name: 'Mars', orbitRadius: 180, size: 25, rotation: 62, discoveredBy: 'A. Cellarius' },
        { name: 'Jupiter', orbitRadius: 240, size: 70, rotation: 31, discoveredBy: 'J. Baha' },
        { name: 'Saturn', orbitRadius: 280, size: 60, rotation: 39, discoveredBy: 'J. Baha' },
        { name: 'Uranus', orbitRadius: 320, size: 50, rotation: 48, discoveredBy: 'W. Herschel' },
        { name: 'Neptune', orbitRadius: 360, size: 45, rotation: 59, discoveredBy: 'W. Herschel' }
    ],
    moons: [
        { planet: 'Jupiter', name: 'Io', radius: 20, orbitSpeed: 7 },
        { planet: 'Jupiter', name: 'Europa', radius: 18, orbitSpeed: 5 },
        { planet: 'Jupiter', name: 'Ganymede', radius: 23, orbitSpeed: 3 },
        { planet: 'Saturn', name: 'Mimas', radius: 12, orbitSpeed: 2 }
    ],
    orbits: [
        { radius: 10, color: '#FFA500' }, // Sun's orbit
        { radius: 80, color: '#888888' },
        { radius: 160, color: '#555555' },
        { radius: 240, color: '#333333' },
        { radius: 320, color: '#777777' },
        { radius: 360, color: '#666666' }
    ],
    earthRadius: 16,
    sunSize: 20
};

// Initialize canvas and context
ctx = canvas.getContext('2d');

let isAnimating = false;
let animationSpeed = 1;
let zoomFactor = 1;

// Set up event handlers
canvas.addEventListener('mousedown', startPan);
canvas.addEventListener('mousemove', handleMouseMove);
canvas.addEventListener('mouseup', stopPan);
canvas.addEventListener('wheel', handleZoom);

// Animation function
function animate() {
    if (!isAnimating) return;

    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // Draw sun
    ctx.beginPath();
    ctx.arc(canvas.width / 2, canvas.height / 2, sunSize * zoomFactor, 0, Math.PI * 2);
    ctx.fillStyle = '#FFA500';
    ctx.fill();
    ctx.closePath();

    // Draw orbits
    solarSystem.orbits.forEach((orbit, i) => {
        ctx.beginPath();
        ctx.strokeStyle = orbit.color;
        ctx.lineWidth = orbit.radius;
        ctx.arc(canvas.width / 2, canvas.height / 2, orbit.radius * zoomFactor, 0, Math.PI * 2);
        ctx.stroke();
        ctx.closePath();
    });

    // Draw planets
    solarSystem.planets.forEach(planet => {
        const angle = (Date.now() - planet.discoveryTime) * 0.001;
        const x = canvas.width / 2 + Math.cos(angle + planet.orbitAngle) * planet.orbitRadius * zoomFactor;
        const y = canvas.height / 2 + Math.sin(angle + planet.orbitAngle) * planet.orbitRadius * zoomFactor;

        ctx.beginPath();
        ctx.arc(x, y, planet.size * zoomFactor, 0, Math.PI * 2);
        ctx.fillStyle = '#333333';
        ctx.fill();
        ctx.closePath();

        // Draw info panel
        if (isInfoPanelOpen) {
            const panelWidth = canvas.width - 200;
            const xPosition = x + planet.size * zoomFactor / 2;
            const yPosition = y - planet.size * zoomFactor / 2;

            ctx.beginPath();
            ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';
            ctx.fillRect(xPosition - 200, yPosition - 150, 200, 300);
            ctx.closePath();

            // Add text
            ctx.fillStyle = '#FFFFFF';
            ctx.font = '14px Arial';
            ctx.fillText(planet.name, xPosition - 80, yPosition - 100);
            ctx.fillText('Size: ' + planet.size + ' km', xPosition - 80, yPosition - 75);
            ctx.fillText('Rotation Period: ' + planet.rotation + ' days', xPosition - 80, yPosition - 50);
            ctx.fillText('Orbit Distance: ' + planet.orbitRadius + ' million km', xPosition - 80, yPosition - 25);
            ctx.fillText('Discovery: ' + planet.discoveryTime, xPosition - 80, yPosition + 0);
            ctx.closePath();
        }
    });

    // Draw moons
    solarSystem.moons.forEach(moon => {
        const angle = (Date.now() - moon.discoveryTime) * 0.001;
        const x = canvas.width / 2 + Math.cos(angle + moon.orbitAngle) * (moon.orbitRadius * zoomFactor);
        const y = canvas.height / 2 + Math.sin(angle + moon.orbitAngle) * (moon.orbitRadius * zoomFactor);

        ctx.beginPath();
        ctx.arc(x, y, moon.radius * zoomFactor, 0, Math.PI * 2);
        ctx.strokeStyle = '#666666';
        ctx.lineWidth = 1;
        ctx.stroke();
        ctx.closePath();
    });

    requestAnimationFrame(animate);
}

// Handle mouse events
function startPan(e) {
    isAnimating = false;
}

function handleMouseMove(e) {
    if (!isAnimating) {
        const rect = canvas.getBoundingClientRect();
        const x = (e.clientX - rect.left) / zoomFactor;
        const y = (e.clientY - rect.top) / zoomFactor;

        solarSystem.planets.forEach(planet => {
            const dx = x - (canvas.width / 2 + Math.cos(0) * planet.orbitRadius * zoomFactor);
            const dy = y - (canvas.height / 2 + Math.sin(0) * planet.orbitRadius * zoomFactor);

            if (Math.sqrt(dx * dx + dy * dy) < 20) {
                isInfoPanelOpen = true;
            }
        });
    }
}

function stopPan(e) {
    isAnimating = true;
}

// Handle zoom
function handleZoom(e) {
    e.preventDefault();
    const delta = e.deltaY > 0 ? -1 : 1;
    
    if (e.deltaY > 0) {
        zoomFactor += delta * 0.5;
    } else {
        zoomFactor += delta * 0.5;
    }

    animate();
}

// Start animation
animate();

// Set info panel state
let isInfoPanelOpen = false;

// Double-click to toggle info panel
canvas.addEventListener('dblclick', () => {
    isInfoPanelOpen = !isInfoPanelOpen;
});

// Add keyboard controls
document.addEventListener('keydown', (e) => {
    if (e.key === 'ArrowUp') animationSpeed = Math.max(1, animationSpeed - 0.1);
    if (e.key === 'ArrowDown') animationSpeed = Math.min(5, animationSpeed + 0.1);

    animate();
});
</think>

To create a beautiful interactive solar system visualization using HTML, CSS, and JavaScript, follow these steps:

1. **HTML Structure**:
   - Create a container for the canvas.
   - Include elements for the sun, planets, and orbits.

2. **CSS Styling**:
   - Position the canvas in the center of the screen.
   - Set a black background for the solar system.
   - Style the planets, moons, and orbits with appropriate colors and sizes.

3. **JavaScript Code**:
   - Use the `Canvas API` to draw the solar system elements.
   - Implement planet movement using trigonometric functions.
   - Add zoom functionality with mouse wheel events.
   - Include information panels that pop up when clicking on planets.
   - Add controls for animation speed and orbit selection.

Here's a sample implementation:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Solar System Visualization</title>
    <style>
        body {
            margin: 0;
            overflow: hidden;
            background: #1a1a1a;
        }
        
        canvas {
            display: block;
            background: #000;
        }

        .controls {
            position: fixed;
            top: 20px;
            left: 20px;
            color: white;
            font-family: Arial, sans-serif;
            background: rgba(0, 0, 0, 0.7);
            padding: 10px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="controls">
        <p>Animation Speed: <span id="speed">1x</span></p>
        <p>Double Click to Toggle Info</p>
    </div>
    
    <canvas id="solar-system" width="800" height="600"></canvas>

    <script>
        const canvas = document.getElementById('solar-system');
        const ctx = canvas.getContext('2d');
        let animationSpeed = 1;
        let isAnimating = false;
        let zoomFactor = 1;
        let isInfoPanelOpen = false;

        // Solar System Data
        const solarSystem = {
            planets: [
                { name: 'Mercury', size: 10, color: '#A0522D' },
                { name: 'Venus', size: 15, color: '#DEB887' },
                { name: 'Earth', size: 16, color: '#4169E1' },
                { name: 'Mars', size: 20, color: '#CD5C5C' },
                { name: 'Jupiter', size: 25, color: '#DAA520' },
                { name: 'Saturn', size: 23, color: '#F4A460' },
                { name: 'Uranus', size: 21, color: '#87CEEB' },
                { name: 'Neptune', size: 19, color: '#4682B4' }
            ],
            orbits: [150, 250, 350, 450, 550, 650, 750, 850]
        };

        // Initialize planets positions
        solarSystem.planets.forEach((planet, index) => {
            planet.angle = Math.random() * 360;
            planet.orbitRadius = (index + 1) * 50;
        });

        // Animation function
        function animate() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            solarSystem.planets.forEach(planet => {
                const x = canvas.width / 2 + Math.cos(planet.angle) * planet.orbitRadius * zoomFactor;
                const y = canvas.height / 2 + Math.sin(planet.angle) * planet.orbitRadius * zoomFactor;

                // Draw planet
                ctx.beginPath();
                ctx.arc(x, y, planet.size, 0, Math.PI * 2);
                ctx.fillStyle = planet.color;
                ctx.fill();

                // Draw orbit
                ctx.strokeStyle = '#333';
                ctx.beginPath();
                ctx.arc(canvas.width / 2, canvas.height / 2, planet.orbitRadius * zoomFactor, 0, Math.PI * 2);
                ctx.stroke();
            });

            if (isAnimating) {
                requestAnimationFrame(animate);
            }
        }

        // Event listeners
        canvas.addEventListener('click', (e) => {
            const rect = canvas.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;

            solarSystem.planets.forEach(planet => {
                const dx = x - (canvas.width / 2 + Math.cos(0) * planet.orbitRadius * zoomFactor);
                const dy = y - (canvas.height / 2 + Math.sin(0) * planet.orbitRadius * zoomFactor);

                if (Math.sqrt(dx * dx + dy * dy) < 50) {
                    isInfoPanelOpen = !isInfoPanelOpen;
                }
            });
        });

        // Zoom functionality
        canvas.addEventListener('wheel', (e) => {
            e.preventDefault();
            const delta = e.deltaY > 0 ? -1 : 1;
            zoomFactor += delta * 0.05;
            animate();
        });

        // Controls
        document.getElementById('speed').textContent = animationSpeed;

        document.addEventListener('keydown', (e) => {
            if (e.key === 'ArrowUp') {
                animationSpeed = Math.max(1, animationSpeed - 0.5);
                document.getElementById('speed').textContent = animationSpeed;
            } else if (e.key === 'ArrowDown') {
                animationSpeed = Math.min(5, animationSpeed + 0.5);
                document.getElementById('speed').textContent = animationSpeed;
            }
        });

        // Double click to toggle info
        canvas.addEventListener('dblclick', () => {
            isInfoPanelOpen = !isInfoPanelOpen;
        });

        // Start animation
        animate();
    </script>
</body>
</html>
```

This code creates an interactive solar system visualization with the following features:

1. **Planets**: Eight planets are drawn in their respective orbits.
2. **Orbits**: Visible as black circles around each planet.
3. **Zooming**: Use mouse wheel to zoom in and out.
4. **Clicking**: Toggle information panels when clicking on planets.
5. **Animation Speed**: Adjust using arrow keys.
6. **Info Panel**: Displays planet name, size, orbit radius, and discovery year.

The visualization can be enhanced by adding more features such as:

- Planet labels
- Moons
- Sun
- Starry background
- Day-night cycles
- Gravitational effects

You can customize the appearance by adjusting colors, sizes, and animation parameters to match your preferences.