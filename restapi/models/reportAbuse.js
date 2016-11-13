//Data model for our server
var mongoose  = require('mongoose');
var Schema    = mongoose.Schema;
//specifying that a message object has fields named text and user
var reportAbuseSchema = new Schema({
  interest: String,
  bio: String,
  email: String,
  username: String,
  //pw: String,
  //gender: String,
  //bus: String,
  //meeting: String,
  //major: String
});

module.exports = mongoose.model('reportAbuse', reportAbuseSchema);
