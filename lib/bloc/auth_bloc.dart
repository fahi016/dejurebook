import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dejurebook/services/auth_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final Map<String, dynamic>? metadata;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    this.metadata,
  });

  @override
  List<Object?> get props => [email, password, metadata];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthGoogleSignInRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final bool isNewSignup;

  const AuthAuthenticated({
    required this.user,
    this.isNewSignup = false,
  });

  @override
  List<Object?> get props => [user, isNewSignup];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthGoogleSignInRequested>(_onAuthGoogleSignInRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthPasswordResetRequested>(_onAuthPasswordResetRequested);

    // Listen to auth state changes
    AuthService.authStateChanges.listen((authState) {
      if (authState.event == AuthChangeEvent.signedIn) {
        add(AuthCheckRequested());
      } else if (authState.event == AuthChangeEvent.signedOut) {
        add(AuthCheckRequested());
      }
    });
  }

  void _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) {
    if (AuthService.isAuthenticated) {
      emit(AuthAuthenticated(
        user: AuthService.currentUser!,
        isNewSignup: false,
      ));
    } else {
      emit(AuthUnauthenticated());
    }
  }

// inside AuthBloc
  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await AuthService.signUpWithEmail(
        email: event.email,
        password: event.password,
        metadata: event.metadata,
      );

      if (response.user != null) {
        // Emit Authenticated with isNewSignup flag so UI can navigate to UserSelection
        emit(AuthAuthenticated(
          user: response.user!,
          isNewSignup: true,
        ));
      } else {
        emit(AuthError(message: 'Failed to create account'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await AuthService.signInWithEmail(
        email: event.email,
        password: event.password,
      );

      if (response.user != null) {
        emit(AuthAuthenticated(
          user: response.user!,
          isNewSignup: false,
        ));
      } else {
        emit(AuthError(message: 'Failed to sign in'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await AuthService.signInWithGoogle();
      // OAuth flow opens browser; final session arrives via redirect.
      // Emit success initiation; actual AuthAuthenticated should come from
      // AuthCheckRequested/onAuthStateChange elsewhere in the app.
      emit(const AuthSuccess(message: 'Google sign in initiated'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await AuthService.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await AuthService.resetPassword(event.email);
      emit(AuthSuccess(message: 'Password reset email sent'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
