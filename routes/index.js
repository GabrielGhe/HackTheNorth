var dv = require('dv')
  , fs = require('fs');

exports.index = function(req, res){
  var localFile = "/../img/test.jpg";
  var image = new dv.Image('png', fs.readFileSync(__dirname + localFile);
  var tesseract = new dv.Tesseract('eng', image);

  // Get text
  nodecr.process(__dirname + localFile,function(err, text) {
    if(err) {
      console.error(err);
    } else {
      console.log("Got here", text);
      res.send(200);
    }
  });

};