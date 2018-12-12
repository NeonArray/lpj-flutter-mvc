import 'dart:core';
import 'package:rxdart/rxdart.dart';

import 'package:license_plate_judas_mvc/models/user.dart';


class UserController {
	final UserModel _model = UserModel();
	final PublishSubject<bool> _dispatcher = PublishSubject<bool>();
	PublishSubject<bool> get dispatcher {
		return _dispatcher;
	}
	UserModel get model => _model;

	bool isLoading() => _model.isLoading;
	void notify() => _model.notify();


	Future<Map<String, dynamic>> authenticate(String email, String password) async {
		final Map<String, dynamic> userData = await _model.authenticate(email, password);

		if (userData['user'] != null) {
			_dispatcher.add(true);
		}

		return userData;
	}
}
