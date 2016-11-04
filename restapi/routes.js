// Using Express, going to put our routes in their own file
var express = require('express');

// Get the router
var router = express.Router();
var Message = require('./models/message');

// Middleware for all this routers requests
router.use(function timelog(req,res,next) {
  console.log("Request Received: ", dateDisplay(Date.now()));
  // next(): need it so processing continues to other routes, otherwise nothing else would happen
  next();
});

// Welcome message for a GET at http://localhost:8080/restapi
router.get('/', function(req,res) {
  res.json({message: 'Welcome to the REST API'});
});

// GET all messages (using a GET at http://localhost:8080/messages)
router.route('/messages')
  .get(function(req, res) {
    Message.find(function(err, messages) {
      if (err)
        res.send(err)
      res.json(messages);
    });
});

// Create a message (using POST at http://localhost:8080/messages)
router.route('/messages')
  .post(function(req,res) {
    var message = new Message();
    // Set text and user values from the request
  message.text = req.body.text;
  message.user = req.body.user;

    // save message and check for errors
    message.save(function(err) {
      if (err)
        res.send(err);
      res.json({message: 'Message created successfully!'});
    });
  });

// GET message with id (using a GET at http://localhost:8080/messages/:message_id)
router.route('/messages/:message_id')
  .get(function(req,res) {
    Message.findById(req.params.message_id, function(err,message) {
      if (err)
        res.send(err);
      res.json(message);
    });
  })

// update message with id (using a PUT at http://localhost:8080/messages/:message_id)
  .put(function(req,res) {
    Message.findById(req.params.message_id, function(err,message) {
      if(err)
        res.send(err);
    message.text = req.body.text;
      message.save(function(err) {
        if (err)
          res.send(err);
        res.json({ message: 'Message successfully updated !'});
      });
    });
  })

// DELETE message with id ( using a DELETE at http://localhost:8080/messsages/:message_id)
  .delete(function(req,res) {
    Message.remove({
      _id: req.params.message_id
    }, function (err, message) {
        if (err)
            res.send(err);

        res.json({ message: 'Successfully deleted message!'});
    });
  });

module.exports = router;

function dateDisplay(timestamp) {
  var date = new Date(timestamp);
  return(date.getMonth() + 1 + '/' + date.getDate() + '/' + date.getFullYear() + " " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds());
}
