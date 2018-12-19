import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

import 'package:license_plate_judas_mvc/definitions/user.dart';
import 'package:license_plate_judas_mvc/definitions/auth_mode.dart';
import 'package:license_plate_judas_mvc/models/model_interface.dart';
import 'package:license_plate_judas_mvc/api/api.dart';


/// :: What's This? ::
/// The model is responsible for the fetching of data. Whether that's from REST API's, databases, or
/// the IO stream. We want to keep as much logic out of here as possible that isn't absolutely
/// necessary. This model should be able to swap sources without impacting the rest of the application.
class UserModel extends Model implements ModelInterface {
	Timer _authTimer; /// The timer executes the callback `signUserOut` when it expires
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


	Future<Map<String, String>> authenticate(String email, String password, AuthMode mode) async {
		lockUI();

		Map<String, String> responseData;

		if (mode == AuthMode.Login) {
			responseData = await _api.authWithEmailPassword(email, password);
		} else if (mode == AuthMode.Register) {
			responseData = await _api.createUserWithEmailAndPassword(email, password);
		}

		/// We only want to authenticate a user if the response data has something of value.
		if (responseData['id'] != null) {
			_setAuthenticatedUser(responseData);
			_setUserCookie(responseData);
		}

		releaseUI();

		return responseData;
	}


	void _setAuthenticatedUser(Map<String, dynamic> userData) {
		_authenticatedUser = User(
			id: userData['id'],
			email: userData['email'],
			token: userData['idToken'],
		);
	}


	Future<Map<String, String>> autoAuthenticate() async {
		final SharedPreferences localUserData = await SharedPreferences.getInstance();
		final String userToken = localUserData.getString('token');
		final String expiryTimeString = localUserData.getString('expiryTime');
		final DateTime parsedTimeString = expiryTimeString != null ? DateTime.parse(expiryTimeString) : DateTime.now();
		final DateTime now = DateTime.now();

		if (userToken == null) {
			return null;
		}

		if (parsedTimeString.isBefore(now)) {
			_authenticatedUser = null;
			notifyListeners();
			return null;
		}

		final int secondsTillExpire = parsedTimeString.difference(now).inSeconds;
		final Map<String, String> userData = {
			'id': localUserData.getString('id'),
			'email': localUserData.getString('email'),
			'token': userToken,
		};

		_setAuthenticatedUser(userData);

		_setAuthTimeout(secondsTillExpire);

		notifyListeners();

		return userData;
	}


	void _setAuthTimeout(int secondsTillExpire) {
		_authTimer = Timer(
			Duration(
				seconds: secondsTillExpire,
			),
			signUserOut,
		);
	}


	Future<void> _setUserCookie(Map<String, String> responseData) async {
		final DateTime now = DateTime.now();
		final int sevenDaysInSeconds = 604800;
		final DateTime expiryTime = now.add(Duration(seconds: sevenDaysInSeconds));

		final SharedPreferences prefs = await SharedPreferences.getInstance();
		prefs.setString('token', responseData['idToken']);
		prefs.setString('email', responseData['email']);
		prefs.setString('id', responseData['id']);
		prefs.setString('expiryTime', expiryTime.toIso8601String());
	}


	Future<void> resetPasswordWithEmail(String email) async {
		return await _api.resetPasswordWithEmail(email);
	}


	Future<void> signUserOut() async {
		final SharedPreferences prefs = await SharedPreferences.getInstance();
		_authenticatedUser = null;

		if (_authTimer != null && _authTimer.isActive) {
			_authTimer.cancel();
		}

		prefs.remove('token');
		prefs.remove('email');
		prefs.remove('id');

		return await _api.signUserOut();
	}
}
