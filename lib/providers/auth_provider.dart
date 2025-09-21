import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String _errorMessage = '';

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String get errorMessage => _errorMessage;

  // Initialize auth state
  Future<void> initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      
      if (userData != null) {
        // In a real app, you'd parse the JSON and validate the token
        _isLoggedIn = true;
        // For demo purposes, create a sample user
        _currentUser = User(
          id: '1',
          name: 'Patient Demo',
          phone: '+91 98765 43210',
          email: 'patient@example.com',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      _errorMessage = 'Failed to initialize authentication';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Login with phone number
  Future<bool> loginWithPhone(String phone, String otp) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, accept any 6-digit OTP
      if (otp.length == 6 && phone.isNotEmpty) {
        _currentUser = User(
          id: '1',
          name: 'Patient Demo',
          phone: phone,
          email: 'patient@example.com',
          address: 'Nabha, Punjab',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        _isLoggedIn = true;
        
        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', _currentUser!.toJson().toString());
        await prefs.setBool('is_logged_in', true);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid phone number or OTP';
      }
    } catch (e) {
      _errorMessage = 'Login failed. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Send OTP
  Future<bool> sendOtp(String phone) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (phone.length >= 10) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid phone number';
      }
    } catch (e) {
      _errorMessage = 'Failed to send OTP. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Update user profile
  Future<bool> updateUserProfile(User updatedUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = updatedUser.copyWith(updatedAt: DateTime.now());
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', _currentUser!.toJson().toString());
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      await prefs.setBool('is_logged_in', false);
      
      _currentUser = null;
      _isLoggedIn = false;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to logout';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}