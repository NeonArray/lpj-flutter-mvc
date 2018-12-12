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
	API _api = API();


	void notify() => notifyListeners();


	void lockUI() {
		_isLoading = true;
		notifyListeners();
	}


	void releaseUI() {
		_isLoading = false;
		notifyListeners();
	}


	Future<Map<String, dynamic>> authenticate(String email, String password) async {
		lockUI();

		Map<String, dynamic> responseData = await _api.authWithEmailPassword(email, password);

		if (responseData['user'] == null) {
			setAuthenticatedUser(responseData);
		}

		releaseUI();

		return responseData;
	}


	void setAuthenticatedUser(Map<String, dynamic> userData) {
		_authenticatedUser = User(
			id: userData['user'],
			email: userData['email'],
			token: userData['idToken'],
		);
	}
}
