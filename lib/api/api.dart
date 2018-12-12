import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
		assert(app != null);
		_auth = FirebaseAuth.fromApp(app);
		print('Configured $app');
	}


	Future<Map<String, dynamic>> authWithEmailPassword(String email, String password) async {
		FirebaseUser user;

		try {
			user = await _auth.signInWithEmailAndPassword(email: email, password: password);
		} catch (error) {
			print(error);
			return {};
		}

		return {
			'user': user.uid,
			'idToken': await user.getIdToken(refresh: false),
			'email': user.email,
		};
	}
}
