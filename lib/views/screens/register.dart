import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/register/register_bloc.dart';
import '../../blocs/register/register_event.dart';
import '../../blocs/register/register_state.dart';
import '../../repositories/user_repository.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/constants/icons.dart';
import 'add_profile_photo.dart';
import '../../utils/helpers/token_storage.dart';
import '../../l10n/generated/app_localizations.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RegisterBloc()),
        BlocProvider(create: (_) => AuthBloc(UserRepository())),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthSuccess) {
            await TokenStorage.saveToken(state.token);
            // Navigation Service zaten AuthBloc'da handle ediliyor
            // Burada tekrar yapmaya gerek yok
          } else if (state is AuthFailure) {
            // Navigation Service zaten AuthBloc'da handle ediliyor
            // Burada tekrar yapmaya gerek yok
          }
        },
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
                    final authState = context.watch<AuthBloc>().state;
                    final isLoading = state.isLoading || authState is AuthLoading;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.common_welcome,
                                                      style: AppTextStyles.headline,
                            textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.auth_registerDesc,
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
                            hintText: AppLocalizations.of(context)!.auth_name,
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
                            hintText: AppLocalizations.of(context)!.auth_email,
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
                            hintText: AppLocalizations.of(context)!.auth_password,
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
                            hintText: AppLocalizations.of(context)!.auth_passwordAgain,
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
                                  text: AppLocalizations.of(context)!.auth_agreementPrefix,
                                  style: AppTextStyles.caption,
                                  children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)!.auth_agreement,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " ${AppLocalizations.of(context)!.auth_agreementSuffix}",
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
                            onPressed: isLoading
                                ? null
                                : () async {
                                    // Önce local validasyon
                                    if (state.name.isEmpty ||
                                        state.email.isEmpty ||
                                        state.password.isEmpty ||
                                        state.passwordAgain.isEmpty) {
                                      bloc.add(RegisterSubmitted()); // Hata state'i için
                                      return;
                                    }
                                    if (state.password != state.passwordAgain) {
                                      bloc.add(RegisterSubmitted()); // Hata state'i için
                                      return;
                                    }
                                    if (!state.agreementChecked) {
                                      bloc.add(RegisterSubmitted()); // Hata state'i için
                                      return;
                                    }
                                    // API'ye istek AuthBloc ile
                                    await TokenStorage.deleteToken(); // Eski token'ı temizle
                                    context.read<AuthBloc>().add(
                                      RegisterRequested(
                                        state.name,
                                        state.email,
                                        state.password,
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                                : Text(
                              AppLocalizations.of(context)!.auth_registerNow,
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
                              AppLocalizations.of(context)!.auth_hasAccountQuestion,
                              style: AppTextStyles.caption,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(); // Login ekranına dön
                              },
                              child: Text(
                                AppLocalizations.of(context)!.auth_login,
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