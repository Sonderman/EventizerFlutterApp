import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:sizer/sizer.dart';

/// Placeholder metinleri — koyu temada olabildiğince beyaz.
TextStyle glassPlaceholderStyle() => TextStyle(
  fontFamily: "ZonaLight",
  color: Colors.white.withValues(alpha: 0.72),
  fontSize: 14.sp,
);

/// Metin girişi — katalogdaki `heading` stili.
TextStyle glassInputTextStyle() => TextStyle(
  fontSize: 14.sp,
  fontFamily: "Zona",
  color: Colors.white,
);

/// Katalogdaki `kClearGlassBase` — birebir aynı değerler.
/// glassColor: nötr koyu saydam dolgu — arkadaki lacivert degrade içinden
/// görünmesin diye mavimsi tondan arındırılmış.
const LiquidGlassSettings kGlassInputSettings = LiquidGlassSettings(
  blur: 0,
  thickness: 8,
  glassColor: Color(0x24000000),
  refractiveIndex: 0.82,
  lightAngle: 0.75 * 3.141592653589793,
  lightIntensity: 0.9,
  ambientStrength: 0.12,
  saturation: 1.0,
  chromaticAberration: 0.008,
  specularSharpness: GlassSpecularSharpness.medium,
);

/// Alan etiketleri — koyu temada olabildiğince beyaz.
TextStyle glassLabelStyle() => TextStyle(
  fontFamily: "Zona",
  fontSize: 13.sp,
  fontWeight: FontWeight.w600,
  letterSpacing: 1.2,
  color: Colors.white.withValues(alpha: 0.90),
);

/// Katalogdaki `inputs_section.dart` ile birebir — sade, ikonsuz net cam alan.
///
/// Cam yüzeyin herhangi bir yerine dokunulduğunda alan focus alır;
/// CupertinoTextField yalnızca kendi metin kutusuna gelen dokunuşları işler.
class GlassInputField extends StatefulWidget {
  const GlassInputField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
  });

  final TextEditingController controller;
  final String hint;

  /// Alanın üstünde gösterilen küçük etiket (ör. "Email").
  final String? label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  State<GlassInputField> createState() => _GlassInputFieldState();
}

class _GlassInputFieldState extends State<GlassInputField> {
  // GlassTextField'a dışarıdan verilir; cam boşluğuna dokunulduğunda
  // manuel requestFocus yapabilmek için tutuyoruz.
  late final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = GestureDetector(
      // Cam yüzeyin tamamını dokunulabilir yapar; metnin kendisine dokununca
      // içteki CupertinoTextField kazanır (imleç konumlama bozulmaz).
      behavior: HitTestBehavior.opaque,
      onTap: _focusNode.requestFocus,
      child: GlassTextField(
        controller: widget.controller,
        focusNode: _focusNode,
        placeholder: widget.hint,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        maxLength: widget.maxLength,
        shape: const LiquidRoundedRectangle(borderRadius: 20),
        settings: kGlassInputSettings,
        useOwnLayer: true,
        interactionBehavior: GlassInteractionBehavior.none,
        textStyle: glassInputTextStyle(),
        placeholderStyle: glassPlaceholderStyle(),
      ),
    );

    if (widget.label == null) {
      return field;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label!, style: glassLabelStyle()),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}

/// Katalog görünümünde şifre alanı — kilit + göz ikonları tam beyaz.
class GlassPasswordInput extends StatefulWidget {
  const GlassPasswordInput({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
  });

  final TextEditingController controller;
  final String hint;

  /// Alanın üstünde gösterilen küçük etiket (ör. "Password").
  final String? label;

  @override
  State<GlassPasswordInput> createState() => _GlassPasswordInputState();
}

class _GlassPasswordInputState extends State<GlassPasswordInput> {
  bool _obscure = true;

  // GlassTextField'a dışarıdan verilir; cam boşluğuna dokunulduğunda
  // manuel requestFocus yapabilmek için tutuyoruz.
  late final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = GestureDetector(
      // Cam yüzeyin tamamını dokunulabilir yapar; göz ikonuna dokununca
      // içteki GestureDetector kazanır (_obscure değişimi bozulmaz).
      behavior: HitTestBehavior.opaque,
      onTap: _focusNode.requestFocus,
      child: GlassTextField(
        controller: widget.controller,
        focusNode: _focusNode,
        placeholder: widget.hint,
        obscureText: _obscure,
        // Kilit + göz ikonları — tam beyaz (paketin soluk secondaryLabel'ı yerine)
        prefixIcon: const Icon(
          Icons.lock,
          size: 20,
          color: Colors.white,
        ),
        suffixIcon: Icon(
          _obscure ? Icons.visibility : Icons.visibility_off,
          size: 20,
          color: Colors.white,
        ),
        onSuffixTap: () {
          setState(() {
            _obscure = !_obscure;
          });
        },
        // GlassPasswordField height kabul etmiyor; padding ile büyütüyoruz.
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        shape: const LiquidRoundedRectangle(borderRadius: 20),
        settings: kGlassInputSettings,
        useOwnLayer: true,
        interactionBehavior: GlassInteractionBehavior.none,
        textStyle: glassInputTextStyle(),
        placeholderStyle: glassPlaceholderStyle(),
      ),
    );

    if (widget.label == null) {
      return field;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label!, style: glassLabelStyle()),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}