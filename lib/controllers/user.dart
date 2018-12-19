import 'dart:core';
import 'package:rxdart/rxdart.dart';

import 'package:license_plate_judas_mvc/definitions/auth_mode.dart';
import 'package:license_plate_judas_mvc/models/user.dart';


// :: What's This? ::
/// The controller handles all of the logic that is important.
/// Order of interaction should be
/// View (Interacts with) => Controller (Asks for data) => Model (Returns data) => Controller (Formats data) => View
///
/// The goal is to be able to keep the controller from knowing too much details about the model. In
/// that way we can swap the model into any other service and the rest of the app would still function
/// without modification.

class UserController {
	UserModel _model;

	/// :: What's This? ::
	/// A PublishSubject is basically an event emitter. You create a new "subject" and give it a type
	/// in this instance a [bool]. Whenever you call _dispatcher.add(), you pass it the type that
	/// we specified. Then if there are listeners set up to "hear" the event attached to _dispatcher,
	/// they will receive the bool value.
	///
	/// There is a listener attached in the `main.dart` file, that sets the isAuthenticated property
	/// to whichever value is dispatched.
	PublishSubject<bool> _dispatcher;
	PublishSubject<bool> get dispatcher {
		return _dispatcher;
	}
	UserModel get model => _model;


	UserController({
		PublishSubject publishSubject,
		UserModel model,
	}) {
		_model = model ?? UserModel();
		_dispatcher = publishSubject ?? PublishSubject<bool>();
	}


	bool isLoading() => _model.isLoading;

	/// Exposing the notify method on the model so that we can call notifyListeners() on the scoped
	/// model from outside the model itself.
	void notify() => _model.notify();


	Future<Map<String, String>> authenticate(String email, String password, [AuthMode mode = AuthMode.Login]) async {
		final Map<String, String> userData = await _model.authenticate(email, password, mode);

		if (userData['id'] != null) {
			_dispatcher.add(true);
		}

		return userData;
	}


	Future<Map<String, String>> autoAuthenticate() async {
		final Map<String, String> userData = await _model.autoAuthenticate();

		if (userData['id'] != null) {
			_dispatcher.add(true);
		}

		return userData;
	}


	Future<void> resetPasswordWithEmail(String email) async {
		return await _model.resetPasswordWithEmail(email);
	}


	Future<void> signUserOut() async {
		await _model.signUserOut();
		_dispatcher.add(false);
	}
}
