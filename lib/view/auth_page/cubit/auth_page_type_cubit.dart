import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthPageType { Login, Register }

/// Cubit responsible for switching between Login Page and Register Page.
class AuthPageTypeCubit extends Cubit<AuthPageType> {
  AuthPageTypeCubit() : super(AuthPageType.Login);

  /// Changes state to [AuthPageType.Login].
  void goToLoginPage() => emit(AuthPageType.Login);

  /// Changes state to [AuthPageType.Register].
  void goToRegisterPage() => emit(AuthPageType.Register);
}
