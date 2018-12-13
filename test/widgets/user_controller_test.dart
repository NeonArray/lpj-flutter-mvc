import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:license_plate_judas_mvc/models/user.dart';
import 'package:license_plate_judas_mvc/controllers/user.dart';
import 'package:license_plate_judas_mvc/definitions/auth_mode.dart';


class MockUserModel extends Mock implements UserModel {}


void main() {
	MockUserModel model = MockUserModel();
	UserController controller = UserController(model: model);

	test('isLoading should default to false', () {
		when(model.isLoading).thenReturn(false);

		expect(controller.isLoading(), false);
	});
}
