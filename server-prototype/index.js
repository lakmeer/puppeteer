
// Require

var app = require('http').createServer(handler)
var io = require('socket.io')(app);
var fs = require('fs');


// Config

var Config = {
  port: 9000,
  publicDir: '/../public/'
};


// Helpers

function log () { console.log.apply(console, arguments); }
function publicDir (url) { return __dirname + Config.publicDir + url }
function randomFrom (list) { return list[ Math.floor(Math.random() * list.length) ]; }

// Functions

function handler (req, res) {
  switch (req.url) {
    case "/": serveStatic('index.html', res); break;
    case "/favicon.ico": serveNothing(res); break;
    default: serveStatic(req.url, res);
  }
}

function serveNothing (res) {
  res.writeHead(200);
  res.end('');
}

function serveStatic (url, res) {
  fs.readFile( publicDir(url), function (err, data) {
    if (err) {
      res.writeHead(404);
      return res.end('');
    }

    res.writeHead(200);
    res.end(data);
  });
}


io.on('connection', function (socket) {
  setInterval(function () {

    var event = randomFrom([ 'keydown', 'keyup', 'mousedown', 'mouseup' ]);

    switch (event) {
      case 'mousedown': case 'mouseup':
        socket.emit(event, Math.floor(Math.random() * 2));
        break;

      case 'keydown': case 'keyup':
        socket.emit(event, randomFrom([ 90, 88, 67, 86 ]));
        break;

      default:
        log('unhandled:', event);
    }

  }, 500);
});


/* THEORETICAL FLOW

   - Init WS server
   - Establish callbacks:

   / - Serve theatre html, set mode to 'PERFORMANCE'
   /editor - Serve editor html, set mode 'EDITOR'
   /assets/ - serve static files based on mimetype
   /config/name - load and send character config json

   SAVE config - persist config as json

   - Init hooks
   - Establish hook callbacks
   Keyboard - generate ws description packet
   Mouse    - generate ws description packet
   - Run loop

   - Join hooks to websockets if not running in editor mode
*/

// Init
app.listen(Config.port);
