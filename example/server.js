var http = require('http'), 
log = require('../lib/socket-logger'),
io = require('./socket.io'),

server = http.createServer(function(req, res){
});

server.listen(8080);
logger.authToken = 'my_secret_token_for_the_dashboard_client';
var socket = io.listen(server);

socket.on('connection', function(client){
    logger.listen('message', client);
    logger.listen('disconnect', client);
    client.on('message', function(message) { 
    });
    client.on('disconnect', function() {
    });
});

logger.listen('connection', socket);