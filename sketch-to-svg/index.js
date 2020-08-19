var convertionService = require('./converter')
var express = require('express');
var app = express();

app.use(express.json())

app.post('/', async function (req, res) {
  console.log(req.body);
  res.contentType('image/png');
  png = await convertionService.convert(req.body); 
  // console.log(png);
  res.end(png, 'binary');
//   res.send(req.body);  
})

app.listen(8081, function(){
    console.log('app listen on port 8081')
})