import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/models/user/user_model.dart';
import 'package:frontend/data/repositories/user_respository.dart';
import 'package:frontend/logic/cubits/userCubit/user_state.dart';
import 'package:frontend/logic/services/preferences.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitialState()) {
    _initialize();
  }
  final UserRepository _repository = UserRepository();

  void _initialize() async {
    final userDetails = await Preferences.fetchUserDetails();
    String? email = userDetails["email"];
    String? password = userDetails["password"];
    if (email == null || password == null) {
      emit(UserLoggedOutState());
    } else {
      signIn(email: email, password: password);
    }
  }

  void signIn({required String email, required String password}) async {
    emit(UserLoadingState());
    try {
      UserModel userModel =
          await _repository.signIn(email: email, password: password);
      await Preferences.saveUserDetails(email, password);
      emit(UserLoggedInState(userModel));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  void createAccount({required String email, required String password}) async {
    emit(UserLoadingState());
    try {
      UserModel userModel =
          await _repository.createAccount(email: email, password: password);
      await Preferences.saveUserDetails(email, password);
      emit(UserLoggedInState(userModel));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<bool> updateUser(UserModel userModel) async {
    emit(UserLoadingState());
    try {
      UserModel updatedUser = await _repository.updateUser(userModel);

      emit(UserLoggedInState(updatedUser));
      return true;
    } catch (e) {
      emit(UserErrorState(e.toString()));
      return false;
    }
  }

  void signOut() async {
    await Preferences.clear();
    emit(UserLoggedOutState());
  }
}
