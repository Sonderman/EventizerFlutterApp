import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Theme service that manages app themes using FlexColorScheme
class ThemeService extends GetxController {
  static const String _themeKey = 'theme_mode';
  static const String _colorSchemeKey = 'color_scheme';

  final GetStorage _storage = GetStorage();

  // Reactive variables for theme state
  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;
  final RxInt _colorSchemeIndex = 0.obs;

  // Getters
  ThemeMode get themeMode => _themeMode.value;
  int get colorSchemeIndex => _colorSchemeIndex.value;
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  // Available color schemes
  final List<FlexScheme> _availableSchemes = [
    FlexScheme.material,
    FlexScheme.materialHc,
    FlexScheme.blue,
    FlexScheme.indigo,
    FlexScheme.hippieBlue,
    FlexScheme.aquaBlue,
    FlexScheme.brandBlue,
    FlexScheme.deepBlue,
    FlexScheme.sakura,
    FlexScheme.mandyRed,
    FlexScheme.red,
    FlexScheme.redWine,
    FlexScheme.purpleBrown,
    FlexScheme.green,
    FlexScheme.money,
    FlexScheme.jungle,
    FlexScheme.greyLaw,
    FlexScheme.wasabi,
    FlexScheme.gold,
    FlexScheme.mango,
    FlexScheme.amber,
    FlexScheme.vesuviusBurn,
    FlexScheme.deepPurple,
    FlexScheme.ebonyClay,
    FlexScheme.barossa,
    FlexScheme.shark,
    FlexScheme.bigStone,
    FlexScheme.damask,
    FlexScheme.bahamaBlue,
    FlexScheme.mallardGreen,
    FlexScheme.espresso,
    FlexScheme.outerSpace,
    FlexScheme.blueWhale,
    FlexScheme.sanJuanBlue,
    FlexScheme.rosewood,
    FlexScheme.blumineBlue,
  ];

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  /// Load theme settings from storage
  void _loadThemeFromStorage() {
    final themeModeString = _storage.read(_themeKey) ?? 'light';
    final colorSchemeIndex = _storage.read(_colorSchemeKey) ?? 0;

    _themeMode.value = _getThemeModeFromString(themeModeString);
    _colorSchemeIndex.value = colorSchemeIndex;
  }

  /// Convert string to ThemeMode
  ThemeMode _getThemeModeFromString(String mode) {
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  /// Get string from ThemeMode
  String _getStringFromThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      default:
        return 'light';
    }
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    if (_themeMode.value == ThemeMode.light) {
      _themeMode.value = ThemeMode.dark;
    } else {
      _themeMode.value = ThemeMode.light;
    }
    _saveThemeToStorage();
    Get.changeThemeMode(_themeMode.value);
  }

  /// Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    _saveThemeToStorage();
    Get.changeThemeMode(_themeMode.value);
  }

  /// Change color scheme
  void setColorScheme(int index) {
    if (index >= 0 && index < _availableSchemes.length) {
      _colorSchemeIndex.value = index;
      _saveThemeToStorage();
      // Update the entire app theme
      _updateAppTheme();
    }
  }

  /// Save theme settings to storage
  void _saveThemeToStorage() {
    _storage.write(_themeKey, _getStringFromThemeMode(_themeMode.value));
    _storage.write(_colorSchemeKey, _colorSchemeIndex.value);
  }

  /// Update app theme with new color scheme
  void _updateAppTheme() {
    Get.changeTheme(getLightTheme());
    Get.changeTheme(getDarkTheme());
  }

  /// Get current color scheme
  FlexScheme get currentColorScheme => _availableSchemes[_colorSchemeIndex.value];

  /// Get all available color schemes with names
  List<Map<String, dynamic>> get availableColorSchemes {
    return _availableSchemes.asMap().entries.map((entry) {
      final index = entry.key;
      final scheme = entry.value;
      return {'index': index, 'scheme': scheme, 'name': _getColorSchemeName(scheme)};
    }).toList();
  }

  /// Get color scheme name
  String _getColorSchemeName(FlexScheme scheme) {
    return scheme.toString().split('.').last.replaceAll(RegExp(r'([A-Z])'), ' \$1').trim();
  }

  /// Generate light theme using FlexColorScheme
  ThemeData getLightTheme() {
    return FlexThemeData.light(
      scheme: currentColorScheme,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        blendOnColors: false,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      // Custom font configuration
      fontFamily: 'Zona',
    );
  }

  /// Generate dark theme using FlexColorScheme
  ThemeData getDarkTheme() {
    return FlexThemeData.dark(
      scheme: currentColorScheme,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 13,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      // Custom font configuration
      fontFamily: 'Zona',
    );
  }

  /// Get current theme data based on theme mode
  ThemeData getCurrentTheme() {
    if (_themeMode.value == ThemeMode.dark) {
      return getDarkTheme();
    } else {
      return getLightTheme();
    }
  }

  /// Reset to default theme
  void resetToDefault() {
    _themeMode.value = ThemeMode.light;
    _colorSchemeIndex.value = 0;
    _saveThemeToStorage();
    Get.changeThemeMode(_themeMode.value);
    _updateAppTheme();
  }
}
