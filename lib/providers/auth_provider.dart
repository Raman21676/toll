import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  
  User? _firebaseUser;
  User? get firebaseUser => _firebaseUser;
  
  UserModel? get currentUser => _userService.currentUser;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  bool get isAuthenticated => _firebaseUser != null;
  bool get isEmailVerified => _firebaseUser?.emailVerified ?? false;
  
  // Initialize and listen to auth state
  AuthProvider() {
    _authService.authStateChanges.listen((User? user) async {
      _firebaseUser = user;
      if (user != null) {
        await _userService.getUserProfile(user.uid);
      } else {
        _userService.clearCurrentUser();
      }
      notifyListeners();
    });
  }
  
  // Sign up
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String nickname,
    String? phoneNumber,
    String? address,
    required List<String> interests,
    required List<String> hobbies,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      // Create Firebase Auth user
      final result = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );
      
      if (result['success']) {
        final user = result['user'] as User?;
        if (user != null) {
          // Create user profile in Firestore
          final userModel = UserModel(
            uid: user.uid,
            name: name,
            nickname: nickname,
            email: email,
            phoneNumber: phoneNumber,
            address: address,
            interests: interests,
            hobbies: hobbies,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          
          await _userService.createUserProfile(userModel);
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['error'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Sign in
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final result = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      
      if (result['success']) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['error'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    _userService.clearCurrentUser();
    notifyListeners();
  }
  
  // Send password reset
  Future<bool> sendPasswordReset(String email) async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _authService.sendPasswordResetEmail(email);
    
    _isLoading = false;
    notifyListeners();
    
    return result['success'];
  }
  
  // Resend verification email
  Future<bool> resendVerificationEmail() async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _authService.resendVerificationEmail();
    
    _isLoading = false;
    notifyListeners();
    
    return result['success'];
  }
  
  // Reload user (for email verification check)
  Future<void> reloadUser() async {
    await _authService.reloadUser();
    _firebaseUser = _authService.currentUser;
    notifyListeners();
  }
  
  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
