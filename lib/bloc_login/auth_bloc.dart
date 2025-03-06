import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested(this.username, this.password);
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    // Register event handlers with the on<Event> syntax
    on<LoginRequested>((event, emit) async {
      // Set loading state
      emit(AuthLoading());

      try {
        // Simulate API call for login
        await Future.delayed(Duration(seconds: 2));

        // Check username and password
        if (event.username == "admin" && event.password == "password") {
          emit(AuthSuccess());
        } else {
          emit(AuthError("Invalid username or password"));
        }
      } catch (e) {
        emit(AuthError("An error occurred during login"));
      }
    });
  }
}
