import 'package:flutter/material.dart';

import 'package:license_plate_judas_mvc/controllers/user.dart';
import 'package:license_plate_judas_mvc/definitions/auth_mode.dart';
import 'package:license_plate_judas_mvc/utility/media_query.dart';


class AuthenticateView extends StatefulWidget {
	final UserController _userController;
	UserController get userController => _userController;

	AuthenticateView(this._userController);

	@override
	_AuthenticateViewState createState() => new _AuthenticateViewState();
}


class _AuthenticateViewState extends State<AuthenticateView> {
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
	final Map<String, String> _formData = {
		'email': null,
		'password': null,
	};


	@override
	void initState() {
		super.initState();
	}


	@override
	Widget build(BuildContext context) {
		final double deviceWidth = MediaQuery.of(context).size.width;
		final double targetWidth = deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.85;

		return Scaffold(
			appBar: AppBar(
				title: Text('Login'),
			),
			body: Container(
				padding: EdgeInsets.all(10.0),
				child: Center(
					child: SingleChildScrollView(
						child: Container(
							width: targetWidth,
							child: Form(
								key: _formKey,
								child: Column(
									children: <Widget>[

								TextFormField(
								keyboardType: TextInputType.emailAddress,
									decoration: InputDecoration(
										labelText: 'E-Mail',
										filled: true,
										fillColor: Colors.white,
									),
									validator: (String value) {
										if (value == '' || value.length > 64) {
											return 'Invalid';
										}
									},
									onSaved: (String value) {
										_formData['email'] = value;
									},
								),

								SizedBox(
									height: 10.0,
								),

								TextFormField(
									decoration: InputDecoration(
										labelText: 'Password',
										filled: true,
										fillColor: Colors.white,
									),
									onSaved: (String value) {
										_formData['password'] = value;
									},
									validator: (String value) {
										if (value == '' || value.length > 64) {
											return 'Invalid';
										}
									},
								),

								SizedBox(
									height: 10.0,
								),

								// password confirm text field

								SizedBox(
									height: 10.0,
								),

								// switch signup mode button

								SizedBox(
									height: 30.0,
								),

								widget.userController.isLoading()
										? CircularProgressIndicator()
										: RaisedButton(
										child: Text('Login'),
										onPressed: () async {
											if (!_formKey.currentState.validate()) {
												return;
											}

											_formKey.currentState.save();

											final Map<String, dynamic> result = await widget.userController.authenticate(_formData['email'], _formData['password']);

											if (result['error'] != null) {
												showDialog(
													context: context,
													builder: (BuildContext context) {
														return AlertDialog(
															title: Text('An Error Occurred!'),
															content: Text(result['error']),
															actions: <Widget>[
																FlatButton(
																	child: Text('Okay'),
																	onPressed: () {
																		Navigator.of(context).pop();
																	},
																)
															],
														);
													},
												);
											}
										}
									),

								],
							),
						),
					),
				),
			),
		),
		);
	}
}
