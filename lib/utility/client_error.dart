import 'package:flutter/material.dart';
import 'package:license_plate_judas_mvc/utility/sentry.dart';


class ClientError {
	final BuildContext context;
	final String message;
	final String title;
	final String culprit;
	final int code;
	final bool reportToSentry;
	final bool showToClient;
	final Function callback;


	ClientError({
		@required this.context,
		@required this.message,
		@required this.callback,
		this.title = 'An Error Occurred!',
		this.culprit = 'Application',
		this.showToClient = true,
		this.reportToSentry = false,
		this.code = 0,
	}) {
		if (reportToSentry) {
			Sentry().logMessage(message: message, culprit: culprit);
		}

		_buildDialog();
	}


	void _buildDialog() {

		if (!showToClient) {
			return;
		}

		showDialog(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					title: Text(title),
					content: Text(message),
					actions: <Widget>[
						FlatButton(
							child: Text('OK'),
							onPressed: callback,
						),
					],
				);
			},
		);
	}
}