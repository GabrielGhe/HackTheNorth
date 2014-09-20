var api = require("../config")
  , AsposeCloud = require("asposecloud")
  , aspose = new AsposeCloud({
  appSID: api.sid,
  appKey: api.key,
  baseURI: "http://api.aspose.com/v1.1/"
});


exports.index = function(req, res){

  res.send(200);
  res.end();
};