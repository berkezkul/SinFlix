import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinflix/views/screens/register.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/login/login_bloc.dart';
import '../../blocs/login/login_event.dart';
import '../../blocs/login/login_state.dart';
import '../../repositories/user_repository.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/constants/strings.dart';
import '../../utils/constants/icons.dart';
import '../../utils/helpers/token_storage.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/social_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc()),
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
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, loginState) {
                    final loginBloc = context.read<LoginBloc>();
                    final authState = context.watch<AuthBloc>().state;
                    final isLoading = loginState.isLoading || authState is AuthLoading;
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
                          AppLocalizations.of(context)!.auth_welcomeDesc,
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
                          onChanged: (value) => loginBloc.add(EmailChanged(value)),
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
                          onChanged: (value) => loginBloc.add(PasswordChanged(value)),
                          obscureText: !loginState.isPasswordVisible,
                          style: AppTextStyles.input,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(AppIcons.password, width: 24, height: 24),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                loginState.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: AppColors.border,
                              ),
                              onPressed: () => loginBloc.add(TogglePasswordVisibility()),
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
                              AppLocalizations.of(context)!.auth_forgotPassword,
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
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.read<AuthBloc>().add(
                                      LoginRequested(
                                        loginState.email,
                                        loginState.password,
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
                              AppLocalizations.of(context)!.auth_login,
                              style: AppTextStyles.button,
                            ),
                          ),
                        ),
                        if (loginState.error != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            loginState.error!,
                            style: AppTextStyles.caption.copyWith(color: AppColors.error),
                          ),
                        ],
                        const SizedBox(height: 24),
                        // Sosyal Medya Butonları
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SocialButton(iconPath: AppIcons.google),
                            SocialButton(iconPath: AppIcons.apple),
                            SocialButton(iconPath: AppIcons.facebook),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Kayıt Ol
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.auth_noAccountQuestion,
                              style: AppTextStyles.caption,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(value: context.read<LoginBloc>()),
                                        BlocProvider.value(value: context.read<AuthBloc>()),
                                      ],
                                      child: const RegisterView(),
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.auth_register,
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

