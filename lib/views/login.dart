import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/login/login_bloc.dart';
import '../blocs/login/login_event.dart';
import '../blocs/login/login_state.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/strings.dart';
import '../utils/constants/dimens.dart';
import '../utils/constants/icons.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
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
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  final bloc = context.read<LoginBloc>();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.welcome,
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
                      // E-Posta
                      TextField(
                        onChanged: (value) => bloc.add(EmailChanged(value)),
                        style: AppTextStyles.input,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(AppIcons.mail, width: 24, height: 24),
                          ),
                          hintText: AppStrings.email,
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
                          hintText: AppStrings.password,
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
                      // Şifremi unuttum
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            AppStrings.forgotPassword,
                            style: AppTextStyles.link,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Giriş Yap Butonu
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () => bloc.add(LoginSubmitted()),
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
                              : Text(
                            AppStrings.login,
                            style: AppTextStyles.button,
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
                      // Kayıt Ol
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Bir hesabın yok mu? ",
                            style: AppTextStyles.caption,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Kayıt Ol!",
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