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
        BlocProvider(create: (_) => ProfileBloc(UserRepository())..add(LoadProfile())),
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
            'Profil Detayı',
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
                      'Sınırlı Teklif',
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
                              'Fotoğraf Ekle',
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
                    Text(
                      'Beğendiğim Filmler',
                      style: AppTextStyles.headline.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
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
                      itemCount: 4, // Şimdilik sabit 4 film
                      itemBuilder: (context, index) {
                        final movies = [
                          {'title': 'Aşk, Evmek, Hayaller', 'subtitle': 'Adam Yapım'},
                          {'title': 'Gece Karanlik', 'subtitle': 'Fox Studios'},
                          {'title': 'Aşk, Evmek, Hayaller', 'subtitle': ''},
                          {'title': 'Gece Karanlik', 'subtitle': ''},
                        ];
                        
                        return Container(
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
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://images.unsplash.com/photo-148959998819${index}?w=300&h=400&fit=crop',
                                      ),
                                      fit: BoxFit.cover,
                                      onError: (exception, stackTrace) {},
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Film bilgileri
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movies[index]['title']!,
                                      style: AppTextStyles.body.copyWith(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (movies[index]['subtitle']!.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        movies[index]['subtitle']!,
                                        style: AppTextStyles.body.copyWith(
                                          color: AppColors.lightGreyText,
                                          fontSize: 10,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
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
                        'Profil',
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
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocProvider.value(
        value: offerBloc, // Direkt instance geçir
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
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
              // Başlık kısmı
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
                      'Sınırlı Teklif',
                      style: AppTextStyles.headline.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    Text(
                      'Jeton paketlerin seçerken bonus\nkazanım ve yeni başlamak istiyorsun.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Avantajlar kısmı
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alacağınız Bonuslar',
                      style: AppTextStyles.headline.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBonusItem(Icons.star, 'Premium\nHesap'),
                        _buildBonusItem(Icons.favorite, 'Daha\nFazla Beğenme'),
                        _buildBonusItem(Icons.arrow_upward, 'Öne\nÇıkarma'),
                        _buildBonusItem(Icons.volunteer_activism, 'Daha\nFazla Beğeni'),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Paket seçimi
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kredi alımak için bir jeton paketi seçin',
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      BlocBuilder<OfferBloc, OfferState>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              _buildPackageCard(0, '200', '330', '£99,99', '10%', state.selectedPackageIndex == 0),
                              const SizedBox(width: 12),
                              _buildPackageCard(1, '2000', '3.375', '£799,99', '75%', state.selectedPackageIndex == 1),
                              const SizedBox(width: 12),
                              _buildPackageCard(2, '1000', '1.350', '£399,99', '35%', state.selectedPackageIndex == 2),
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
                            'Tüm Jetonları Gör',
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

  Widget _buildBonusItem(IconData icon, String title) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildPackageCard(int index, String tokens, String bonus, String price, String discount, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<OfferBloc>().add(SelectPackage(index));
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.red : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              if (discount != '10%') // En soldaki paket için discount yok
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: index == 1 ? Colors.purple : AppColors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    discount,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              
              Text(
                tokens,
                style: AppTextStyles.headline.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              Text(
                bonus,
                style: AppTextStyles.headline.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              Text(
                'Jeton',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                price,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              Text(
                'başına hariçinde',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 