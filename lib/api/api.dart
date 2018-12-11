
class API {

	static Future<Map<String, dynamic>> authWithEmailPassword(String email, String password) async {
		return {
			'user': '1',
			'idToken': 'abc',
			'email': 'abc',
		};
	}
}
