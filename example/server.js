var http = require('http'), 
logger = require('../lib/socket-logger').defaultLogger,
io = require('./socket.io'),
server = http.createServer(function(req, res){
});

server.listen(8080);

var socket = io.listen(server);

socket.on('connection', function(client){
    client.on('message', function(message) { 
    });
    client.on('disconnect', function() {
    });
});

logger.logLevel = 2;
logger.failSilently = false;
logger.authToken = 'my_secret_token_for_the_dashboard_client';
logger.monitor(socket);