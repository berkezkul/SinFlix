import 'package:flutter/cupertino.dart';

import '../../utils/constants/colors.dart';

class SocialButton extends StatelessWidget {
  final String iconPath;
  const SocialButton({required this.iconPath});

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