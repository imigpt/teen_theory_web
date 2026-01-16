import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  final bool isLoading;
  final Color loaderColor;
  final double borderRadius;
  final bool isEnabled;
  
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
    this.isLoading = false,
    this.loaderColor = Colors.deepPurple,
    this.borderRadius = 30,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (isLoading == true || isEnabled == false) ? null : onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.black),
          color: isLoading == true || isEnabled == false 
              ? bgColor.withValues(alpha: 0.5) 
              : bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: isLoading == true ? LoadingAnimationWidget.fourRotatingDots(color: loaderColor, size: 18) : Row(
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
