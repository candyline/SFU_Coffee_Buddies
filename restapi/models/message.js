//Data model for our server
var mongoose  = require('mongoose');
var Schema    = mongoose.Schema;
//specifying that a message object has fields named text and user
var messageSchema = new Schema({
  text: String,
  user: String,
  password: String,
  gender: String,
  meeting: String
});

module.exports = mongoose.model('Message', messageSchema);
