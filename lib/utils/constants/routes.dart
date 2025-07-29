class AppRoutes {
  // Private constructor - bu class instance'lanmayacak
  AppRoutes._();

  // Route constants
  static const String login = '/login';
  static const String register = '/register';
  static const String profilePhoto = '/profile-photo';
  static const String home = '/home';
  static const String movies = '/movies';
  static const String profile = '/profile';
  static const String movieDetail = '/movie-detail';

  // Route listesi (validation için)
  static const List<String> allRoutes = [
    login,
    register,
    profilePhoto,
    home,
    movies,
    profile,
    movieDetail,
  ];

  // Route validation
  static bool isValidRoute(String route) {
    return allRoutes.contains(route);
  }

  // Route hierarchy (hangi route'dan hangi route'a gidilebilir)
  static const Map<String, List<String>> routeHierarchy = {
    login: [register, home, profilePhoto],
    register: [login, profilePhoto],
    profilePhoto: [home],
    home: [profile, movies, movieDetail],
    movies: [home, profile, movieDetail],
    profile: [home, movies],
    movieDetail: [home, movies, profile],
  };

  // Public routes (login gerektirmez)
  static const List<String> publicRoutes = [
    login,
    register,
  ];

  // Protected routes (login gerektirir)
  static const List<String> protectedRoutes = [
    profilePhoto,
    home,
    movies,
    profile,
    movieDetail,
  ];

  // Route isimleri (display için)
  static const Map<String, String> routeNames = {
    login: 'Giriş',
    register: 'Kayıt',
    profilePhoto: 'Profil Fotoğrafı',
    home: 'Ana Sayfa',
    movies: 'Filmler',
    profile: 'Profil',
    movieDetail: 'Film Detayı',
  };

  // Helper methods
  static String getRouteName(String route) {
    return routeNames[route] ?? 'Bilinmeyen Sayfa';
  }

  static bool isPublicRoute(String route) {
    return publicRoutes.contains(route);
  }

  static bool isProtectedRoute(String route) {
    return protectedRoutes.contains(route);
  }

  static bool canNavigateFrom(String fromRoute, String toRoute) {
    return routeHierarchy[fromRoute]?.contains(toRoute) ?? false;
  }
} 