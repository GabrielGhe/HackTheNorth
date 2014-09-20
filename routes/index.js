var dv = require('dv')
  , fs = require('fs')
  , Q = require('q');

exports.index = function(req, res){

  var loadedFilePath = req.files.file.path || "";
  var name = req.files.file.name || "";
  var text = "";
  
  Q.longStackSupport = true;
  Q.nfcall(fs.readFile, loadedFilePath)
    .then(function(file){
      var image = new dv.Image('png', file).scale(7.0)
      , tesseract = new dv.Tesseract('eng', image);
      
      text = tesseract.findText('plain');
      return Q.nfcall(fs.unlink, loadedFilePath);
    })
    .then(function() {
      console.log(text);
      res.send(text);
    })
    .fail(function() {
      res.send(400);
    });
};