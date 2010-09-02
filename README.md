Socket Logger: Real-time, JSON-parsable logging for [Socket.IO](http://github.com/learnboost/socket.io-node)
===============================================================

The code is really simple and fairly trivial right now, but is enough for my immediate needs.  See notes below for where I want to take it.

By default, socket logger is a simple logger that you can use with your [Socket.IO](http://github.com/learnboost/socket.io-node)-based node server.  

It's a little different from other loggers in that you can log not just connections and disconnections, but also each message.  Also, the log format is not Apache Common Log Format, but instead JSON-parsable strings.  So, you log JS objects, not strings.

The secret sauce of socket-logger is how easy it makes it to set up a web client that gets information about your server.  Simply create a Socket.IO client that connects to your server with a specified auth token, and now your client gets JSON messages about all the socket connections and messages your server is handling.  Check out the example for a demo of this.

How to use
============

You will need to install [Socket.IO-node](http://github.com/learnboost/socket.io-node) and have a socket-io server running.  Then, clone this repo.  Now put this in your server and smoke it:


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
    logger.authToken = 'my_secret_token_for_the_dashboard_client';
    logger.monitor(socket);

Running the demo
================

1. Clone this repository.  Be sure to use the --recursive flag.
2. Run "node server.js" in the example folder
3. Open example/client/index.html in your browser
4. Open example/dashboard/index.html in another windew
5. Start tying in the client asd watch the dashboard.

Screenshots of demo
===================

## Client
![Client](http://imgur.com/S3Wke.png)

## Dashboard
![Dashboard](http://imgur.com/PJy3x.png)

Caveats and Notes
=================

This is very very early alpha software with an API that I definitely want to change.  I'm not entirely sure what I want the API to be yet.  On one hand, I want the logging to happen transparently (like Connect or JSGI), but on the other hand, it might be too aggressively to log every message.  Will figure this out later when I get some time.

Even more eventually, it'd be kind of cool to have the client-side be some kind of web service.  Real-time socket-based analytics for all?
    
License
=======
(The MIT License)

Copyright (c) 2010 Saikat Chakrabarti <saikat@gomockingbird.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.