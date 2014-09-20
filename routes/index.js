var dv = require('dv')
  , fs = require('fs')
  , Q = require('q');

exports.index = function(req, res){

  var loadedFile = req.files.file.path;
  var text = "";
  
  Q.longStackSupport = true;
  Q.nfcall(fs.readFile, loadedFile)
    .then(function(file){
      var image = new dv.Image('png', req).scale(7.0)
      , tesseract = new dv.Tesseract('eng', image);
      
      text = tesseract.findText('plain');
      return Q.nfcall(fs.unlink, loadedFile);
    })
    .then(function() {
      res.send(text);
    })
    .fail(function() {
      res.send(400);
    });
};