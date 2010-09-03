function makeLogger() {
    var logger = {
	stream : process.stdout,
	socketLogger : null,
	authToken : null,
	logLevel : 0,
	failSilently : true,
	monitor : function(socket) {
	    socket.on('connection', function(client) {
		logger.log(['connect', client.sessionId]);
		client.on('message', function(message) {
		    try {
			if (logger.logLevel === 0)
			    return;
			var theMessage = ['message'];
			if (message === logger.authToken) 
			    logger.socketLogger = client;
			theMessage.push(client.sessionId);
			if (logger.logLevel == 2) {
			    try { var parsedMsg = JSON.parse(message); } catch (ex) { }
			    theMessage.push(parsedMsg ? parsedMsg : message);
			}
			logger.log(theMessage);
		    } catch (ex) {
			if (!logger.failSilently)
			    throw ex;
		    }
		});
		client.on('disconnect', function() {
		    logger.log(['disconnect', client.sessionId]);
		});
	    });
	},
	
	// Expects an array
	log : function(msg) {
	    try {
		if (!Array.isArray(msg))
		    return;

		var currentTime = new Date(),
		timestamp = currentTime.getFullYear() + "/" + (currentTime.getMonth() + 1) + "/" + currentTime.getDate() + ":" + currentTime.getHours() + ":" + currentTime.getMinutes() + ":" + currentTime.getSeconds();
		msg.unshift(timestamp);
 		msg = JSON.stringify(msg); 
		stream = logger.stream;
		stream.write(msg + '\n', 'utf8');
		if (logger.socketLogger && logger.socketLogger.send) {
		    logger.socketLogger.send(msg);
		}
	    } catch (ex) {
		if (!logger.failSilently)
		    throw ex;
	    }
	}
    }
    return logger;
}

exports.defaultLogger = makeLogger();
exports.newLogger = makeLogger;