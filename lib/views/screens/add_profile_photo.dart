import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../blocs/profile_photo/profile_photo_bloc.dart';
import '../../blocs/profile_photo/profile_photo_event.dart';
import '../../blocs/profile_photo/profile_photo_state.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/constants/icons.dart';

class ProfilePhotoView extends StatelessWidget {
  const ProfilePhotoView({super.key});

  static bool _isPickingImage = false;

  Future<void> _pickImage(BuildContext context) async {
    if (_isPickingImage) return; // Zaten image picker açıksa çık
    _isPickingImage = true;
    
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        context.read<ProfilePhotoBloc>().add(PhotoSelected(File(picked.path)));
      }
    } finally {
      _isPickingImage = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfilePhotoBloc(),
      child: BlocListener<ProfilePhotoBloc, ProfilePhotoState>(
        listener: (context, state) async {
          if (state.isLoading == false && state.error == null && state.photoUrl != null) {
            // Navigation Service zaten ProfilePhotoBloc'da handle ediliyor
            // Burada tekrar yapmaya gerek yok
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
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
          ),
          body: SafeArea(
            child: BlocBuilder<ProfilePhotoBloc, ProfilePhotoState>(
              builder: (context, state) {
                final bloc = context.read<ProfilePhotoBloc>();
                return Column(

                  children: [

                    // ... (UI kodun değişmeden devam edebilir)
                    GestureDetector(
                      onTap: state.isLoading ? null : () => _pickImage(context),
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.border,
                            width: 1,
                          ),
                        ),
                        child: state.photo == null
                            ? Center(
                          child: Image.asset(
                            AppIcons.add,
                            width: 32,
                            height: 32,
                            color: AppColors.border,
                          ),
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.file(
                            state.photo!,
                            fit: BoxFit.cover,
                            width: 140,
                            height: 140,
                          ),
                        ),
                      ),
                    ),
                    if (state.error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        state.error!,
                        style: AppTextStyles.caption.copyWith(color: AppColors.error),
                      ),
                    ],
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                            bloc.add(ContinuePressed());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: state.isLoading
                              ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                              : const Text(
                            "Devam Et",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}