import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:license_plate_judas_mvc/models/model_interface.dart';
import 'package:license_plate_judas_mvc/api/api.dart';


class User {
	final String id;
	final String email;
	final String token;

	User({
		@required this.id,
		@required this.email,
		@required this.token,
	});
}


class UserModel extends Model implements ModelInterface {
	User _authenticatedUser;
	User get authedUser {
		return _authenticatedUser;
	}
	bool _isLoading = false;
	bool get isLoading => _isLoading;


	void notify() => notifyListeners();


	void lockUI() {
		_isLoading = true;
		notifyListeners();
	}


	void releaseUI() {
		_isLoading = false;
		notifyListeners();
	}


	Future<bool> authenticate(String email, String password) async {
		lockUI();

		Map<String, dynamic> response = await API.authWithEmailPassword(email, password);

		if (response.containsKey('idToken')) {
			_authenticatedUser = User(
				id: response['localId'],
				email: response['email'],
				token: response['idToken'],
			);
		}

		releaseUI();

		return true;
	}
}
