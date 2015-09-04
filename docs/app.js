var express = require('express');
var path = require('path');
var engine = require('ejs-locals');
var app = express();
app.engine('ejs', engine);
app.set('view engine', 'ejs');

app.set('views', 'views');
app.use(express.static(__dirname + '\\..\\vendor'));
app.use(express.static(__dirname + '/assets'));

router = express.Router();

router.get("/",function (req, res){
  res.render('index');
});

app.use('/',router);

app.use(function(req,res,next){
  console.log('------------------------')
  res.status(404)
  next();
});



app.set('port', process.env.PORT || 4000);
var server = app.listen(app.get('port'), function() {
  console.log('Express server listening on port ' + server.address().port);
});
module.exports = app;