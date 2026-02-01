import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';

class SnackBarHelper {
  /// Show success message
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: message,
        type: SnackBarType.success,
      ),
    );
  }

  /// Show error message
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: message,
        type: SnackBarType.error,
      ),
    );
  }

  /// Show warning message
  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: message,
        type: SnackBarType.warning,
      ),
    );
  }

  /// Show info message
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: message,
        type: SnackBarType.info,
      ),
    );
  }
}
