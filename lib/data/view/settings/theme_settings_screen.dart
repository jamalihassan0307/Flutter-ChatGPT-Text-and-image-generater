import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_text_and_image_processing/data/models/theme_settings.dart';
import 'package:flutter_chatgpt_text_and_image_processing/configs/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_settings_provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ThemeSettingsScreen extends ConsumerStatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  ConsumerState<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends ConsumerState<ThemeSettingsScreen> {
  final List<ThemePreset> presets = [
    ThemePreset(
      name: 'Classic Green',
      primaryColor: const Color(0xFF10A37F),
      secondaryColor: Colors.teal,
      systemBubbleColor: const Color(0xFF444654),
      userBubbleColor: const Color(0xFF343541),
    ),
    ThemePreset(
      name: 'Ocean Blue',
      primaryColor: Colors.blue,
      secondaryColor: Colors.lightBlue,
      systemBubbleColor: Colors.blueGrey,
      userBubbleColor: Colors.blue[900]!,
    ),
    ThemePreset(
      name: 'Royal Purple',
      primaryColor: Colors.purple,
      secondaryColor: Colors.deepPurple,
      systemBubbleColor: Colors.purple[900]!,
      userBubbleColor: Colors.deepPurple[900]!,
    ),
    ThemePreset(
      name: 'Sunset Orange',
      primaryColor: Colors.deepOrange,
      secondaryColor: Colors.orange,
      systemBubbleColor: Colors.brown[900]!,
      userBubbleColor: Colors.deepOrange[900]!,
    ),
    ThemePreset(
      name: 'Dark Mode',
      primaryColor: Colors.grey[800]!,
      secondaryColor: Colors.grey[700]!,
      systemBubbleColor: Colors.black87,
      userBubbleColor: Colors.black54,
    ),
  ];

  final List<String> backgroundImages = [
    'assets/themeImages/aiBackground.jpeg',
    'assets/themeImages/chatBg.jpeg',
    'assets/themeImages/profileBg.jpeg',
    'assets/themeImages/alex-knight.jpg',
    'assets/themeImages/carlos-muza.jpg',
    'assets/themeImages/engineering.jpg',
    'assets/themeImages/gerard-siderius.jpg',
    'assets/themeImages/laptop_coding.jpg',
    'assets/themeImages/possessed.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(themeSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
        backgroundColor: settings.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.colorize),
            onPressed: () => _showColorPicker(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Custom Color Selection
          _buildColorSection(
            title: 'Custom Colors',
            settings: settings,
          ),

          const SizedBox(height: 24),

          // Background Selection
          _buildBackgroundSection(
            title: 'Background',
            settings: settings,
          ),

          const SizedBox(height: 24),

          // Preset Themes
          _buildPresetSection(
            title: 'Preset Themes',
            settings: settings,
          ),
        ],
      ),
    );
  }

  Widget _buildColorSection({
    required String title,
    required ThemeSettings settings,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildColorButton(
              color: settings.primaryColor,
              label: 'Primary',
              onTap: () => _pickColor(
                context,
                settings.primaryColor,
                (color) => ref.read(themeSettingsProvider.notifier).updateThemeColors(
                      primaryColor: color,
                    ),
              ),
            ),
            _buildColorButton(
              color: settings.systemBubbleColor,
              label: 'System Bubble',
              onTap: () => _pickColor(
                context,
                settings.systemBubbleColor,
                (color) => ref.read(themeSettingsProvider.notifier).updateThemeColors(
                      systemBubbleColor: color,
                    ),
              ),
            ),
            _buildColorButton(
              color: settings.userBubbleColor,
              label: 'User Bubble',
              onTap: () => ref.read(themeSettingsProvider.notifier).updateThemeColors(
                    userBubbleColor: settings.userBubbleColor,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBackgroundSection({
    required String title,
    required ThemeSettings settings,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: backgroundImages.length,
            itemBuilder: (context, index) {
              final image = backgroundImages[index];
              final isSelected = settings.backgroundImage == image;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () {
                    ref.read(themeSettingsProvider.notifier).updateBackgroundImage(image);
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        decoration: BoxDecoration(
                          border: isSelected ? Border.all(color: settings.primaryColor, width: 3) : null,
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage(image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: settings.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPresetSection({
    required String title,
    required ThemeSettings settings,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: presets.length,
          itemBuilder: (context, index) {
            final preset = presets[index];
            return InkWell(
              onTap: () {
                ref.read(themeSettingsProvider.notifier).updateSettings(
                      settings.copyWith(
                        primaryColor: preset.primaryColor,
                        secondaryColor: preset.secondaryColor,
                        systemBubbleColor: preset.systemBubbleColor,
                        userBubbleColor: preset.userBubbleColor,
                      ),
                    );
              },
              child: Card(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(color: preset.systemBubbleColor),
                          ),
                          Expanded(
                            child: Container(color: preset.userBubbleColor),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(preset.name),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showColorPicker(BuildContext context) {
    // Implementation of _showColorPicker method
  }

  Widget _buildColorButton({
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  void _pickColor(BuildContext context, Color currentColor, Function(Color) onColorPicked) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: onColorPicked,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Utils.flushBarSuccessMessage('Color updated', context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class ThemePreset {
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color systemBubbleColor;
  final Color userBubbleColor;

  const ThemePreset({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.systemBubbleColor,
    required this.userBubbleColor,
  });
}
