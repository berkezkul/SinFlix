import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// Uygulama adı
  ///
  /// In tr, this message translates to:
  /// **'SinFlix'**
  String get appName;

  /// Genel hoş geldiniz mesajı
  ///
  /// In tr, this message translates to:
  /// **'Hoş Geldiniz'**
  String get common_welcome;

  /// Yükleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor...'**
  String get common_loading;

  /// Genel hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Hata oluştu'**
  String get common_error;

  /// Başarı mesajı
  ///
  /// In tr, this message translates to:
  /// **'Başarılı!'**
  String get common_success;

  /// İptal butonu
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get common_cancel;

  /// Tamam butonu
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get common_ok;

  /// Tekrar dene butonu
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Dene'**
  String get common_retry;

  /// Geri dön butonu
  ///
  /// In tr, this message translates to:
  /// **'Geri Dön'**
  String get common_back;

  /// Giriş yap butonu
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get auth_login;

  /// Kayıt ol butonu
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get auth_register;

  /// E-posta alanı
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get auth_email;

  /// Şifre alanı
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get auth_password;

  /// Şifre tekrar alanı
  ///
  /// In tr, this message translates to:
  /// **'Şifre Tekrar'**
  String get auth_passwordAgain;

  /// Ad soyad alanı
  ///
  /// In tr, this message translates to:
  /// **'Ad Soyad'**
  String get auth_name;

  /// Şifremi unuttum linki
  ///
  /// In tr, this message translates to:
  /// **'Şifreni mi unuttun?'**
  String get auth_forgotPassword;

  /// Sözleşme kabul checkbox'ı
  ///
  /// In tr, this message translates to:
  /// **'Kullanım koşullarını kabul ediyorum'**
  String get auth_agreement;

  /// Sözleşme açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Devam ederek Kullanım Koşulları ve Gizlilik Politikası\'nı kabul etmiş olursunuz.'**
  String get auth_agreementDesc;

  /// Login sayfası hoş geldin açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Film keyfini çıkartmak için doğru adrestesin!'**
  String get auth_welcomeDesc;

  /// Register sayfası açıklaması
  ///
  /// In tr, this message translates to:
  /// **'SinFlix ile film deneyiminizi yükseltin!'**
  String get auth_registerDesc;

  /// Hesap olmayan kullanıcılar için soru
  ///
  /// In tr, this message translates to:
  /// **'Bir hesabın yok mu? '**
  String get auth_noAccountQuestion;

  /// Hesabı olan kullanıcılar için soru
  ///
  /// In tr, this message translates to:
  /// **'Zaten hesabın var mı? '**
  String get auth_hasAccountQuestion;

  /// Kayıt ol butonu
  ///
  /// In tr, this message translates to:
  /// **'Şimdi Kaydol'**
  String get auth_registerNow;

  /// Sözleşme metninin başlangıcı
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı sözleşmesini '**
  String get auth_agreementPrefix;

  /// Sözleşme metninin sonu
  ///
  /// In tr, this message translates to:
  /// **'Bu sözleşmeyi okuyarak devam ediniz lütfen.'**
  String get auth_agreementSuffix;

  /// Veya ayırıcı
  ///
  /// In tr, this message translates to:
  /// **'veya'**
  String get auth_or;

  /// Başarılı giriş mesajı
  ///
  /// In tr, this message translates to:
  /// **'Giriş başarılı!'**
  String get auth_loginSuccess;

  /// Giriş hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'E-posta veya şifre hatalı!'**
  String get auth_loginError;

  /// Başarılı kayıt mesajı
  ///
  /// In tr, this message translates to:
  /// **'Kayıt başarılı!'**
  String get auth_registerSuccess;

  /// Oturum dolma mesajı
  ///
  /// In tr, this message translates to:
  /// **'Oturum süresi dolmuş!'**
  String get auth_sessionExpired;

  /// Profil sayfası başlığı
  ///
  /// In tr, this message translates to:
  /// **'Profil Detayı'**
  String get profile_title;

  /// Fotoğraf ekleme butonu
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf Ekle'**
  String get profile_addPhoto;

  /// Favori filmler başlığı
  ///
  /// In tr, this message translates to:
  /// **'Beğendiğim Filmler'**
  String get profile_favoriteMovies;

  /// Favori film yok mesajı
  ///
  /// In tr, this message translates to:
  /// **'Henüz favori film yok'**
  String get profile_noFavorites;

  /// Profil fotoğrafı yükleme başlığı
  ///
  /// In tr, this message translates to:
  /// **'Profil Fotoğrafı Ekle'**
  String get profile_photoUploadTitle;

  /// Profil fotoğrafı açıklama
  ///
  /// In tr, this message translates to:
  /// **'Profil fotoğrafınızı yükleyerek hesabınızı kişiselleştirin'**
  String get profile_photoUploadDesc;

  /// Galeriden fotoğraf seçme
  ///
  /// In tr, this message translates to:
  /// **'Galeriden Seç'**
  String get profile_photoSelectFromGallery;

  /// Devam etme butonu
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get profile_photoContinue;

  /// Fotoğraf yükleme başarı mesajı
  ///
  /// In tr, this message translates to:
  /// **'Profil fotoğrafı başarıyla yüklendi!'**
  String get profile_photoUploadSuccess;

  /// Fotoğraf çok büyük hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'📷 Fotoğraf çok büyük!\\n\\nLütfen daha küçük bir fotoğraf seçin veya fotoğrafınızı sıkıştırın.\\n\\n💡 İpucu: Telefonunuzdan çekilmiş normal fotoğraflar genelde uygun boyuttadır.'**
  String get profile_photoTooBig;

  /// Filmler sayfası başlığı
  ///
  /// In tr, this message translates to:
  /// **'Filmler'**
  String get movies_title;

  /// Favorilere ekleme
  ///
  /// In tr, this message translates to:
  /// **'Favorilere Ekle'**
  String get movies_addToFavorites;

  /// Favorilerden çıkarma
  ///
  /// In tr, this message translates to:
  /// **'Favorilerden Çıkar'**
  String get movies_removeFromFavorites;

  /// Daha fazla film yükleme
  ///
  /// In tr, this message translates to:
  /// **'Daha fazla film yükleniyor...'**
  String get movies_loadingMore;

  /// Film listesi sonu
  ///
  /// In tr, this message translates to:
  /// **'Tüm filmler yüklendi'**
  String get movies_endOfList;

  /// Film yenileme hatası
  ///
  /// In tr, this message translates to:
  /// **'Filmler yenilenemedi'**
  String get movies_refreshError;

  /// Film yükleme hatası
  ///
  /// In tr, this message translates to:
  /// **'Filmler yüklenemedi'**
  String get movies_loadError;

  /// Arama özelliği yakında mesajı
  ///
  /// In tr, this message translates to:
  /// **'Arama özelliği yakında!'**
  String get movies_searchComingSoon;

  /// Film konusu başlığı
  ///
  /// In tr, this message translates to:
  /// **'Konu'**
  String get movieDetail_plot;

  /// Film bilgileri başlığı
  ///
  /// In tr, this message translates to:
  /// **'Film Bilgileri'**
  String get movieDetail_movieInfo;

  /// Oyuncular ve ekip başlığı
  ///
  /// In tr, this message translates to:
  /// **'Oyuncular ve Ekip'**
  String get movieDetail_castCrew;

  /// Ödüller başlığı
  ///
  /// In tr, this message translates to:
  /// **'Ödüller ve Başarılar'**
  String get movieDetail_awards;

  /// Film türü
  ///
  /// In tr, this message translates to:
  /// **'Tür'**
  String get movieDetail_genre;

  /// Film süresi
  ///
  /// In tr, this message translates to:
  /// **'Süre'**
  String get movieDetail_runtime;

  /// Yayın tarihi
  ///
  /// In tr, this message translates to:
  /// **'Yayın Tarihi'**
  String get movieDetail_released;

  /// Yaş sınırı
  ///
  /// In tr, this message translates to:
  /// **'Yaş Sınırı'**
  String get movieDetail_rated;

  /// Film dili
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get movieDetail_language;

  /// Yapım ülkesi
  ///
  /// In tr, this message translates to:
  /// **'Ülke'**
  String get movieDetail_country;

  /// Film yönetmeni
  ///
  /// In tr, this message translates to:
  /// **'Yönetmen'**
  String get movieDetail_director;

  /// Senaryo yazarı
  ///
  /// In tr, this message translates to:
  /// **'Yazar'**
  String get movieDetail_writer;

  /// Film oyuncuları
  ///
  /// In tr, this message translates to:
  /// **'Oyuncular'**
  String get movieDetail_actors;

  /// Bilgi belirtilmemiş
  ///
  /// In tr, this message translates to:
  /// **'Belirtilmemiş'**
  String get movieDetail_notSpecified;

  /// Ana sayfa navigasyon
  ///
  /// In tr, this message translates to:
  /// **'Anasayfa'**
  String get nav_home;

  /// Profil navigasyon
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get nav_profile;

  /// Filmler navigasyon
  ///
  /// In tr, this message translates to:
  /// **'Filmler'**
  String get nav_movies;

  /// Film keşfetme butonu
  ///
  /// In tr, this message translates to:
  /// **'Tüm Filmleri Keşfet'**
  String get home_discoverMovies;

  /// Sınırlı teklif başlığı
  ///
  /// In tr, this message translates to:
  /// **'Sınırlı Teklif'**
  String get offer_limitedOffer;

  /// Teklif açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Jeton paketini seçerek bonus kazanın ve yeni bölümlerin kilidini açın!'**
  String get offer_subtitle;

  /// Bonuslar başlığı
  ///
  /// In tr, this message translates to:
  /// **'Alacağınız Bonuslar'**
  String get offer_yourBonuses;

  /// Premium hesap bonusu
  ///
  /// In tr, this message translates to:
  /// **'Premium Hesap'**
  String get offer_premiumAccount;

  /// Daha fazla eşleşme bonusu
  ///
  /// In tr, this message translates to:
  /// **'Fazla Eşleşme'**
  String get offer_moreMatches;

  /// Öne çıkarma bonusu
  ///
  /// In tr, this message translates to:
  /// **'Öne Çıkarma'**
  String get offer_putForward;

  /// Daha fazla beğeni bonusu
  ///
  /// In tr, this message translates to:
  /// **'Fazla Beğeni'**
  String get offer_moreBegeniler;

  /// Paket seçimi açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Kilidi açmak için bir jeton paketi seçin'**
  String get offer_selectPackage;

  /// Tüm jetonları görme butonu
  ///
  /// In tr, this message translates to:
  /// **'Tüm Jetonları Gör'**
  String get offer_seeAllTokens;

  /// Haftalık fiyat açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Başına haftalık'**
  String get offer_weeklyPrice;

  /// Jeton etiketi
  ///
  /// In tr, this message translates to:
  /// **'Jeton'**
  String get offer_tokens;

  /// Dil değiştirildi mesajı
  ///
  /// In tr, this message translates to:
  /// **'Dil Türkçe olarak değiştirildi'**
  String get language_changed;

  /// İngilizce'ye geçme butonu
  ///
  /// In tr, this message translates to:
  /// **'İngilizce\'ye geç'**
  String get language_changeToEnglish;

  /// Türkçe'ye geçme butonu
  ///
  /// In tr, this message translates to:
  /// **'Türkçe\'ye geç'**
  String get language_changeToTurkish;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
