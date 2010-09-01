Socket Logger: Real-time, JSON-parsable logging for [Socket.IO](http://github.com/learnboost/socket.io-node)
===============================================================

By default, socket logger is a simple logger that you can use with your [Socket.IO](http://github.com/learnboost/socket.io-node)-based node server.  

This is very very early alpha software with an API that I definitely want to change.  Eventually, you won't have to make any explicit log calls at all - socket-logger will just act as a middleware for your Socket.IO server and automatically log incomming connections and messages (something like how Connect or JSGI works).  However, you should still have the ability to log whatever custom calls you want too.

It's a little different from other loggers in that you can log not just connections and disconnections, but also each message.  Also, the log format is not Apache Common Log Format, but instead a JSON-parsable format.  

The secret sauce of socket-logger is how easy it makes it to set up a web client that gets information about your server.  Simply create a Socket.IO client that connects to your server with a specified auth token, and now your client gets JSON messages about all the socket connections and messages your server is handling.  I'll have an example client up soon.

How to use
============

You will need to install [Socket.IO-node](http://github.com/learnboost/socket.io-node) and have a socket-io server running.  Then, clone this repo.  Now put this in your server and smoke it:

    var http = require('http'), 
        log = require('./path/to/socket-logger'),
    	io = require('./path/to/socket.io'),

	server = http.createServer(function(req, res){
	});

	// socket.io, I choose you
    var socket = io.listen(server);
    var AUTH_TOKEN = 'my_secret_token_for_the_dashboard_client';

    socket.on('connection', function(client){
        log({'action' : 'connection', 'client' : client.sessionId});
        client.on('message', function(message) { 
	    log({'action' : 'message', 'client' : client.sessionId, 'body' : message});
	    var parsedMsg = JSON.parse(message);
	    if (parsedMsg.auth_token === AUTH_TOKEN)
	        log.socketLogger = client;
        });
        client.on('disconnect', function() {
            log({'action' : 'disconnect', 'client' : client.sessionId});
        });
    });
    
License
=======
(The MIT License)

Copyright (c) 2010 Saikat Chakrabarti <saikat@gomockingbird.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.