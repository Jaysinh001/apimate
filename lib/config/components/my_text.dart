import 'package:flutter/material.dart';

// Enum for different font weight variants
enum FontWeightType {
  bold,
  semiBold,
  medium,
  regular,
}

class MyText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const MyText(
    this.text,
    this.style, {
    super.key,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  // Helper method to map the FontWeightType enum to actual FontWeight values
  static FontWeight _mapFontWeight(FontWeightType weightType) {
    switch (weightType) {
      case FontWeightType.bold:
        return FontWeight.bold;
      case FontWeightType.semiBold:
        return FontWeight.w700;
      case FontWeightType.medium:
        return FontWeight.w500;
      case FontWeightType.regular:
        return FontWeight.normal;
      default:
        return FontWeight.normal;
    }
  }

  // Factory constructors for different Heading levels with variants

  // Heading 1 (Font size 64px, Line height 72px)
  factory MyText.h1(
    String text, {
    FontWeightType fontWeightType = FontWeightType.bold,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return MyText(
      text,
      TextStyle(
        fontFamily: 'Inter',
        fontWeight: _mapFontWeight(fontWeightType),
        fontSize: 64,
        height: 72 / 64,
      ).merge(style),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  // Heading 2 (Font size 48px, Line height 56px)
  factory MyText.h2(
    String text, {
    FontWeightType fontWeightType = FontWeightType.bold,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return MyText(
      text,
      TextStyle(
        fontFamily: 'Inter',
        fontWeight: _mapFontWeight(fontWeightType),
        fontSize: 48,
        height: 56 / 48,
      ).merge(style),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  // Heading 3 (Font size 40px, Line height 48px)
  factory MyText.h3(
    String text, {
    FontWeightType fontWeightType = FontWeightType.bold,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return MyText(
      text,
      TextStyle(
        fontFamily: 'Inter',
        fontWeight: _mapFontWeight(fontWeightType),
        fontSize: 40,
        height: 48 / 40,
      ).merge(style),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  // Heading 4 (Font size 32px, Line height 40px)
  factory MyText.h4(
    String text, {
    FontWeightType fontWeightType = FontWeightType.bold,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return MyText(
      text,
      TextStyle(
        fontFamily: 'Inter',
        fontWeight: _mapFontWeight(fontWeightType),
        fontSize: 32,
        height: 40 / 32,
      ).merge(style),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  // Heading 5 (Font size 24px, Line height 32px)
  factory MyText.h5(
    String text, {
    FontWeightType fontWeightType = FontWeightType.bold,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return MyText(
      text,
      TextStyle(
        fontFamily: 'Inter',
        fontWeight: _mapFontWeight(fontWeightType),
        fontSize: 24,
        height: 32 / 24,
      ).merge(style),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  // Heading 6 (Font size 18px, Line height 26px)
  factory MyText.h6(
    String text, {
    FontWeightType fontWeightType = FontWeightType.bold,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return MyText(
      text,
      TextStyle(
        fontFamily: 'Inter',
        fontWeight: _mapFontWeight(fontWeightType),
        fontSize: 18,
        height: 26 / 18,
      ).merge(style),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  // Body Large (Font size 16px, Line height 24px)
  factory MyText.bodyLarge(
    String text, {
    FontWeightType fontWeightType = FontWeightType.bold,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return MyText(
      text,
      TextStyle(
        fontFamily: 'Inter',
        fontWeight: _mapFontWeight(fontWeightType),
        fontSize: 16,
        height: 24 / 16,
      ).merge(style),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  // Body Medium (Font size 14px, Line height 20px)
  factory MyText.bodyMedium(
    String text, {
    FontWeightType fontWeightType = FontWeightType.bold,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return MyText(
      text,
      TextStyle(
        fontFamily: 'Inter',
        fontWeight: _mapFontWeight(fontWeightType),
        fontSize: 14,
        height: 20 / 14,
      ).merge(style),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  // Body Small (Font size 12px, Line height 16px)
  factory MyText.bodySmall(
    String text, {
    FontWeightType fontWeightType = FontWeightType.bold,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return MyText(
      text,
      TextStyle(
        fontFamily: 'Inter',
        fontWeight: _mapFontWeight(fontWeightType),
        fontSize: 12,
        height: 16 / 12,
      ).merge(style),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
