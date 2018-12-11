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


	void notify() => _model.notify();


	Future<bool> authenticate(Map<String, String> formData) async {
		if (formData['email'] == null || formData['password'] == null) {
			return false;
		}

		if (await _model.authenticate(formData['email'], formData['password'])) {
			_dispatcher.add(true);
			return true;
		}

		return false;
	}
}
