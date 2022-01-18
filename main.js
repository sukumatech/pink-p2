var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/html'});
  res.end('Are you awake!');
}).listen(8080, () => console.log('listening'));
