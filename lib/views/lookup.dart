import 'package:flutter/material.dart';

import 'package:license_plate_judas_mvc/controllers/user.dart';
import 'package:license_plate_judas_mvc/utility/media_query.dart';
import 'package:license_plate_judas_mvc/utility/state_list.dart';


class LookupView extends StatefulWidget {
	final UserController _userController;
	UserController get userController => _userController;


	LookupView(this._userController);


	@override
	_LookupViewState createState() => new _LookupViewState();
}


class _LookupViewState extends State<LookupView> {
	final Map<String, String> _formData = {};
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


	@override
	void initState() {
		super.initState();
	}


	Drawer _buildDrawer(BuildContext context) {
		return Drawer(
			child: Column(
				children: <Widget>[
					AppBar(
						automaticallyImplyLeading: false,
						title: Text('Choose'),
					),
					ListTile(
						leading: Icon(Icons.edit),
						title: Text('Manage Products'),
						onTap: () {
							Navigator.pushReplacementNamed(context, '/');
						},
					),
					Divider(),
					// LogoutListTile(),
				],
			),
		);
	}


	Widget _buildStateDropdown() {
		List<DropdownMenuItem<String>> items = List();

		states.forEach((String key, String value) {
			items.add(DropdownMenuItem<String>(
				value: value,
				child: Text(key),
			));
		});

		return DropdownButton<String>(
			items: items,
			isExpanded: true,
			hint: Text('State'),
			onChanged: (String value) {
				setState(() {
					_formData['state'] = value;
				});
			},
			value: _formData['state'],
		);
	}


	Widget _buildPlateField() {
		return TextFormField(
			keyboardType: TextInputType.text,
			decoration: InputDecoration(
				labelText: 'Plate Number',
				filled: true,
				fillColor: Colors.white,
			),
			validator: (String value) {
				if (value.isEmpty) {
					return 'Cannot be empty';
				}
			},
			onSaved: (String value) {
				_formData['plate_number'] = value;
			},
		);
	}


	Widget _buildActionsRow() {
		return Row(
			children: <Widget>[
				RaisedButton(
					child: Text('Lookup'),
					onPressed: ()  {},
				),
				RaisedButton(
					child: Text('Report'),
					onPressed: ()  {},
				),
			],
		);
	}


	@override
	Widget build(BuildContext context) {
		final double targetWidth = getDeviceTargetWidth(context);

		return Scaffold(
			drawer: _buildDrawer(context),
			appBar: AppBar(
				title: Text('Lookup Plate'),
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

										_buildStateDropdown(),

										_buildPlateField(),

										SizedBox(
											height: 10.0,
										),

										_buildActionsRow(),

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