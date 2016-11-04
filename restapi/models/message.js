//Data model for our server
var mongoose  = require('mongoose');
var Schema    = mongoose.Schema;
//specifying that a message object has fields named text and user
var messageSchema = new Schema({
  text: String,
  user: String
});

module.exports = mongoose.model('Message', messageSchema);
