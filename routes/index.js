var dv = require('dv')
  , fs = require('fs')
  , Q = require('q');

exports.index = function(req, res){

  var loadedFile = req.files.file.path
  fs.readFile(loadedFile, function(err, file){
    console.log(file);
    var image = new dv.Image('png', file).scale(7.0)
      , tesseract = new dv.Tesseract('eng', image)
      , text = tesseract.findText('plain');
    fs.unlink
    res.send(text);
  });
};