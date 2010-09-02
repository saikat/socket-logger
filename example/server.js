var http = require('http'), 
logger = require('../lib/socket-logger'),
io = require('./socket.io'),

server = http.createServer(function(req, res){
});

server.listen(8080);
var socket = io.listen(server);
var AUTH_TOKEN = 'my_secret_token_for_the_dashboard_client';

socket.on('connection', function(client){
    logger.log({'action' : 'connection', 'client' : client.sessionId});
    client.on('message', function(message) { 
    var parsedMsg = JSON.parse(message);
    logger.log({'action' : 'message', 'client' : client.sessionId, 'body' : parsedMsg});
    if (parsedMsg.auth_token === AUTH_TOKEN)
        logger.socketLogger = client;
    });
    client.on('disconnect', function() {
        logger.log({'action' : 'disconnect', 'client' : client.sessionId});
    });
});