import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/register/register_bloc.dart';
import '../blocs/register/register_event.dart';
import '../blocs/register/register_state.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/icons.dart';
import 'add_profile_photo.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(32),
              ),
              child: BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  final bloc = context.read<RegisterBloc>();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Hoşgeldiniz",
                        style: AppTextStyles.headline,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Tempus varius a vitae interdum id tortor elementum tristique eleifend at.",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.lightGreyText,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // Ad Soyad
                      TextField(
                        onChanged: (value) => bloc.add(NameChanged(value)),
                        style: AppTextStyles.input,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(AppIcons.user, width: 24, height: 24),
                          ),
                          hintText: "Ad Soyad",
                          hintStyle: AppTextStyles.hint,
                          filled: true,
                          fillColor: AppColors.inputBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.red),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // E-Posta
                      TextField(
                        onChanged: (value) => bloc.add(EmailChanged(value)),
                        style: AppTextStyles.input,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(AppIcons.mail, width: 24, height: 24),
                          ),
                          hintText: "E-Posta",
                          hintStyle: AppTextStyles.hint,
                          filled: true,
                          fillColor: AppColors.inputBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.red),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Şifre
                      TextField(
                        onChanged: (value) => bloc.add(PasswordChanged(value)),
                        obscureText: !state.isPasswordVisible,
                        style: AppTextStyles.input,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(AppIcons.password, width: 24, height: 24),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: AppColors.border,
                            ),
                            onPressed: () => bloc.add(TogglePasswordVisibility()),
                          ),
                          hintText: "Şifre",
                          hintStyle: AppTextStyles.hint,
                          filled: true,
                          fillColor: AppColors.inputBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.red),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Şifre Tekrar
                      TextField(
                        onChanged: (value) => bloc.add(PasswordAgainChanged(value)),
                        obscureText: !state.isPasswordAgainVisible,
                        style: AppTextStyles.input,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(AppIcons.password, width: 24, height: 24),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.isPasswordAgainVisible ? Icons.visibility : Icons.visibility_off,
                              color: AppColors.border,
                            ),
                            onPressed: () => bloc.add(TogglePasswordAgainVisibility()),
                          ),
                          hintText: "Şifre Tekrar",
                          hintStyle: AppTextStyles.hint,
                          filled: true,
                          fillColor: AppColors.inputBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.red),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Kullanıcı Sözleşmesi
                      Row(
                        children: [
                          Checkbox(
                            value: state.agreementChecked,
                            onChanged: (_) => bloc.add(AgreementToggled()),
                            activeColor: AppColors.red,
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "Kullanıcı sözleşmesini ",
                                style: AppTextStyles.caption,
                                children: [
                                  TextSpan(
                                    text: "okudum ve kabul ediyorum.",
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " Bu sözleşmeyi okuyarak devam ediniz lütfen.",
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (state.error != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          state.error!,
                          style: AppTextStyles.caption.copyWith(color: AppColors.error),
                        ),
                      ],
                      const SizedBox(height: 8),
                      // Şimdi Kaydol Butonu
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const ProfilePhotoView()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          /*
                          onPressed: state.isLoading
                              ? null
                              : () => bloc.add(RegisterSubmitted()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),

                           */


                          child: state.isLoading
                              ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                              : Text(
                            "Şimdi Kaydol",
                            style: AppTextStyles.button,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Sosyal Medya Butonları
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _SocialButton(iconPath: AppIcons.google),
                          _SocialButton(iconPath: AppIcons.apple),
                          _SocialButton(iconPath: AppIcons.facebook),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Giriş Yap
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Zaten bir hesabın var mı? ",
                            style: AppTextStyles.caption,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(); // Login ekranına dön
                            },
                            child: Text(
                              "Giriş Yap!",
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String iconPath;
  const _SocialButton({required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.socialButton,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Image.asset(iconPath, width: 24, height: 24),
      ),
    );
  }
}