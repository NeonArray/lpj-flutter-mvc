import 'package:flutter/material.dart';

import 'package:license_plate_judas_mvc/controllers/user.dart';
import 'package:license_plate_judas_mvc/utility/media_query.dart';


class NavigationDrawer extends StatelessWidget {
	final UserController _userController = UserController();


	@override
	Widget build(BuildContext context) {
		return Drawer(
			child: Column(
				mainAxisSize: MainAxisSize.max,
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: <Widget>[
					DrawerHeader(
						child: Text('Drawer Header'),
						decoration: BoxDecoration(
							color: Colors.blue,
						),
					),
					ListTile(
						leading: Icon(Icons.edit),
						title: Text('Lookup/Report'),
						onTap: () {},
					),
					ListTile(
						leading: Icon(Icons.edit),
						title: Text('My Account'),
						onTap: () async {},
					),
					Expanded(
						child:Align(
							alignment: Alignment(1.0, 1.0),
							child: ListTile(
								leading: Icon(Icons.edit),
								title: Text('Sign Out'),
								onTap: () async {
									await _userController.signUserOut();
									Navigator.pushReplacementNamed(context, '/');
								},
							),
						),
					),
				],
			),
		);
	}
}