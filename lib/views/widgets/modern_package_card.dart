import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/offer/offer_bloc.dart';
import '../../blocs/offer/offer_event.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';

Widget buildModernPackageCard({
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
        height: 200,
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
                          fontSize: 16, // Daha küçük font
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
                          fontSize: 22, // Daha küçük font
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      Text(
                        'Jeton',
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          fontSize: 13, // Daha küçük font
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
                          fontSize: 14, // Daha küçük font
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        AppLocalizations.of(context)!.offer_weeklyPrice,
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 9, // Daha küçük font
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
