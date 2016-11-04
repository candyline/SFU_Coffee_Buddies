// Create an Http server by loading http module
var http = require('http');
var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var routes = require('./routes');

var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/restdb')

// express app will use body-parser to get data from POST
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

// Set port
var port = process.env.PORT || 8080; //set the port

// Define a prefix for all routes
// Can define something unique like MyRestApi
// We'll just leave it so all routes are relative to '/'
app.use('/',routes);

// Start server listening on port 8080
app.listen(port);
console.log('RESTAPI listening on port' + port);

// Configure the HTTP server to respond identically to any request
var server = http.createServer(function(request,response) {
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.end("Hello from your HTTP server \n");
});

// Listens to port 3000, IP defaults on 127.0.0.1
server.listen(3000);

// Put a friendly message on the terminal
console.log("HTTP server running @ http://127.0.0.1:3000/");
