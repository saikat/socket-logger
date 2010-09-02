function makeLogger(options) {
    var logger = {};
    logger.options = options || {};
    logger.socketLogger = null;
    logger.authToken = null;
    // This whole method is hacky, but I'm not entirely sure what I want
    // the API to be
    logger.listen = function(event, obj) {
	obj.on(event, function() {
	    try {
		var currentTime = new Date(),
		timestamp = currentTime.getFullYear() + "/" + (currentTime.getMonth() + 1) + "/" + currentTime.getDate() + ":" + currentTime.getHours() + ":" + currentTime.getMinutes() + ":" + currentTime.getSeconds();
		var theMsg = {'time' : timestamp, 'action' : event};
		// Socket event, the argument was a Client
		if (arguments && arguments[0] && arguments[0].hasOwnProperty('sessionId')) {
		    theMsg.client = arguments[0].sessionId;
		// Possible message event
		}
		else if (arguments && arguments[0]) {
		    try {
			var parsedMsg = JSON.parse(arguments[0]);
		    } catch (ex) {
		    }
		    if (parsedMsg) 
			theMsg.body = parsedMsg;
		    if (obj.hasOwnProperty('sessionId'))
			theMsg.client = obj.sessionId;
		    
		    if (parsedMsg && parsedMsg.authToken === logger.authToken)
			logger.socketLogger = obj;
		}
		logger.log(theMsg);
	    } catch (ex) { }
	});
    }
	
    logger.log = function(msg, logOptions) {
	try {
	    var serializedMsg = JSON.stringify(msg),
	    stream = logger.options.stream || process.stdout;
	    stream.write(serializedMsg + '\n', 'utf8');
	    if (logger.socketLogger && logger.socketLogger.send) {
		logger.socketLogger.send(serializedMsg);
	    }
	} catch (ex) {
	}
    }
    return logger;
}

module.exports = makeLogger();