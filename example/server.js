var http = require('http'), 
log = require('../lib/socket-logger'),
io = require('./socket.io'),

server = http.createServer(function(req, res){
});

server.listen(8080);
log.authToken = 'my_secret_token_for_the_dashboard_client';
var socket = io.listen(server);

socket.on('connection', function(client){
    log.listen('message', client);
    log.listen('disconnect', client);
    client.on('message', function(message) { 
    });
    client.on('disconnect', function() {
    });
});

log.listen('connection', socket);