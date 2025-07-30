import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/text_styles.dart';

Widget buildDiscountBadgeOverlay(int index, String discount, Color color, BuildContext context) {
  // Her paket için yaklaşık pozisyon hesapla (Expanded widget'lar için)

  double screenWidth = MediaQuery.of(context).size.width - 32; // Padding çıkart
  double cardWidth = (screenWidth - 16) / 3; // 3 card, 2x8 gap
  double leftPosition = 16 + (index * (cardWidth + 8)) + 8; // Her kartın sol kenarından biraz içeride

  return Positioned(
    top: -8,
    left: leftPosition,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        discount,
        style: AppTextStyles.body.copyWith(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}