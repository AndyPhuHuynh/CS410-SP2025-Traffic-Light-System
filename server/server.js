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
let currentstate = { state: "red", seconds: 0 };// Traffic light stays red in default
app.use(express.static(path.join(__dirname, 'public'))); // serves static files (user interface)


// Connect to the board (test needed)
const port = new SerialPort({
  path: 'COM3', // change to COM3 if using Windows
  baudRate: 9600
});

function broadcast(state) {
  const data = typeof state === 'string' ? state : JSON.stringify(state);
  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(data);
    }
  });
}

const parser = port.pipe(new ReadlineParser({ delimiter: '\n' }));

// Open Websocket
wss.on('connection', (socket) => {
    console.log('Websocket connected');
    socket.send(JSON.stringify(currentstate));

    socket.on('message', (message) => {
        console.log('Received from client:', message.toString());

        try {
            const data = JSON.parse(message.toString());
            if (data.light1 && data.light2 && typeof data.countdown === 'number') {
            currentstate = data;
            broadcast(currentstate); // Broadcast to others
            }
        } catch (e) {
            console.error('Invalid JSON received:', e.message);
        }
    });

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
    broadcast(JSON.stringify(currentstate));
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

// Turn off the broadcast in case of connection error

server.listen(3000, () => {
    console.log('Server Running at port 3000') // 3000 is for web apps
});

















