import 'package:scoped_model/scoped_model.dart';


class ModelInterface extends Model {
	bool _isLoading = false;


	bool get isLoading => _isLoading;


	void lockUI() {
		_isLoading = true;
		notifyListeners();
	}

	void releaseUI() {
		_isLoading = false;
		notifyListeners();
	}
}