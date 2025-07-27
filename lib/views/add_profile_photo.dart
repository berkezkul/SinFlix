import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../blocs/profile_photo/profile_photo_bloc.dart';
import '../blocs/profile_photo/profile_photo_event.dart';
import '../blocs/profile_photo/profile_photo_state.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/icons.dart';

class ProfilePhotoView extends StatelessWidget {
  const ProfilePhotoView({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      context.read<ProfilePhotoBloc>().add(PhotoSelected(File(picked.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfilePhotoBloc(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<ProfilePhotoBloc, ProfilePhotoState>(
            builder: (context, state) {
              final bloc = context.read<ProfilePhotoBloc>();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.inputBackground,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Profil Detayı",
                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Fotoğraflarınızı Yükleyin",
                    style: AppTextStyles.headline,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Resources out incentivize\nrelaxation floor loss cc.",
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.lightGreyText,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () => _pickImage(context),
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
                          // Başarılı ise yönlendirme burada yapılabilir
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
    );
  }
}