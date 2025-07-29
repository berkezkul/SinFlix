import 'package:flutter/material.dart';

class NavigationService {
  // Singleton pattern
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  // Global navigator key
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Context olmadan navigator'a erişim
  NavigatorState? get navigator => navigatorKey.currentState;
  BuildContext? get context => navigatorKey.currentContext;

  /// Context olmadan sayfa geçişi
  Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigator?.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Context olmadan sayfa değiştirme (geri dönüş yok)
  Future<T?>? pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return navigator?.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Context olmadan tüm stack'i temizleyip yeni sayfa
  Future<T?>? pushNamedAndClearStack<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigator?.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Context olmadan geri dönüş
  void pop<T extends Object?>([T? result]) {
    return navigator?.pop<T>(result);
  }

  /// Context olmadan belirli route'a kadar geri dönüş
  void popUntil(String routeName) {
    return navigator?.popUntil(ModalRoute.withName(routeName));
  }

  /// Geri dönebilir mi kontrolü
  bool canPop() {
    return navigator?.canPop() ?? false;
  }

  /// Context olmadan SnackBar gösterme
  void showSnackBar(
    String message, {
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context!);
    scaffoldMessenger.clearSnackBars();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor ?? Colors.white),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

  /// Warning snackbar
  void showWarningSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }

  /// Context olmadan Dialog gösterme
  Future<T?> showAppDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context!,
      barrierDismissible: barrierDismissible,
      builder: (context) => dialog,
    );
  }

  /// Context olmadan Bottom Sheet gösterme
  Future<T?> showAppBottomSheet<T>({
    required Widget bottomSheet,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context!,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => bottomSheet,
    );
  }

  /// Loading dialog gösterme
  void showLoadingDialog({String? message}) {
    showAppDialog(
      dialog: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message),
            ],
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Loading dialog kapatma
  void hideLoadingDialog() {
    if (canPop()) {
      pop();
    }
  }
} 