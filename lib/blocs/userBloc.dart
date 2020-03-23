import 'package:rxdart/rxdart.dart';
import 'package:walgotech_final/models/users.dart';
import 'package:walgotech_final/resources/repository.dart';


class RegisterBloc {
  final _repository = Repository();
  final _userSaver = PublishSubject<User>();

  signInUser(String userName, String password) async {
    User user = await _repository.signIn(userName, password);
    _userSaver.add(user);
  }

  dispose() {
    _userSaver.close();
  }
}

final userBloc = RegisterBloc();
