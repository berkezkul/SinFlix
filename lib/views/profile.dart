import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/profile/profile_bloc.dart';
import '../blocs/profile/profile_event.dart';
import '../blocs/profile/profile_state.dart';
import '../repositories/user_repository.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/dimens.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _currentIndex = 1; // Profil sekmesi aktif

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(UserRepository())..add(LoadProfile()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
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
            BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileInitial) {
                  // Logout başarılı, login sayfasına git
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: TextButton(
                onPressed: () {
                  context.read<ProfileBloc>().add(LogoutRequested());
                },
                child: Text(
                  'Çıkış Takibi',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.red,
                    fontSize: 14,
                  ),
                ),
              ),
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
} 