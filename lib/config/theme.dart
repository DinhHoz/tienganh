import 'package:flutter/material.dart';

class AppColors {
  static const background = Color.fromARGB(255, 253, 254, 255); // Màu nền chính
  static const dialogBackground = Colors.black; // Màu nền phụ (các hộp thoại, nút phụ)
  static const dialogBorder = Color.fromARGB(179, 255, 255, 255); // Màu nền phụ (các hộp thoại, nút phụ)

  static const whiteText = Colors.white;
  static const subText_1 = Color(0xFF9BDD2D);
  static const subText = Color.fromARGB(179, 181, 179, 179);
  static const subText_2 = Colors.white70;
  static const buttonGreen = Color(0xFF9BDD2D);
  static const backIcon = Colors.white70;
  static const blackText = Colors.black;
  static const button_border_1 = Color.fromARGB(179, 181, 179, 179);
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.whiteText),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
}


class AppTextStyles {
  static const appName = TextStyle(
    color: AppColors.buttonGreen,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const subTitle = TextStyle(
    color: Color.fromARGB(179, 143, 140, 140),
    fontSize: 16,
  );

  static const subTitle_1 = TextStyle(
    color: AppColors.subText_2,
    fontSize: 16,
  );

  static const buttonTextPrimary = TextStyle(
    color: AppColors.blackText,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const buttonTextSecondary = TextStyle(
    color: AppColors.subText_1,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const buttonTextGreen = TextStyle(
  color: AppColors.buttonGreen,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

}
