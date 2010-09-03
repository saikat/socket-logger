Socket Logger: JSON-parsable logging for [Socket.IO](http://github.com/learnboost/socket.io-node)
===============================================================

By default, socket logger is a simple logger that you can use with your [Socket.IO](http://github.com/learnboost/socket.io-node)-based node server.  Depending on the log level used, you can log connections, disconnections, message requests, and the actual contents of messages.  

The log format is currently not in Apache Common Log Format, but instead JSON-parsable strings.  I think this makes it easier to write scripts to crawl my logs (especially since most message payloads are in JSON), but I'll eventually make it so that the log format can be specified.

Socket-logger also provides a hook to set up a web client that gets information about your server in real-time.  Simply create a Socket.IO client that connects to your server with a specified auth token, and now your client gets JSON messages pushed to it about your server activity.  Check out the example for a demo of this.

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
5. Start typing in the client asd watch the dashboard.

Screenshots of demo
===================

## Client
![Client](http://imgur.com/S3Wke.png)

## Dashboard
![Dashboard](http://imgur.com/PJy3x.png)

Caveats and Notes
=================

* I haven't benchmarked this code.  It's probably fine for many cases, but high-traffic socket servers will need to make sure this doesn't kill performance (especially at higher log levels).
* It'd be kind of cool to have the client-side be some kind of web service.  Real-time socket-based analytics for all?
    
License
=======
(The MIT License)

Copyright (c) 2010 Saikat Chakrabarti <saikat@gomockingbird.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.