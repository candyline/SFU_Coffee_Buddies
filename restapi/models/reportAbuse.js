//Data model for our server
var mongoose  = require('mongoose');
var Schema    = mongoose.Schema;
//specifying that a message object has fields named text and user
var reportAbuseSchema = new Schema({
  fromUser: String,
  fromEmail: String,
  toUser: String,
  toEmail: String,
  type: String,
  message: String
});

module.exports = mongoose.model('reportAbuse', reportAbuseSchema);
