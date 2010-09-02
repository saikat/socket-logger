function makeLogger(options) {
    var logger = {};
    logger.options = options || {};
    logger.socketLogger = null;
    logger.authToken = null;
    // This whole method is hacky, but I'm not entirely sure what I want
    // the API to be
    logger.listen = function(event, obj) {
	obj.on(event, function() {
	    // Socket event, the argument was a Client
	    if (arguments && arguments[0] && arguments[0].hasOwnProperty('sessionId'))
		logger.log({'action' : event, 'client' : arguments[0].sessionId});
	    // Possible message event
	    else if (arguments && arguments[0]) {
		try {
		    var parsedMsg = JSON.parse(arguments[0]);
		} catch (ex) {
		}
		var theMsg = {'action' : event};
		if (parsedMsg) 
		    theMsg.body = parsedMsg;
		if (obj.hasOwnProperty('sessionId'))
		    theMsg.client = obj.sessionId;

		logger.log(theMsg);

		if (parsedMsg && parsedMsg.authToken === logger.authToken)
		    logger.socketLogger = obj;
	    }
	    else
		logger.log({'action' : event});
	});
    }
    logger.log = function(msg, logOptions) {
	var serializedMsg = JSON.stringify(msg),
	stream = logger.options.stream || process.stdout;
	stream.write(serializedMsg + '\n', 'utf8');
	if (logger.socketLogger && logger.socketLogger.send) {
	    logger.socketLogger.send(serializedMsg);
	}
    }
    return logger;
}

module.exports = makeLogger();