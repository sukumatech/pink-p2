var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/html'});
  res.end('Masood here!...');
}).listen(8080, () => console.log('listening'));
