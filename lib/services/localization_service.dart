import 'package:flutter/material.dart';

/// Geçici localization service - generated file hazır olana kadar
class LocalizationService {
  static LocalizationService? _instance;
  static LocalizationService get instance => _instance ??= LocalizationService._();
  LocalizationService._();

  Locale _currentLocale = const Locale('tr', 'TR');
  
  // Mevcut locale
  Locale get currentLocale => _currentLocale;
  
  // Türkçe mi?
  bool get isTurkish => _currentLocale.languageCode == 'tr';
  
  // İngilizce mi?
  bool get isEnglish => _currentLocale.languageCode == 'en';
  
  // Locale değiştir
  void changeLocale(Locale locale) {
    _currentLocale = locale;
    // TODO: MaterialApp'i rebuild et
  }
  
  // Desteklenen diller
  static const List<Locale> supportedLocales = [
    Locale('tr', 'TR'),
    Locale('en', 'US'),
  ];
  
  // Geçici string'ler - generated file hazır olana kadar
  static final Map<String, Map<String, String>> _strings = {
    'tr': {
             // Auth
       'auth_login': 'Giriş Yap',
       'auth_register': 'Kayıt Ol',
       'auth_email': 'E-posta',
       'auth_password': 'Şifre',
       'auth_passwordAgain': 'Şifre Tekrar',
       'auth_name': 'Ad Soyad',
       'auth_forgotPassword': 'Şifreni mi unuttun?',
       'auth_agreement': 'Kullanım koşullarını kabul ediyorum',
       'auth_agreementDesc': 'Devam ederek Kullanım Koşulları ve Gizlilik Politikası\'nı kabul etmiş olursunuz.',
       'auth_or': 'veya',
       'auth_loginSuccess': 'Giriş başarılı!',
       'auth_loginError': 'E-posta veya şifre hatalı!',
       'auth_registerSuccess': 'Kayıt başarılı!',
       'auth_welcomeDesc': 'Film keyfini çıkartmak için doğru adrestesin!',
       'auth_registerDesc': 'SinFlix ile film deneyiminizi yükseltin!',
       'auth_noAccountQuestion': 'Bir hesabın yok mu? ',
       'auth_hasAccountQuestion': 'Zaten hesabın var mı? ',
       'auth_registerNow': 'Şimdi Kaydol',
       'auth_agreementPrefix': 'Kullanıcı sözleşmesini ',
       'auth_agreementSuffix': 'Bu sözleşmeyi okuyarak devam ediniz lütfen.',
      
      // Profile
      'profile_title': 'Profil Detayı',
      'profile_addPhoto': 'Fotoğraf Ekle',
      'profile_favoriteMovies': 'Beğendiğim Filmler',
      'profile_noFavorites': 'Henüz favori film yok',
      'profile_photoUploadTitle': 'Profil Fotoğrafı Ekle',
      'profile_photoUploadDesc': 'Profil fotoğrafınızı yükleyerek hesabınızı kişiselleştirin',
      'profile_photoSelectFromGallery': 'Galeriden Seç',
      'profile_photoContinue': 'Devam Et',
      'profile_photoUploadSuccess': 'Profil fotoğrafı başarıyla yüklendi!',
      'profile_photoTooBig': '📷 Fotoğraf çok büyük!\n\nLütfen daha küçük bir fotoğraf seçin veya fotoğrafınızı sıkıştırın.\n\n💡 İpucu: Telefonunuzdan çekilmiş normal fotoğraflar genelde uygun boyuttadır.',
      
      // Movies
      'movies_title': 'Filmler',
      'movies_addToFavorites': 'Favorilere Ekle',
      'movies_removeFromFavorites': 'Favorilerden Çıkar',
      'movies_loadingMore': 'Daha fazla film yükleniyor...',
      'movies_endOfList': 'Tüm filmler yüklendi',
      'movies_refreshError': 'Filmler yenilenemedi',
      'movies_loadError': 'Filmler yüklenemedi',
      
      // Movie Detail
      'movieDetail_plot': 'Konu',
      'movieDetail_movieInfo': 'Film Bilgileri',
      'movieDetail_castCrew': 'Oyuncular ve Ekip',
      'movieDetail_awards': 'Ödüller ve Başarılar',
      'movieDetail_genre': 'Tür',
      'movieDetail_runtime': 'Süre',
      'movieDetail_released': 'Yayın Tarihi',
      'movieDetail_rated': 'Yaş Sınırı',
      'movieDetail_language': 'Dil',
      'movieDetail_country': 'Ülke',
      'movieDetail_director': 'Yönetmen',
      'movieDetail_writer': 'Yazar',
      'movieDetail_actors': 'Oyuncular',
      'movieDetail_notSpecified': 'Belirtilmemiş',
      
      // Navigation
      'nav_home': 'Anasayfa',
      'nav_profile': 'Profil',
      'nav_movies': 'Filmler',
      
      // Home
      'home_discoverMovies': 'Tüm Filmleri Keşfet',
      
      // Offer
      'offer_limitedOffer': 'Sınırlı Teklif',
      'offer_subtitle': 'Jeton paketini seçerek bonus\nkazanın ve yeni bölümlerin kilidini açın!',
      'offer_yourBonuses': 'Alacağınız Bonuslar',
      'offer_premiumAccount': 'Premium\nHesap',
      'offer_moreMatches': 'Daha\nFazla Eşleşme',
      'offer_putForward': 'Öne\nÇıkarma',
      'offer_moreBegeniler': 'Daha\nFazla Beğeni',
      'offer_selectPackage': 'Kilidi açmak için bir jeton paketi seçin',
      'offer_seeAllTokens': 'Tüm Jetonları Gör',
      'offer_weeklyPrice': 'Başına haftalık',
      'offer_tokens': 'Jeton',
      
      // Common
      'common_loading': 'Yükleniyor...',
      'common_error': 'Hata oluştu',
      'common_success': 'Başarılı!',
      'common_cancel': 'İptal',
      'common_ok': 'Tamam',
      'common_retry': 'Tekrar Dene',
    },
    'en': {
             // Auth
       'auth_login': 'Login',
       'auth_register': 'Register',
       'auth_email': 'Email',
       'auth_password': 'Password',
       'auth_passwordAgain': 'Password Again',
       'auth_name': 'Full Name',
       'auth_forgotPassword': 'Forgot your password?',
       'auth_agreement': 'I accept the terms of use',
       'auth_agreementDesc': 'By continuing, you accept the Terms of Use and Privacy Policy.',
       'auth_or': 'or',
       'auth_loginSuccess': 'Login successful!',
       'auth_loginError': 'Email or password is incorrect!',
       'auth_registerSuccess': 'Registration successful!',
       'auth_welcomeDesc': 'You\'re in the right place to enjoy movies!',
       'auth_registerDesc': 'Elevate your movie experience with SinFlix!',
       'auth_noAccountQuestion': 'Don\'t have an account? ',
       'auth_hasAccountQuestion': 'Already have an account? ',
       'auth_registerNow': 'Register Now',
       'auth_agreementPrefix': 'I have read the user agreement ',
       'auth_agreementSuffix': 'Please read this agreement before continuing.',
      
      // Profile
      'profile_title': 'Profile Details',
      'profile_addPhoto': 'Add Photo',
      'profile_favoriteMovies': 'Favorite Movies',
      'profile_noFavorites': 'No favorite movies yet',
      'profile_photoUploadTitle': 'Add Profile Photo',
      'profile_photoUploadDesc': 'Personalize your account by uploading your profile photo',
      'profile_photoSelectFromGallery': 'Select from Gallery',
      'profile_photoContinue': 'Continue',
      'profile_photoUploadSuccess': 'Profile photo uploaded successfully!',
      'profile_photoTooBig': '📷 Photo is too big!\n\nPlease select a smaller photo or compress your photo.\n\n💡 Tip: Normal photos taken from your phone are usually suitable.',
      
      // Movies
      'movies_title': 'Movies',
      'movies_addToFavorites': 'Add to Favorites',
      'movies_removeFromFavorites': 'Remove from Favorites',
      'movies_loadingMore': 'Loading more movies...',
      'movies_endOfList': 'All movies loaded',
      'movies_refreshError': 'Could not refresh movies',
      'movies_loadError': 'Could not load movies',
      
      // Movie Detail
      'movieDetail_plot': 'Plot',
      'movieDetail_movieInfo': 'Movie Information',
      'movieDetail_castCrew': 'Cast & Crew',
      'movieDetail_awards': 'Awards & Achievements',
      'movieDetail_genre': 'Genre',
      'movieDetail_runtime': 'Runtime',
      'movieDetail_released': 'Release Date',
      'movieDetail_rated': 'Rated',
      'movieDetail_language': 'Language',
      'movieDetail_country': 'Country',
      'movieDetail_director': 'Director',
      'movieDetail_writer': 'Writer',
      'movieDetail_actors': 'Actors',
      'movieDetail_notSpecified': 'Not specified',
      
      // Navigation
      'nav_home': 'Home',
      'nav_profile': 'Profile',
      'nav_movies': 'Movies',
      
      // Home
      'home_discoverMovies': 'Discover All Movies',
      
      // Offer
      'offer_limitedOffer': 'Limited Offer',
      'offer_subtitle': 'Choose a token package to earn bonuses\nand unlock new episodes!',
      'offer_yourBonuses': 'Your Bonuses',
      'offer_premiumAccount': 'Premium\nAccount',
      'offer_moreMatches': 'More\nMatches',
      'offer_putForward': 'Put\nForward',
      'offer_moreBegeniler': 'More\nLikes',
      'offer_selectPackage': 'Select a token package to unlock',
      'offer_seeAllTokens': 'See All Tokens',
      'offer_weeklyPrice': 'Per week',
      'offer_tokens': 'Tokens',
      
      // Common
      'common_loading': 'Loading...',
      'common_error': 'An error occurred',
      'common_success': 'Success!',
      'common_cancel': 'Cancel',
      'common_ok': 'OK',
      'common_retry': 'Retry',
    },
  };
  
  // String getirme metodu
  String getString(String key, [BuildContext? context]) {
    final locale = context != null 
        ? Localizations.localeOf(context).languageCode
        : _currentLocale.languageCode;
    
    return _strings[locale]?[key] ?? _strings['tr']?[key] ?? key;
  }
}

/// Global localization helper
final localization = LocalizationService.instance;

/// Extension for easy string access
extension LocalizationExtension on BuildContext {
  String l(String key) {
    return localization.getString(key, this);
  }
} 