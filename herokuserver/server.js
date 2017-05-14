//  File: server.js
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Frank Su
//  Creation Date: Nov 21, 2016
//
//  Changelog:
//      V0.1: Connects to mlab and heroku
//      V0.2: Fixed MONGODB_URI throw(err) by inputing 'string' in mongodb.MongoClient.connect
//      V0.3: Added socket.io functionality
//
//  Last Modified Author: Frank Su
//  Last Modified Date: Dec 4, 2016
//
//  Copyright © 2016 CMPT275-3. All rights reserved.
//  Reference: https://www.sitepoint.com/deploy-rest-api-in-30-mins-mlab-heroku/
var express = require("express");
var path = require("path");
var bodyParser = require("body-parser");
var mongodb = require("mongodb");
var ObjectID = mongodb.ObjectID;

// socket.io variables
var userList = [];
var typingUsers = {};

// in database there are 2 lists: contacts, reportabuse
var CONTACTS_COLLECTION = "contacts";
var REPORTABUSE_COLLECTION = "reportabuse";

var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);

app.use(express.static(__dirname + "/public"));
app.use(bodyParser.json());

// Create a database variable outside of the database connection callback to reuse the connection pool in your app.
var db;
// Create server variable outside database connection so socket.io can access it
var server;
/*
 * Use process.env.MONGODB_URI instead of the string if it breaks again
 * This is just a hack, since the password and user name is displayed in the code
 * Connect to the database before starting the application server.
 */
mongodb.MongoClient.connect("mongodb://g3g:group3genius@ds159497.mlab.com:59497/sfu_coffee_buddies", function (err, database) {
  if (err) {
    console.log(err);
    process.exit(1);
  }

  // Save database object from the callback for reuse.
  db = database;
  console.log("Database connection ready");

  // Initialize the app.
  // don't use this for now, cuz it messes with socket.io
  /*
  var server = app.listen(process.env.PORT || 8080, function () {
    var port = server.address().port;
    console.log("App now running on port", port);
    console.log("process.env.PORT", listen(server));

  });*/
});

// listen to server without creating a http server myself
// http://stackoverflow.com/questions/17696801/express-js-app-listen-vs-server-listen

http.listen(process.env.PORT || 3000, function(){
  console.log('Listening on *:3000');
});

// CONTACTS API ROUTES BELOW

// Generic error handler used by all endpoints.
function handleError(res, reason, message, code) {
  console.log("ERROR: " + reason);
  res.status(code || 500).json({"error": message});
}

/*  "/contacts"
 *    GET: finds all contacts
 *    POST: creates a new contact
 */

app.get("/contacts", function(req, res) {
  db.collection(CONTACTS_COLLECTION).find({}).toArray(function(err, docs) {
    if (err) {
      handleError(res, err.message, "Failed to get contacts.");
    } else {
      res.status(200).json(docs);
    }
  });
});

app.post("/contacts", function(req, res) {
  var newContact = req.body;
  newContact.createDate = new Date();

  if (!(req.body.email || req.body.pw)) {
    handleError(res, "Invalid user input (email or pw missing)", "Must provide a email or pw.", 400);
  }

  db.collection(CONTACTS_COLLECTION).insertOne(newContact, function(err, doc) {
    if (err) {
      handleError(res, err.message, "Failed to create new contact.");
    } else {
      res.status(201).json(doc.ops[0]);
    }
  });
});

/*  "/contacts/:id"
 *    GET: find contact by id
 *    PUT: update contact by id
 *    DELETE: deletes contact by id
 */

app.get("/contacts/:id", function(req, res) {
  db.collection(CONTACTS_COLLECTION).findOne({ _id: new ObjectID(req.params.id) }, function(err, doc) {
    if (err) {
      handleError(res, err.message, "Failed to get contact");
    } else {
      res.status(200).json(doc);
    }
  });
});

app.put("/contacts/:id", function(req, res) {
  var updateDoc = req.body;
  delete updateDoc._id;

  db.collection(CONTACTS_COLLECTION).updateOne({_id: new ObjectID(req.params.id)}, updateDoc, function(err, doc) {
    if (err) {
      handleError(res, err.message, "Failed to update contact");
    } else {
      res.status(204).end();
    }
  });
});

app.delete("/contacts/:id", function(req, res) {
  db.collection(CONTACTS_COLLECTION).deleteOne({_id: new ObjectID(req.params.id)}, function(err, result) {
    if (err) {
      handleError(res, err.message, "Failed to delete contact");
    } else {
      res.status(204).end();
    }
  });
});

//REPORT / ABUSE
  //POST: creats new report abuse
  //GET: gets the reports from database
app.post("/reportabuse", function(req, res) {
  var newReport = req.body;
  newReport.createDate = new Date();

  if (!(req.body.message)) {
    handleError(res, "Invalid report/abuse ", "Must provide a reason", 400);
  }

  db.collection(REPORTABUSE_COLLECTION).insertOne(newReport, function(err, doc) {
    if (err) {
      handleError(res, err.message, "Failed to create report/abuse.");
    } else {
      res.status(201).json(doc.ops[0]);
    }
  });
});

app.get("/reportabuse", function(req, res) {
  db.collection(REPORTABUSE_COLLECTION).find({}).toArray(function(err, docs) {
    if (err) {
      handleError(res, err.message, "Failed to get reports/abuse");
    } else {
      res.status(200).json(docs);
    }
  });
});

// Socket.io portion of server code
// io.emit('chat message') sends info to 'chat message'
// io.on('chat message') recieves data from 'chat message'

io.on('connection', function(clientSocket){
  console.log('a user connected');

  clientSocket.on('disconnect', function(){
    console.log('user disconnected');

    var clientNickname;
    for (var i=0; i<userList.length; i++) {
      if (userList[i]["id"] == clientSocket.id) {
        userList[i]["isConnected"] = false;
        clientNickname = userList[i]["nickname"];
        break;
      }
    }

    delete typingUsers[clientNickname];
    io.emit("userList", userList);
    io.emit("userExitUpdate", clientNickname);
    io.emit("userTypingUpdate", typingUsers);
  });


  clientSocket.on("exitUser", function(clientNickname){
    for (var i=0; i<userList.length; i++) {
      if (userList[i]["id"] == clientSocket.id) {
        userList.splice(i, 1);
        break;
      }
    }
    io.emit("userExitUpdate", clientNickname);
  });


  clientSocket.on('chatMessage', function(clientNickname, message){
    var currentDateTime = new Date().toLocaleString();
    delete typingUsers[clientNickname];
    io.emit("userTypingUpdate", typingUsers);
    io.emit('newChatMessage', clientNickname, message, currentDateTime);
  });


  clientSocket.on("connectUser", function(clientNickname) {
      var message = "User " + clientNickname + " was connected.";
      console.log(message);

      var userInfo = {};
      var foundUser = false;
      for (var i=0; i<userList.length; i++) {
        if (userList[i]["nickname"] == clientNickname) {
          userList[i]["isConnected"] = true
          userList[i]["id"] = clientSocket.id;
          userInfo = userList[i];
          foundUser = true;
          break;
        }
      }

      if (!foundUser) {
        userInfo["id"] = clientSocket.id;
        userInfo["nickname"] = clientNickname;
        userInfo["isConnected"] = true
        userList.push(userInfo);
      }

      io.emit("userList", userList);
      io.emit("userConnectUpdate", userInfo)
  });


  clientSocket.on("startType", function(clientNickname){
    console.log("User " + clientNickname + " is writing a message...");
    typingUsers[clientNickname] = 1;
    io.emit("userTypingUpdate", typingUsers);
  });


  clientSocket.on("stopType", function(clientNickname){
    console.log("User " + clientNickname + " has stopped writing a message...");
    delete typingUsers[clientNickname];
    io.emit("userTypingUpdate", typingUsers);
  });

});
