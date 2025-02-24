import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_game_flutter/core/models/user_model.dart';
import 'package:map_game_flutter/core/services/auth_service.dart';
import 'package:map_game_flutter/core/utils/cache_manager.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object> get props => [];
}

class LoginPressed extends AuthEvent {
  final String email;
  final String password;

  const LoginPressed({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class RegisterPressed extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const RegisterPressed({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [username, email, password];
}

class CheckAuthentication extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

class AuthenticationError extends AuthState {
  final String message;

  const AuthenticationError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class LoggingIn extends AuthState {}

// BLoC Implementation
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final CacheManager _cacheManager;

  AuthBloc(this._authService, this._cacheManager) : super(Unauthenticated()) {
    on<LoginPressed>(_onLoginPressed);
    on<RegisterPressed>(_onRegisterPressed);
    on<CheckAuthentication>(_onCheckAuthentication);
  }

  Future<void> _onLoginPressed(
    LoginPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoggingIn());
    
    try {
      final user = await _authService.login(
        email: event.email,
        password: event.password,
      );
      
      await _cacheManager.set(
        'user', user,
      ); // Save user to cache
      emit(Authenticated(user: user));
    } catch (error) {
      emit(AuthenticationError(
        message: error.toString(),
      ));
    }
  }

  Future<void> _onRegisterPressed(
    RegisterPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoggingIn());
    
    try {
      final user = await _authService.register(
        username: event.username,
        email: event.email,
        password: event.password,
      );
      
      await _cacheManager.set(
        'user', user,
      ); // Save user to cache
      emit(Authenticated(user: user));
    } catch (error) {
      emit(AuthenticationError(
        message: error.toString(),
      ));
    }
  }

  Future<void> _onCheckAuthentication(
    CheckAuthentication event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final player = await _cacheManager.get<User>('user');
      if (player != null) {
        emit(Authenticated(user: player));
      } else {
        emit(Unauthenticated());
      }
    } catch (error) {
      emit(Unauthenticated());
    }
  }
}