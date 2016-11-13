// Using Express, going to put our routes in their own file
var express = require('express');

// Get the router
var router = express.Router();
var Message = require('./models/message');
var ReportAbuse = require('./models/reportAbuse');

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
  message.interest = req.body.interest;
  message.bio = req.body.bio;
  message.bus = req.body.bus;
  message.email = req.body.email;
  message.username = req.body.username
  message.pw = req.body.pw;
  message.gender = req.body.gender;
  message.meeting = req.body.meeting;
  message.major = req.body.major;

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
      message.interest = req.body.interest;
      message.bio = req.body.bio;
      message.bus = req.body.bus;
      message.email = req.body.email;
      message.username = req.body.username
      message.pw = req.body.pw;
      message.gender = req.body.gender;
      message.meeting = req.body.meeting;
      message.major = req.body.major;

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


//Report Abuse Begin

//GET all messages stored in database (http://localhost:8080/reportAbuse)
//Author: Eton Kan
//Created: Nov 11,2016
//Last Modified Author: Eton Kan
//Last Modified Date: Nov 11, 2016
router.route('/reportAbuse')
  .get(function(req, res) {
    ReportAbuse.find(function(err, reportAbuse) {
      if (err)
        res.send(err)
      res.json(reportAbuse);
    });
});

// Create a message (using POST at http://localhost:8080/reportAbuse)
//Author: Eton Kan
//Created: Nov 11,2016
//Last Modified Author: Eton Kan
//Last Modified Date: Nov 11, 2016
router.route('/reportAbuse')
  .post(function(req,res) {
    var reportAbuse = new ReportAbuse();
    // Set text and user values from the request
  reportAbuse.interest = req.body.interest;
  reportAbuse.bio = req.body.bio;
  //message.bus = req.body.bus;
  reportAbuse.email = req.body.email;
  reportAbuse.username = req.body.username
  //message.pw = req.body.pw;
  //message.gender = req.body.gender;
  //message.meeting = req.body.meeting;
  //message.major = req.body.major;

    // save message and check for errors
    reportAbuse.save(function(err) {
      if (err)
        res.send(err);
      res.json({message: 'Message (reportAbuse) created successfully!'});
    });
  });

// GET message with id (using a GET at http://localhost:8080/reportAbuse/:message_id)
//Author: Eton Kan
//Created: Nov 11,2016
//Last Modified Author: Eton Kan
//Last Modified Date: Nov 11, 2016
router.route('/reportAbuse/:message_id')
  .get(function(req,res) {
    ReportAbuse.findById(req.params.message_id, function(err, reportAbuse) {
      if (err)
        res.send(err);
      res.json(reportAbuse);
    });
  })

//Update message with id using .PUT (http://localhost:8080/reportAbuse/:message_id)
//Author: Eton Kan
//Created: Nov 11,2016
//Last Modified Author: Eton Kan
//Last Modified Date: Nov 11, 2016
  .put(function(req,res) {
    ReportAbuse.findById(req.params.message_id, function(err, reportAbuse) {
      if(err)
        res.send(err);
      reportAbuse.interest = req.body.interest;
      reportAbuse.bio = req.body.bio;
      //message.bus = req.body.bus;
      reportAbuse.email = req.body.email;
      reportAbuse.username = req.body.username
      //message.pw = req.body.pw;
      //message.gender = req.body.gender;
      //message.meeting = req.body.meeting;
      //message.major = req.body.major;

      reportAbuse.save(function(err) {
        if (err)
          res.send(err);
        res.json({ message: 'Message reportAbuse successfully updated !'});
      });
    });
  })

// DELETE message with id ( using a DELETE at http://localhost:8080/reportAbuse/:message_id)
//Author: Eton Kan
//Created: Nov 11,2016
//Last Modified Author: Eton Kan
//Last Modified Date: Nov 11, 2016
  .delete(function(req,res) {
    ReportAbuse.remove({
      _id: req.params.message_id
    }, function (err, reportAbuse) {
        if (err)
            res.send(err);

        res.json({ message: 'Successfully deleted message (reportAbuse)!'});
    });
  });

//Report Abuse Section ended


module.exports = router;

function dateDisplay(timestamp) {
  var date = new Date(timestamp);
  return(date.getMonth() + 1 + '/' + date.getDate() + '/' + date.getFullYear() + " " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds());
}