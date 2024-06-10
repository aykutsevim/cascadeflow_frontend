import 'package:cascade_flow/models/project.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cascade_flow/core/web_service.dart';
import 'dart:convert';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? username;
  final String? password;
  final String? error;

  AuthState({
    required this.isAuthenticated,
    required this.isLoading,
    this.username = '',
    this.password = '',
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    String? username,
    String? password,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      username: username ?? this.username,
      password: password ?? this.password,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false, isLoading: false));

  void setAuthenticated(bool isAuthenticated) {
    state = state.copyWith(isAuthenticated: isAuthenticated);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }

  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  Future<void> login() async {
    try {
      state = state.copyWith(isLoading: true);

      var response = await WebService.post('Auth/login', body: {'username': state.username, 'password': state.password});

      if (response.statusCode >= 400) {
        state = state.copyWith(error: 'Failed to login. Please try again later.');
      }

      var data = jsonDecode(response.body);

      if (data['token'] != null) {
        state = state.copyWith(isAuthenticated: true);

        await WebService.storeToken(data['token']);
      } else {
        state = state.copyWith(error: 'Invalid email or password.');
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to login. Please try again later.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);

      var response = await WebService.post('Auth/logout');

      if (response.statusCode >= 400) {
        state = state.copyWith(error: 'Failed to logout. Please try again later.');
      }

      state = state.copyWith(isAuthenticated: false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to logout. Please try again later.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});