import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../blocs/offer/offer_bloc.dart';
import '../../blocs/offer/offer_event.dart';
import '../../blocs/offer/offer_state.dart';
import '../../repositories/user_repository.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/constants/dimens.dart';
import '../../utils/constants/offer_assets.dart';
import '../../repositories/movie_repository.dart';
import '../../views/screens/movie_detail.dart';
import '../../l10n/generated/app_localizations.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _currentIndex = 1; // Profil sekmesi aktif

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfileBloc(UserRepository(), MovieRepository())..add(LoadProfile())),
        BlocProvider(create: (_) => OfferBloc()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true, // Bu AppBar title'ını ortalar
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            AppLocalizations.of(context)!.profile_title,
            style: AppTextStyles.headline.copyWith(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          actions: [
            BlocBuilder<OfferBloc, OfferState>(
              builder: (context, offerState) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: TextButton(
                    onPressed: () {
                      context.read<OfferBloc>().add(ShowOffer());
                      _showOfferBottomSheet(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.offer_limitedOffer,
                      style: AppTextStyles.button.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.red),
              );
            }
            
            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: AppTextStyles.body.copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(LoadProfile());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                      ),
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              );
            }
            
            if (state is ProfileLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kullanıcı bilgileri kartı
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          // Profil fotoğrafı
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border, width: 2),
                            ),
                            child: ClipOval(
                              child: user.photoUrl.isNotEmpty
                                  ? Image.network(
                                      user.photoUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: AppColors.border,
                                          child: const Icon(
                                            Icons.person,
                                            color: AppColors.lightGreyText,
                                            size: 30,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: AppColors.border,
                                      child: const Icon(
                                        Icons.person,
                                        color: AppColors.lightGreyText,
                                        size: 30,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Kullanıcı bilgileri
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: AppTextStyles.headline.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.email,
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.lightGreyText,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Fotoğraf ekle butonu
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.profile_addPhoto,
                              style: AppTextStyles.button.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Beğendiğim Filmler başlığı
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.profile_favoriteMovies,
                          style: AppTextStyles.headline.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        
                        // Yenileme butonu
                        GestureDetector(
                          onTap: () {
                            context.read<ProfileBloc>().add(LoadFavoriteMovies());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.refresh,
                              color: AppColors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Film grid'i
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: state.isLoadingFavorites 
                          ? 4 // Loading state için placeholder
                          : state.favoriteMovies.isEmpty
                              ? 1 // Boş state için
                              : state.favoriteMovies.length,
                      itemBuilder: (context, index) {
                        // Loading state
                        if (state.isLoadingFavorites) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.inputBackground,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.red,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        }
                        
                        // Boş state
                        if (state.favoriteMovies.isEmpty) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.inputBackground,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  color: AppColors.lightGreyText,
                                  size: 48,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppLocalizations.of(context)!.profile_noFavorites,
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.lightGreyText,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }
                        
                        // Gerçek favori filmler
                        final movie = state.favoriteMovies[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MovieDetailView(movie: movie),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.inputBackground,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Film posteri
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      color: AppColors.border,
                                      image: movie.posterUrl.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(movie.posterUrl),
                                              fit: BoxFit.cover,
                                              onError: (exception, stackTrace) {},
                                            )
                                          : null,
                                    ),
                                    child: movie.posterUrl.isEmpty
                                        ? const Icon(
                                            Icons.movie,
                                            color: AppColors.lightGreyText,
                                            size: 30,
                                          )
                                        : null,
                                  ),
                                ),
                                
                                // Film bilgileri
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.title,
                                        style: AppTextStyles.body.copyWith(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        movie.year.isNotEmpty ? movie.year : AppLocalizations.of(context)!.movieDetail_notSpecified,
                                        style: AppTextStyles.body.copyWith(
                                          color: AppColors.lightGreyText,
                                          fontSize: 10,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            
            return const SizedBox();
          },
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
                    Navigator.of(context).pushReplacementNamed('/home');
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
                          'Anasayfa',
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
            ],
          ),
        ),
      ),
    );
  }

  void _showOfferBottomSheet(BuildContext context) {
    final offerBloc = context.read<OfferBloc>(); // Parent context'ten al
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.offer_bg,
      builder: (modalContext) => BlocProvider.value(
        value: offerBloc, // Direkt instance geçir
        child: Container(
          height: MediaQuery.of(context).size.height * 0.82, // Biraz daha küçük yap
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: [
                Color(0xFF8B1538),
                Color(0xFF4A0E1F),
                Color(0xFF2C0912),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Drag Handle ve Başlık
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      AppLocalizations.of(context)!.offer_limitedOffer,
                      style: AppTextStyles.headline.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),


            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: Text(
                  AppLocalizations.of(context).offer_subtitle,
                  textAlign: TextAlign.center, // Metin zaten kendi içinde merkezlenmiş
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ),
            ),],
                ),
              ),
              
              // Alacağınız Bonuslar Kısmı
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.offer_yourBonuses,
                      style: AppTextStyles.headline.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 4 bonus item yan yana - responsive
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: _buildBonusItem(OfferAssets.premiumAccount, AppLocalizations.of(context)!.offer_premiumAccount)),
                        Expanded(child: _buildBonusItem(OfferAssets.moreMatches, AppLocalizations.of(context)!.offer_moreMatches)),
                        Expanded(child: _buildBonusItem(OfferAssets.putForward, AppLocalizations.of(context)!.offer_putForward)),
                        Expanded(child: _buildBonusItem(OfferAssets.moreMatches, AppLocalizations.of(context)!.offer_moreBegeniler)),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Paket Seçimi
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.offer_selectPackage,
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                                            BlocBuilder<OfferBloc, OfferState>(
                        builder: (context, state) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Ana paket kartları
                              Row(
                                children: [
                                  _buildModernPackageCard(
                                    context: context,
                                    index: 0,
                                    jetonsOld: '200',
                                    jetonsNew: '330',
                                    price: '₺99,99',
                                    discount: '+10%',
                                    discountColor: AppColors.offer_package2,
                                    isSelected: state.selectedPackageIndex == 0,
                                  ),
                                  const SizedBox(width: 12),
                                  _buildModernPackageCard(
                                    context: context,
                                    index: 1,
                                    jetonsOld: '2.000',
                                    jetonsNew: '3.375',
                                    price: '₺799,99',
                                    discount: '+70%',
                                    discountColor: AppColors.offer_package3,
                                    isSelected: state.selectedPackageIndex == 1,
                                  ),
                                  const SizedBox(width: 12),
                                  _buildModernPackageCard(
                                    context: context,
                                    index: 2,
                                    jetonsOld: '1.000',
                                    jetonsNew: '1.350',
                                    price: '₺399,99',
                                    discount: '+35%',
                                    discountColor: AppColors.offer_package2,
                                    isSelected: state.selectedPackageIndex == 2,
                                  ),
                                ],
                              ),
                              
                              // Overlay discount badges
                              _buildDiscountBadgeOverlay(0, '+10%', AppColors.offer_package2),
                              _buildDiscountBadgeOverlay(1, '+70%', AppColors.offer_package2),
                              _buildDiscountBadgeOverlay(2, '+35%', AppColors.offer_package2),
                            ],
                          );
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Satın al butonu
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Paket satın alındı!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.offer_seeAllTokens,
                            style: AppTextStyles.button.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBonusItem(String assetPath, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0), // Daha az padding
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,  // Daha küçük boyut (4 tane yan yana sığması için)
            height: 42, // Daha küçük boyut
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.bonus,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 6,
                  spreadRadius: 0,
                  offset: const Offset(0, 0), // Inner shadow effect için
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 3), // Outer shadow için depth
                ),
              ],
            ),
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              // color: Colors.white, // Bu satırı kaldırdık - orijinal renkler korunacak
            ),
          ),
          const SizedBox(height: 4),
          // Responsive text with constraints
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 60), // Daha dar
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontSize: 9, // Daha küçük font
                fontWeight: FontWeight.w600,
                height: 1.1, // Daha sıkı line height
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountBadgeOverlay(int index, String discount, Color color) {
    // Her paket için yaklaşık pozisyon hesapla (Expanded widget'lar için)
    double screenWidth = MediaQuery.of(context).size.width - 40; // Padding çıkart
    double cardWidth = (screenWidth - 24) / 3; // 3 card, 2x12 gap
    double leftPosition = 20 + (index * (cardWidth + 12)) + 12; // Her kartın sol kenarından biraz içeride
    
    return Positioned(
      top: -8,
      left: leftPosition,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          discount,
          style: AppTextStyles.body.copyWith(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildModernPackageCard({
    required BuildContext context,
    required int index,
    required String jetonsOld,
    required String jetonsNew,
    required String price,
    required String discount,
    required Color discountColor,
    required bool isSelected,
  }) {
    // Gradient renklerini belirle
    List<Color> gradientColors;
    if (index == 1) {
      // 2. paket (ortadaki): offer_package2 → offer_package3
      gradientColors = [AppColors.offer_package2, AppColors.offer_package3];
    } else {
      // 1. ve 3. paket: offer_package1 → offer_package2
      gradientColors = [AppColors.offer_package1, AppColors.offer_package2];
    }
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<OfferBloc>().add(SelectPackage(index));
        },
        child: Container(
          height: 250, // Paket kartlarının yüksekliğini artırdık
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Ana içerik
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // İçeriği dağıt
                  children: [
                    // Üst kısım
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Üstte boşluk bırak discount badge için
                        const SizedBox(height: 20),
              
              Text(
                jetonsOld,
                style: AppTextStyles.headline.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.white.withOpacity(0.6),
                  decorationThickness: 2,
                ),
              ),
              
              Text(
                jetonsNew,
                style: AppTextStyles.headline.copyWith(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900, // Black weight (900) - Figma'daki gibi
                ),
              ),
              
                                      Text(
                          'Jeton',
                          style: AppTextStyles.body.copyWith(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    
                    // Alt kısım - Fiyat bilgileri
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          price,
                          style: AppTextStyles.headline.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        Text(
                          AppLocalizations.of(context)!.offer_weeklyPrice,
                          style: AppTextStyles.body.copyWith(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              
            ],
          ),
        ),
      ),
    );
  }
} 