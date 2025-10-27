import 'package:flutter/material.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Utils/helper.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final bool showBackground;
  final double height;
  final double width;
  final Color titleColor;
  final String? imagePath;
  final double fontsize;
  final Color bgColor;
  const CustomButton({
    super.key,
    this.onTap,
    required this.title,
    this.showBackground = true,
    this.titleColor = Colors.white,
    this.height = 50,
    this.width = double.infinity,
    this.imagePath,
    this.fontsize = 18,
    this.bgColor = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.black),
          color: showBackground ? bgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imagePath != null) Image.asset(imagePath!, scale: 2),
              Text(
                title,
                style: textStyle(
                  color: titleColor,
                  fontSize: fontsize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
