import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/theme_service.dart';

/// Theme settings page for changing app theme and color scheme
class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find<ThemeService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Tema Ayarları'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Mode Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.brightness_6, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('Tema Modu', style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => Column(
                        children: [
                          // Light Theme Option
                          RadioListTile<ThemeMode>(
                            title: const Text('Açık Tema'),
                            subtitle: const Text('Her zaman açık tema kullan'),
                            value: ThemeMode.light,
                            groupValue: themeService.themeMode,
                            onChanged: (ThemeMode? value) {
                              if (value != null) {
                                themeService.setThemeMode(value);
                              }
                            },
                            secondary: const Icon(Icons.light_mode),
                          ),
                          // Dark Theme Option
                          RadioListTile<ThemeMode>(
                            title: const Text('Koyu Tema'),
                            subtitle: const Text('Her zaman koyu tema kullan'),
                            value: ThemeMode.dark,
                            groupValue: themeService.themeMode,
                            onChanged: (ThemeMode? value) {
                              if (value != null) {
                                themeService.setThemeMode(value);
                              }
                            },
                            secondary: const Icon(Icons.dark_mode),
                          ),
                          // System Theme Option
                          RadioListTile<ThemeMode>(
                            title: const Text('Sistem Ayarı'),
                            subtitle: const Text('Sistem ayarını takip et'),
                            value: ThemeMode.system,
                            groupValue: themeService.themeMode,
                            onChanged: (ThemeMode? value) {
                              if (value != null) {
                                themeService.setThemeMode(value);
                              }
                            },
                            secondary: const Icon(Icons.settings_system_daydream),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Color Scheme Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.palette, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('Renk Şeması', style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Uygulamanın renk temasını seçin:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                        itemCount: themeService.availableColorSchemes.length,
                        itemBuilder: (context, index) {
                          final colorSchemeData = themeService.availableColorSchemes[index];
                          final isSelected = themeService.colorSchemeIndex == index;

                          return GestureDetector(
                            onTap: () => themeService.setColorScheme(index),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.withOpacity(0.3),
                                  width: isSelected ? 3 : 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: _ColorSchemePreview(
                                  scheme: colorSchemeData['scheme'],
                                  isSelected: isSelected,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Reset Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showResetDialog(context, themeService);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Varsayılan Ayarlara Dön'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show reset confirmation dialog
  void _showResetDialog(BuildContext context, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tema Ayarlarını Sıfırla'),
          content: const Text(
            'Tema ayarlarını varsayılan değerlere sıfırlamak istediğinizden emin misiniz?',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('İptal')),
            ElevatedButton(
              onPressed: () {
                themeService.resetToDefault();
                Navigator.of(context).pop();
                Get.snackbar(
                  'Başarılı',
                  'Tema ayarları varsayılan değerlere sıfırlandı',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text('Sıfırla'),
            ),
          ],
        );
      },
    );
  }
}

/// Color scheme preview widget
class _ColorSchemePreview extends StatelessWidget {
  final dynamic scheme;
  final bool isSelected;

  const _ColorSchemePreview({required this.scheme, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    // Get colors from the scheme for preview
    final lightTheme = _createPreviewTheme(scheme, false);
    final darkTheme = _createPreviewTheme(scheme, true);

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          // Light theme preview (top half)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: lightTheme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: lightTheme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Dark theme preview (bottom half)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: darkTheme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: darkTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: darkTheme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Create a preview theme for color demonstration
  ThemeData _createPreviewTheme(dynamic scheme, bool isDark) {
    try {
      if (isDark) {
        return ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        );
      } else {
        return ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
        );
      }
    } catch (e) {
      // Fallback theme if scheme creation fails
      return isDark ? ThemeData.dark() : ThemeData.light();
    }
  }
}
