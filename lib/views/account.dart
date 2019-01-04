import 'package:flutter/material.dart';

import 'package:license_plate_judas_mvc/controllers/user.dart';
import 'package:license_plate_judas_mvc/utility/media_query.dart';
import 'package:license_plate_judas_mvc/utility/state_list.dart';
import 'package:license_plate_judas_mvc/views/navigation_drawer.dart';


class AccountView extends StatefulWidget {
	final UserController _userController;
	UserController get userController => _userController;


	AccountView(this._userController);


	@override
	_AccountViewState createState() => new _AccountViewState();
}


class _AccountViewState extends State<AccountView> {

	@override
	void initState() {
		super.initState();
	}


	@override
	Widget build(BuildContext context) {
		final double targetWidth = getDeviceTargetWidth(context);

		return Scaffold(
			drawer: NavigationDrawer(widget._userController),
			appBar: AppBar(
				title: Text('My Account'),
			),
			body: Container(
				padding: EdgeInsets.all(10.0),
				child: Center(
					child: SingleChildScrollView(
						child: Container(
							width: targetWidth,
							child: Text('hi'),
						),
					),
				),
			),
		);
	}
}