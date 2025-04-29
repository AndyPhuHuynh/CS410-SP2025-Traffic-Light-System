const http = require('http'); // build basic http server
const WebSocket = require('ws'); // for Websocket communication
const express = require('express'); // for web interface
const { SerialPort } = require('serialport'); // Bridging the Arduino to server
const { ReadlineParser } = require('@serialport/parser-readline'); // to read data from arduino
const readline = require('@serialport/parser-readline');
const path = require('path'); // pulling built-in path function
const app = express();
const server = http.createServer(app); // to set up server
const wss = new WebSocket.Server({ server });
let read = { state: "red", seconds: 0 };// Traffic light stays red in default
app.use(express.static(path.join(__dirname, 'public'))); // serves static files (user interface)
const net = require('net');

// Broadcast to all connected clients
function broadcast(state) {
    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(state);
      }
    });
  }

// WIFI Connection to the Board
const port = net.createConnection({ host: '172.20.10.8', port: 5000 }, () => {
    console.log('Connected to Arduino');
  });
    port.on('data', (data) => {
      console.log('Received:', data.toString());
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

server.listen(5000, '0.0.0.0', () => {
  console.log('Server running at http://0.0.0.0:5000');
}).on('error', (err) => {
  console.error('Error occurred while starting the server:', err);
});
