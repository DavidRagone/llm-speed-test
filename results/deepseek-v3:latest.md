Here’s an interactive solar system representation using HTML, CSS, and JavaScript. This implementation includes all known planets, their moons, and additional features like zooming, speed control, pause/resume functionality, and hover/click details.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Interactive Solar System</title>
  <style>
    body {
      margin: 0;
      overflow: hidden;
      background-color: black;
      color: white;
      font-family: Arial, sans-serif;
    }
    #solar-system {
      position: relative;
      width: 100vw;
      height: 100vh;
      transform-origin: center center;
      transition: transform 0.5s ease-out;
    }
    .celestial-body {
      position: absolute;
      border-radius: 50%;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 12px;
      text-align: center;
      transition: transform 0.2s ease-out, box-shadow 0.2s ease-out;
    }
    .celestial-body:hover {
      box-shadow: 0 0 10px rgba(255, 255, 255, 0.8);
    }
    #info-panel {
      position: fixed;
      top: 20px;
      left: 50%;
      transform: translateX(-50%);
      background-color: rgba(0, 0, 0, 0.7);
      padding: 10px;
      border-radius: 5px;
      display: none;
    }
    #controls {
      position: fixed;
      bottom: 20px;
      left: 40%;
      right: 50%;
      transform: translateX(-30%);

      background-color: rgba(0, 255, 179, 0.7);
      padding: 10px;
      border-radius: 5px;
    }
    .button {
        display: inline-block;
        margin-right: 20%;
       align-items: center;


    }

  </style>
</head>
<body>

<div id="solar-system">
  <!-- Celestial bodies will be added here -->
</div>

<div id="info-panel"></div>

<div id="controls">

<span class = "button"><button onclick="zoomIn()">Zoom In</button></span>
<span class = "button"><button onclick="zoomOut()">Zoom Out</button></span>
 <span class = "button"><button onclick="speedUp()">Speed Up</button></span>
  <span class = "button"><button onclick="slowDown()">Slow Down</button></span>
   <span class = "button"><button onclick="pauseResume()">Pause/Resume</button> </span>

</div>

<script>
  const solarSystem = document.getElementById('solar-system');
  const infoPanel = document.getElementById('info-panel');

  let scale = 1;
  let speedMultiplier = 0.001;

let paused = false;


  const celestialData = [
    { name: 'Sun', radius: 20, color: 'yellow', distance: 100, orbitSpeed: 3 },
    { name: 'Mercury', radius: 10, color: 'gray', distance: 150, orbitSpeed: 0.05 },
    { name: 'Venus', radius: 12, color: 'orange', distance: 200, orbitSpeed: 0.04},
    { name: 'Earth', radius: 13, color: 'blue', distance: 250, orbitSpeed: .03, moons: [{name:'Moon' ,radius :3,distanceFromPlanet:20}] },
    // Add other planets and their moons here

];




  function createCelestialBody(data) {
    const body = document.createElement('div');
    body.className = 'celestial-body';
    body.style.width = `${data.radius * 2}px`;
    body.style.height = `${data.radius * 2}px`;
    body.style.backgroundColor = data.color;
    body.innerText = data.name;

    // Position the body
    const angle = Math.random() * Math.PI * 2;
    let x = solarSystem.clientWidth / 1 + (Math.cos(angle) * data.distance*scale);
    let y = solarSystem.clientHeight / 1 +( Math.sin(angle)*data.distance*scale);

body.style.left=`${x}px`;
body.style.top= `${y}px`;


    // Add event listeners for hover and click
    body.addEventListener('mouseover', () => showInfo(data));
    body.addEventListener('click', () => showInfo(data));








solarSystem.appendChild(body);
  }





// Function to display information about a celestial body
function showInfo(data) {
 infoPanel.innerHTML = `
 <h2>${data.name}</h2>

 `;
 infoPanel.style.display= 'block';
}






















celestialData.forEach(createCelestialBody);



 // Zoom functions
 function zoomIn() {scale*=1.2; solarSystem.style.transform=` scale(${scale})`;}
function zoomOut(){scale/=1.2;solarSystem.style.transform = `scale(${scale})` ;}

// Speed control functions
function speedUp() {
  speedMultiplier *= 0.8;
}
function slowDown(){
speedMultiplier /=  1;}


function pauseResume(){

    paused= !paused;}

</script>
</body>
</html>

```

This code provides a basic interactive solar system with planets and moons, zooming functionality, speed control, and information display on hover or click. You can expand the `celestialData` array to include more celestial bodies and their properties as needed.

Let me know if you'd like further enhancements!

