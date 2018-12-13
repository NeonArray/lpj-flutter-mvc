import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:license_plate_judas_mvc/sentry/sentry.dart';


class API {
	final String name = 'lp-judas';
	FirebaseOptions options = FirebaseOptions(
		googleAppID: DotEnv().env['googleAppId'],
		gcmSenderID: DotEnv().env['gcmSenderID'],
		apiKey: DotEnv().env['apiKey'],
		databaseURL: DotEnv().env['databaseURL'],
		storageBucket: DotEnv().env['storageBucket'],
		projectID: DotEnv().env['projectID'],
	);
	FirebaseApp app;
	FirebaseAuth _auth;


	API() {
		_configure();
	}


	Future<Null> _configure() async {
		app = await FirebaseApp.configure(
			name: name,
			options: options,
		);

		if (app == null) {
			Sentry().logException(Exception('[FirebaseApp : ' + name + '] could not be instantiated'));
			return;
		}

		_auth = FirebaseAuth.fromApp(app);
	}


	Future<Map<String, String>> _authBase(String email, String password, Function callback) async {
		FirebaseUser user;
		Map<String, String> userData = {};

		try {
			user = await callback(email: email, password: password);
			userData = {
				'user': user.uid,
				'idToken': await user.getIdToken(refresh: false),
				'email': user.email,
			};
		} catch (error) {
			Sentry().logMessage(
				message: error.toString(),
				culprit: 'Firebase_Auth',
			);

			userData['error'] = error.toString();
		}

		return userData;
	}


	Future<Map<String, String>> createUserWithEmailAndPassword(String email, String password) async {
		return await _authBase(email, password, _auth.createUserWithEmailAndPassword);
	}


	Future<Map<String, String>> authWithEmailPassword(String email, String password) async {
		return await _authBase(email, password, _auth.signInWithEmailAndPassword);
	}


	Future<void> resetPasswordWithEmail(String email) async {
		return await _auth.sendPasswordResetEmail(email: email);
	}


	Future<void> signUserOut() async {
		return await _auth.signOut();
	}
}
