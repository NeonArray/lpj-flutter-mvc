import 'package:sentry/sentry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Sentry {
	final SentryClient _sentry = new SentryClient(dsn: DotEnv().env['SENTRY_DSN']);

	void logMessage({
		@required String message,
		String culprit,
	    Map<String, String> tag,
	}) {
		_sentry.capture(event: Event(
			message: message ?? 'Event message was not specified',
			level: SeverityLevel.info,
			culprit: culprit ?? 'Application',
		));
	}


	void logException(Exception error) {
		_sentry.captureException(exception: error);
	}
}
