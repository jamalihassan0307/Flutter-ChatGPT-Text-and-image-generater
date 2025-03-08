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
      textColor: Colors.white,
      textColorSecondary: Colors.white70,
    ),
    ThemePreset(
      name: 'Ocean Blue',
      primaryColor: Colors.blue,
      secondaryColor: Colors.lightBlue,
      systemBubbleColor: Colors.blueGrey,
      userBubbleColor: Colors.blue[900]!,
      textColor: Colors.white,
      textColorSecondary: Colors.white70,
    ),
    ThemePreset(
      name: 'Royal Purple',
      primaryColor: Colors.purple,
      secondaryColor: Colors.deepPurple,
      systemBubbleColor: Colors.purple[900]!,
      userBubbleColor: Colors.deepPurple[900]!,
      textColor: Colors.white,
      textColorSecondary: Colors.white70,
    ),
    ThemePreset(
      name: 'Sunset Orange',
      primaryColor: Colors.deepOrange,
      secondaryColor: Colors.orange,
      systemBubbleColor: Colors.brown[900]!,
      userBubbleColor: Colors.deepOrange[900]!,
      textColor: Colors.white,
      textColorSecondary: Colors.white70,
    ),
    ThemePreset(
      name: 'Dark Mode',
      primaryColor: Colors.grey[800]!,
      secondaryColor: Colors.grey[700]!,
      systemBubbleColor: Colors.black87,
      userBubbleColor: Colors.black54,
      textColor: Colors.white,
      textColorSecondary: Colors.white70,
    ),
    ThemePreset(
      name: 'Ruby Red',
      primaryColor: Colors.red,
      secondaryColor: Colors.redAccent,
      systemBubbleColor: Colors.red[900]!,
      userBubbleColor: Colors.red[800]!,
      textColor: Colors.white,
      textColorSecondary: Colors.white70,
    ),
    ThemePreset(
      name: 'Emerald Green',
      primaryColor: Colors.green,
      secondaryColor: Colors.lightGreen,
      systemBubbleColor: Colors.green[900]!,
      userBubbleColor: Colors.green[700]!,
      textColor: Colors.white,
      textColorSecondary: Colors.white70,
    ),
    ThemePreset(
      name: 'Cyber Neon',
      primaryColor: Colors.cyan,
      secondaryColor: Colors.pinkAccent,
      systemBubbleColor: Colors.blueGrey[900]!,
      userBubbleColor: Colors.purpleAccent[700]!,
      textColor: Colors.white,
      textColorSecondary: Colors.white70,
    ),
    ThemePreset(
      name: 'Golden Glow',
      primaryColor: Colors.amber,
      secondaryColor: Colors.deepOrange,
      systemBubbleColor: Colors.orange[900]!,
      userBubbleColor: Colors.amber[700]!,
      textColor: Colors.black,
      textColorSecondary: Colors.black87,
    ),
    ThemePreset(
      name: 'Midnight Blue',
      primaryColor: Colors.indigo,
      secondaryColor: Colors.blueGrey,
      systemBubbleColor: Colors.indigo[900]!,
      userBubbleColor: Colors.blueGrey[800]!,
      textColor: Colors.white,
      textColorSecondary: Colors.white70,
    ),
    ThemePreset(
      name: 'Lavender Dream',
      primaryColor: const Color(0xFFE6E6FA),
      secondaryColor: Colors.deepPurpleAccent,
      systemBubbleColor: Colors.purple[700]!,
      userBubbleColor: Colors.purple[800]!,
      textColor: Colors.white,
      textColorSecondary: Colors.white70,
    ),
    ThemePreset(
      name: 'Steel Grey',
      primaryColor: Colors.blueGrey,
      secondaryColor: Colors.grey,
      systemBubbleColor: Colors.grey[900]!,
      userBubbleColor: Colors.blueGrey[700]!,
      textColor: Colors.white,
      textColorSecondary: Colors.white70,
    ),
    ThemePreset(
      name: 'Forest Green',
      primaryColor: Colors.teal[900]!,
      secondaryColor: Colors.greenAccent,
      systemBubbleColor: Colors.teal[800]!,
      userBubbleColor: Colors.teal[700]!,
      textColor: Colors.white,
      textColorSecondary: Colors.white70,
    ),
    ThemePreset(
      name: 'Cherry Blossom',
      primaryColor: Colors.pink,
      secondaryColor: Colors.redAccent,
      systemBubbleColor: Colors.pink[900]!,
      userBubbleColor: Colors.redAccent[700]!,
      textColor: Colors.white,
      textColorSecondary: Colors.white70,
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
    'assets/themeImages/color1.jpg',
    'assets/themeImages/color2.jpg',
    'assets/themeImages/color3.jpg',
    'assets/themeImages/color4.jpg',
    'assets/themeImages/color5.jpg',
    'assets/themeImages/color6.jpg',
    'assets/themeImages/color7.jpg',
    'assets/themeImages/color8.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(themeSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Theme Settings',
          style: TextStyle(color: settings.textColor),
        ),
        backgroundColor: settings.primaryColor,
        iconTheme: IconThemeData(color: settings.textColor),
        actions: [
          IconButton(
            icon: Icon(Icons.colorize, color: settings.textColor),
            onPressed: () => _showColorPicker(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: settings.backgroundImage != null
              ? DecorationImage(
                  image: AssetImage(settings.backgroundImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: ListView(
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
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: settings.textColor,
              ),
        ),
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
              onTap: () => _pickColor(
                context,
                settings.userBubbleColor,
                (color) => ref.read(themeSettingsProvider.notifier).updateThemeColors(
                      userBubbleColor: color,
                    ),
              ),
            ),
            _buildColorButton(
              color: settings.textColor,
              label: 'Text Color',
              onTap: () => _pickColor(
                context,
                settings.textColor,
                (color) => ref.read(themeSettingsProvider.notifier).updateThemeColors(
                      textColor: color,
                    ),
              ),
            ),
            _buildColorButton(
              color: settings.textColorSecondary,
              label: 'Secondary Text',
              onTap: () => _pickColor(
                context,
                settings.textColorSecondary,
                (color) => ref.read(themeSettingsProvider.notifier).updateThemeColors(
                      textColorSecondary: color,
                    ),
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
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: settings.textColor,
              ),
        ),
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
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: settings.textColor,
              ),
        ),
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
                        textColor: preset.textColor,
                        textColorSecondary: preset.textColorSecondary,
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
    final settings = ref.read(themeSettingsProvider);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Colors'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Primary Color'),
                trailing: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: settings.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickColor(
                    context,
                    settings.primaryColor,
                    (color) => ref.read(themeSettingsProvider.notifier).updateThemeColors(
                          primaryColor: color,
                        ),
                  );
                },
              ),
              ListTile(
                title: const Text('System Bubble Color'),
                trailing: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: settings.systemBubbleColor,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickColor(
                    context,
                    settings.systemBubbleColor,
                    (color) => ref.read(themeSettingsProvider.notifier).updateThemeColors(
                          systemBubbleColor: color,
                        ),
                  );
                },
              ),
              ListTile(
                title: const Text('User Bubble Color'),
                trailing: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: settings.userBubbleColor,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickColor(
                    context,
                    settings.userBubbleColor,
                    (color) => ref.read(themeSettingsProvider.notifier).updateThemeColors(
                          userBubbleColor: color,
                        ),
                  );
                },
              ),
              ListTile(
                title: const Text('Text Color'),
                trailing: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: settings.textColor,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickColor(
                    context,
                    settings.textColor,
                    (color) => ref.read(themeSettingsProvider.notifier).updateThemeColors(
                          textColor: color,
                        ),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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
  final Color textColor;
  final Color textColorSecondary;

  const ThemePreset({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.systemBubbleColor,
    required this.userBubbleColor,
    required this.textColor,
    required this.textColorSecondary,
  });
}
