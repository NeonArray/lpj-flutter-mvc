import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
	final TextEditingController _passwordTextController = TextEditingController();
	AuthMode _authMode = AuthMode.Login;
	bool _isLoading = false;


	Widget _buildEmailField() {
		return TextFormField(
			keyboardType: TextInputType.emailAddress,
			decoration: InputDecoration(
				labelText: 'E-Mail',
				filled: true,
				fillColor: Colors.white,
			),
			validator: (String value) {
				if (value.isEmpty || !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(value)) {
					return 'Invalid email address, please ente valid email';
				}
			},
			onSaved: (String value) {
				_formData['email'] = value;
			},
		);
	}


	Widget _buildPasswordField() {
		return TextFormField(
			decoration: InputDecoration(
				labelText: 'Password',
				filled: true,
				fillColor: Colors.white,
			),
			obscureText: true,
			controller: _passwordTextController,
			onSaved: (String value) {
				_formData['password'] = value;
			},
			validator: (String value) {
				if (value.isEmpty || value.length < 6) {
					return 'Password invalid';
				}
			},
		);
	}


	Widget _buildPasswordConfirmField() {
		return TextFormField(
			obscureText: true,
			decoration: InputDecoration(
				labelText: 'Confirm Password',
				filled: true,
				fillColor: Colors.white,
			),
			validator: (String value) {
				if (_passwordTextController.text != value) {
					return 'Passwords must match';
				}
			},
		);
	}


	Widget _buildSubmitButton() {
		return RaisedButton(
			child: Text(_authMode == AuthMode.Login ? 'Login' : 'Register'),
			onPressed: _submit,
		);
	}


	Future<void> _submit() async {
		if (!_formKey.currentState.validate()) {
			return;
		}

		_formKey.currentState.save();

		toggleProgressHUD();

		final Map<String, dynamic> result = await widget.userController.authenticate(_formData['email'], _formData['password'], _authMode);

		if (result['error'] != null) {
			_buildErrorDialog(result['error']);
		}

		toggleProgressHUD();
	}


	void _buildErrorDialog(String error) {
		showDialog(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					title: Text('An Error Occurred!'),
					content: Text(error),
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


	Widget _buildAuthModeButton() {
		return FlatButton(
			child: Text('Switch to ${_authMode == AuthMode.Login ? 'Register' : 'Login'}'),
			onPressed: () {
				setState(() {
					_authMode = _authMode == AuthMode.Login ? AuthMode.Register : AuthMode.Login;
				});
			},
		);
	}


	void toggleProgressHUD() {
		setState(() {
			_isLoading = !_isLoading;
		});
	}


	List<Widget> _buildFormWidgets() {
		return [
			_buildEmailField(),

			SizedBox(height: 10.0,),

			_buildPasswordField(),

			SizedBox(height: 10.0,),

			_authMode == AuthMode.Register ? _buildPasswordConfirmField() : Container(),

			SizedBox(height: 10.0,),

			_buildAuthModeButton(),

			_buildSubmitButton(),
		];
	}


	@override
	Widget build(BuildContext context) {
		final double targetWidth = getDeviceTargetWidth(context);

		return Scaffold(
			appBar: AppBar(
				title: Text('Login'),
			),
			body: ModalProgressHUD(
				opacity: 0.5,
				progressIndicator: CircularProgressIndicator(),
				child: SingleChildScrollView(
					child: Center(
						child: Container(
							width: targetWidth,
							child: Form(
								key: _formKey,
								child: Column(
									mainAxisSize: MainAxisSize.min,
									children: _buildFormWidgets(),
								),
							),
						),
					),
				),
				inAsyncCall: _isLoading,
			),
		);
	}
}
