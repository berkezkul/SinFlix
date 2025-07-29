import '../../services/navigation_service.dart';
import '../constants/routes.dart';

/// NavigationService için helper extension'lar
extension NavigationHelper on NavigationService {
  // Quick navigation methods
  void goToLogin() => pushNamedAndClearStack(AppRoutes.login);
  void goToRegister() => pushNamed(AppRoutes.register);
  void goToProfilePhoto() => pushNamed(AppRoutes.profilePhoto);
  void goToHome() => pushNamedAndClearStack(AppRoutes.home);
  void goToMovies() => pushNamed(AppRoutes.movies);
  void goToProfile() => pushNamed(AppRoutes.profile);

  // Authentication flow helpers
  void completeRegistration() => pushReplacementNamed(AppRoutes.profilePhoto);
  void completeLogin() => pushNamedAndClearStack(AppRoutes.home);
  void logout() => pushNamedAndClearStack(AppRoutes.login);

  // Quick feedback methods
  void showSuccess(String message) => showSuccessSnackBar(message);
  void showError(String message) => showErrorSnackBar(message);
  void showWarning(String message) => showWarningSnackBar(message);
  void showInfo(String message) => showSnackBar(message);

  // Loading helpers
  void startLoading([String? message]) => showLoadingDialog(message: message);
  void stopLoading() => hideLoadingDialog();
} 