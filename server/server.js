const http = require('http'); // build basic http server
const WebSocket = require('ws'); // for Websocket communication
const express = require('express'); // for web interface
const { SerialPort } = require('serialport'); // Bridging the Arduino to server
const { ReadlineParser } = require('@serialport/parser-readline'); // to read data from arduino
// const readline = require('@serialport/parser-readline');
const path = require('path'); // pulling built-in path function
const app = express();
const server = http.createServer(app); // to set up server
const wss = new WebSocket.Server({ server });
let currentstate = { state: "red", seconds: 0 };// Traffic light stays red in default
app.use(express.static(path.join(__dirname, 'public'))); // serves static files (user interface)


// Broadcast to all connected clients
function broadcast(state) {
    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(state);
      }
    });
  }

// Connect to the board (test needed)
const port = new SerialPort({
  path: 'COM3', // change to COM3 if using Windows
  baudRate: 9600
});

const parser = port.pipe(new ReadlineParser({ delimiter: '\n' }));

// Open Websocket
wss.on('connection', (socket) => {
    console.log('Websocket connected');
    socket.send(JSON.stringify(currentstate));

    socket.on('close', () => {
        console.log('WebSocket connection closed');
    });
});

// Received currentstate from Arduino and broadcast to all clients (test needed)
parser.on('data', (line) => {

    if (!line.includes(':')) return; // skip invalid

    const [state, secondsStr] = line.trim().toLowerCase().split(':');
    const seconds = parseInt(secondsStr, 10);

    if (["red", "yellow", "green"].includes(state)) {
      currentstate = {state, seconds};  
      broadcast(JSON.stringify(latestState));
      console.log(`Arduino: ${state} (${seconds}s)`);
    } else {
      console.warn("error:", state); 
      currentstate = { state: "red", seconds: 0 };
      broadcast(JSON.stringify(currentstate));
    }
  });

// Turn off the broadcast in case of connection error
port.on('error', (err) => {
  console.error("Serial port error:", err.message);
  currentstate = "offline";
  broadcast("offline");
});

// if connection is successful
port.on('open', () => {
    console.log('Serial port opened successfully.');
});

server.listen(3000, () => {
    console.log('Server Running at port 3000') // 3000 is for web apps
});

















