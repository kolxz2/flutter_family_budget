import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/repository/login_user_data_implementation.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.loginUserDataRepositoryImplementation})
      : super(UnLoginState()) {
    on<TryLoginEvent>(_tryLoginEvent);
    on<LogoutEvent>(_logoutEvent);
  }

  final LoginUserDataRepositoryImplementation
      loginUserDataRepositoryImplementation;

  _logoutEvent(LogoutEvent event, Emitter<LoginState> emit) async {
    emit(UnLoginState());
  }

  _tryLoginEvent(TryLoginEvent event, Emitter<LoginState> emit) async {
    bool isCorrect = await loginUserDataRepositoryImplementation
        .checkEnteredDate(event.userLogin, event.userPassword);
    if (isCorrect == true) {
      Map<String, dynamic> user = await loginUserDataRepositoryImplementation
          .getEnteredUser(event.userLogin, event.userPassword);
      emit(IsLoginState(
          isAdmin: user["isAdmin"].toLowerCase() == 'true',
          name: user["name"],
          password: user["password"],
          patronymic: user["patronymic"],
          surname: user["surname"]));
    } else {
      emit(UnLoginState());
    }
  }
}
