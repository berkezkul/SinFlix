import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/constants/dimens.dart';
import '../../utils/constants/movies.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../blocs/language/language_bloc.dart';
import '../../blocs/language/language_event.dart';
import '../../blocs/language/language_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ana film posteri
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppMovies.gunahkaradam),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Gradient overlay
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.8),
                  Colors.black,
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
          
          // Film bilgileri
          Positioned(
            bottom: 120,
            left: AppDimens.pagePadding,
            right: AppDimens.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SinFlix logosu
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/images/SinFlixLogoWithoutBg.png',
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Film adı
                Text(
                  'Günahkar Adam',
                  style: AppTextStyles.headline.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Film açıklaması
                Text(
                  'Community very territories dogpile so. Last they investigation model...',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.white.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Daha Fazlası butonu
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/movies');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.movie_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.home_discoverMovies,
                          style: AppTextStyles.button.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Dil değiştirme butonu - sağ üst
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: AppDimens.pagePadding,
            child: BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, state) {
                bool isTurkish = true;
                if (state is LanguageLoaded) {
                  isTurkish = state.locale.languageCode == 'tr';
                }
                
                return GestureDetector(
                  onTap: () {
                    final newLocale = isTurkish 
                        ? const Locale('en', 'US')
                        : const Locale('tr', 'TR');
                    
                    context.read<LanguageBloc>().add(ChangeLanguage(newLocale));
                    
                    // Kullanıcıya bilgi ver
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Text(
                              isTurkish ? '🇺🇸' : '🇹🇷',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isTurkish 
                                  ? 'Language changed to English'
                                  : 'Dil Türkçe olarak değiştirildi',
                            ),
                          ],
                        ),
                        backgroundColor: AppColors.success,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isTurkish ? '🇹🇷' : '🇺🇸',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isTurkish ? 'TR' : 'EN',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.swap_horiz,
                          color: AppColors.white.withOpacity(0.7),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Favorileme butonu
          Positioned(
            bottom: 180,
            right: AppDimens.pagePadding,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _isFavorite 
                        ? AppLocalizations.of(context)!.movies_addToFavorites
                        : AppLocalizations.of(context)!.movies_removeFromFavorites,
                    ),
                    backgroundColor: _isFavorite ? AppColors.success : AppColors.error,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? AppColors.red : AppColors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
      
      // Alt navigasyon
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: _currentIndex == 0 
                        ? AppColors.white.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        color: _currentIndex == 0 ? AppColors.white : AppColors.lightGreyText,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.nav_home,
                        style: AppTextStyles.button.copyWith(
                          color: _currentIndex == 0 ? AppColors.white : AppColors.lightGreyText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/profile').then((_) {
                    // Profile'dan geri dönüldüğünde hiçbir şey yapma
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: _currentIndex == 1 
                        ? AppColors.white.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: _currentIndex == 1 ? AppColors.white : AppColors.lightGreyText,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.nav_profile,
                        style: AppTextStyles.button.copyWith(
                          color: _currentIndex == 1 ? AppColors.white : AppColors.lightGreyText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 