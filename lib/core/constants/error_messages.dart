/// User-friendly error messages in English
class ErrorMessages {
  // Network errors
  static const String networkError = 'Check your internet connection';
  static const String serverError = 'An error occurred, please try again later';
  static const String timeoutError = 'Connection timed out, please try again';

  // Authentication errors
  static const String invalidCredentials = 'The data entered is incorrect';
  static const String userNotFound = 'User not found';
  static const String emailAlreadyExists = 'Email is already registered';
  static const String phoneAlreadyExists = 'Phone number is already registered';
  static const String weakPassword = 'Password is too weak';
  static const String invalidOtp = 'The code entered is incorrect';
  static const String otpExpired = 'The code has expired';

  // Validation errors
  static const String emptyField = 'This field is required';
  static const String invalidEmail = 'Email is invalid';
  static const String invalidPhone = 'Phone number is invalid';
  static const String passwordMismatch = 'Passwords do not match';

  // Success messages
  static const String loginSuccess = 'Logged in successfully';
  static const String registerSuccess = 'Account created successfully';
  static const String updateSuccess = 'Updated successfully';
  static const String deleteSuccess = 'Deleted successfully';
  static const String addSuccess = 'Added successfully';

  /// Get user-friendly message from technical error
  static String getFriendlyMessage(String technicalMessage) {
    final lowerMessage = technicalMessage.toLowerCase();

    // Network errors
    if (lowerMessage.contains('network') ||
        lowerMessage.contains('internet') ||
        lowerMessage.contains('connection')) {
      return networkError;
    }

    // Server errors
    if (lowerMessage.contains('500') ||
        lowerMessage.contains('server') ||
        lowerMessage.contains('internal')) {
      return serverError;
    }

    // Timeout errors
    if (lowerMessage.contains('timeout') ||
        lowerMessage.contains('timed out')) {
      return timeoutError;
    }

    // Authentication errors
    if (lowerMessage.contains('invalid credentials') ||
        lowerMessage.contains('wrong password') ||
        lowerMessage.contains('incorrect')) {
      return invalidCredentials;
    }

    if (lowerMessage.contains('user not found') ||
        lowerMessage.contains('not found')) {
      return userNotFound;
    }

    if (lowerMessage.contains('email already') ||
        lowerMessage.contains('email exists')) {
      return emailAlreadyExists;
    }

    if (lowerMessage.contains('phone already') ||
        lowerMessage.contains('phone exists')) {
      return phoneAlreadyExists;
    }

    if (lowerMessage.contains('weak password')) {
      return weakPassword;
    }

    if (lowerMessage.contains('invalid otp') ||
        lowerMessage.contains('wrong otp')) {
      return invalidOtp;
    }

    if (lowerMessage.contains('otp expired') ||
        lowerMessage.contains('code expired')) {
      return otpExpired;
    }

    // If no match, return the original message
    return technicalMessage;
  }
}
