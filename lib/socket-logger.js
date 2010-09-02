function makeLogger(options) {
    var logger = {};
    logger.options = options || {};
    logger.socketLogger = null;
    logger.log = function(msg, logOptions) {
	var serializedMsg = JSON.stringify(msg),
	stream = logger.options.stream || process.stdout;
	stream.write(serializedMsg, 'utf8');
	if (logger.socketLogger && logger.socketLogger.send) {
	    logger.socketLogger.send(serializedMsg);
	}
    }
    return logger;
}

module.exports = makeLogger();