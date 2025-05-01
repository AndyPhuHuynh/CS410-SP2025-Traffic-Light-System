const http = require('http'); // build basic http server
const WebSocket = require('ws'); // for Websocket communication
const express = require('express'); // for web interface
const path = require('path'); // pulling built-in path function
const os = require('os');
const app = express();
const server = http.createServer(app); // to set up server
const wss = new WebSocket.Server({ server });
app.use(express.static(path.join(__dirname, 'public'))); // serves static files (user interface)


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
        light1: { color: "red", timer: 0 },
        light2: { color: "red", timer: 0 }
    }
    */

    ws.on("message", (message) => {
        try {
            const data = JSON.parse(message);
            
            let errMsg = "";

            if (data.light1 && data.light2) {
                const { color: color1, timer: timer1 } = data.light1;
                const { color: color2, timer: timer2 } = data.light2;

                // Validate colors
                let validColors = ["green", "yellow", "red"];
                if (!validColors.includes(color1)) {
                    errMsg += `Invalid color for light 1: ${color1}\n`;
                }
                if (!validColors.includes(color2)) {
                    errMsg += `Invalid color for light 2: ${color2}\n`;
                }

                // Validate timers
                if (isNaN(Number(timer1))) {
                    errMsg += `Invalid timer for light 1: ${timer1}\n`;
                }

                if (isNaN(Number(timer2))) {
                    errMsg += `Invalid timer for light 2: ${timer2}\n`;
                }

                // If no error
                if (errMsg == "") {
                    // Set the data
                    let newTimer1 = Math.ceil(Number(timer1));
                    let newTimer2 = Math.ceil(Number(timer2));

                    let newState = {};

                    newState["light1"] = { color: color1, timer: newTimer1 };
                    newState["light2"] = { color: color2, timer: newTimer2 };

                    if (JSON.stringify(newState) != JSON.stringify(trafficLights)) {
                        trafficLights = newState;
                        broadcast();
                    }
                } else {
                    console.warn(errMsg);
                }

            } else {
                console.log("Invalid traffic light structure: ", data);
            }
        } catch (err) {
            console.log("Error parsing message: ", err.message);
        }
    });
    
    ws.on("close", () => {
        console.log("WebSocket client disconnected");
    })
})


function getLocalIP() {
    const interfaces = os.networkInterfaces();
    for (const interface of Object.values(interfaces)) {
        for (const config of interface) {
            if (config.family === 'IPv4' && !config.internal) {
                return config.address;
            }
        }
    }
    return 'localhost';
}

const myIP = getLocalIP();
const port = 5000;

// Start the server
server.listen(port, "0.0.0.0", () => {
    console.log(`Server running at ws://${myIP}:${port}`)
}).on('error', (err) => {
    console.error('Error occurred while starting the server:', err);
});