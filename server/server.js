const http = require('http'); // build basic http server
const WebSocket = require('ws'); // for Websocket communication
const express = require('express'); // for web interface
const { ReadlineParser } = require('@serialport/parser-readline'); // to read data from arduino
const path = require('path'); // pulling built-in path function
const app = express();
const server = http.createServer(app); // to set up server
const wss = new WebSocket.Server({ server });
app.use(express.static(path.join(__dirname, 'public'))); // serves static files (user interface)
const net = require('net');

// State of the traffic lights
let trafficLights = {
    light1: { color: "red", timer: 0 },
    light2: { color: "red", timer: 0 }
}


// Broadcast to all connected clients
function broadcast() {
    let msgToSend = JSON.stringify(trafficLights);
    wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(msgToSend);
        }
    });
}


// Handle websocket connections
wss.on("connection", (ws) => {
    console.log("WebSocket client connected");

    ws.send(JSON.stringify(trafficLights));

    /* Message should be in the form of:
    {
        light: "light1",
        color: "red",
        timer: 0
    }
    */
    ws.on("message", (message) => {
        try {
            const data = JSON.parse(message);
            const { light, color, timer } = data;

            // Check if the light is valid
            if (!["light1", "light2"].includes(light)) {
                console.warn("Invalid light: ", light);
                return;
            }

            // Check if color is valid
            if (!["green", "yellow", "red"].includes(color)) {
                console.warn("Invalid color: ", color);
                return;
            }

            // Check if timer is valid
            if (isNaN(Number(timer))) {
                console.warn("Invalid timer amount: ", timer);
                return;
            }

            // Set the data
            let newTimer = Math.ceil(Number(timer));
            trafficLights[light] = { color, newTimer };
            broadcast();

        } catch (err) {
            console.log("Error parsing message: ", err.message);
        }
    });

    ws.on("close", () => {
        console.log("WebSocket client disconnected");
    })
})


// Start the server
server.listen(5000, () => {
    console.log('Server running at port 5000');
}).on('error', (err) => {
    console.error('Error occurred while starting the server:', err);
});