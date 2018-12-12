import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:license_plate_judas_mvc/views/authenticate.dart';
import 'package:license_plate_judas_mvc/models/user.dart';
import 'package:license_plate_judas_mvc/controllers/user.dart';


Future main() async {
	await DotEnv().load('.env');
	runApp(LicensePlateJudas());
}


class LicensePlateJudas extends StatefulWidget {
	@override
	_LicensePlateJudasState createState() => new _LicensePlateJudasState();
}


class _LicensePlateJudasState extends State<LicensePlateJudas> {
	final UserController userController = UserController();
	bool _isAuthenticated = false;


	@override
	void initState() {
		userController.dispatcher.stream.listen((bool isAuthenticated) {
			setState(() {
				_isAuthenticated = isAuthenticated;
			});
		});

		super.initState();
	}


	@override
	Widget build(BuildContext context) {
		return ScopedModel<UserModel>(
			model: userController.model,
			child: MaterialApp(
				theme: ThemeData(
					brightness: Brightness.light,
					primarySwatch: Colors.teal,
					accentColor: Colors.grey,
					buttonColor: Colors.deepPurple,
				),
				routes: {
					// The '/' is a special route that Flutter uses to show as the 'home' screen.
					// you CANNOT use both the home: property in MaterialApp as well as this '/' route
					// or it will throw an error. Use one or the other.
					'/': (BuildContext context) => !_isAuthenticated ? AuthenticateView(userController) : Text('OOOOOO girl'),
				},
			),
		);
	}
}
