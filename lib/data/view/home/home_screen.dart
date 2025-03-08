import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_text_and_image_processing/data/models/theme_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../configs/constants/app_images.dart';
import '../../../configs/routes/routes_name.dart';
import '../../../configs/theme/app_theme.dart';
import '../../providers/chat_provider.dart';
import '../../providers/theme_settings_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatProvider);
    final recentChats = chats.take(5).toList();
    final themeSettings = ref.watch(themeSettingsProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: themeSettings.backgroundImage != null
                ? Image.asset(
                    themeSettings.backgroundImage!,
                    fit: BoxFit.cover,
                    // color: Colors.black.withOpacity(0.7),
                    // colorBlendMode: BlendMode.darken,
                  )
                : CachedNetworkImage(
                    imageUrl: '${AppImages.aiBackground}?auto=format&fit=crop&w=800&q=80',
                    fit: BoxFit.cover,
                    // color: Colors.black.withOpacity(0.7),
                    // colorBlendMode: BlendMode.darken,
                  ),
          ),
          // Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: true,
                  backgroundColor: themeSettings.systemBubbleColor.withOpacity(0.8),
                  title: Row(
                    children: [
                      Image.asset(
                        AppImages.appLogo,
                        height: 40,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Gemini AI',
                        style: TextStyle(color: themeSettings.textColor),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.person, color: themeSettings.textColor),
                      onPressed: () => Navigator.pushNamed(context, RoutesName.profile),
                    ),
                  ],
                ),

                // Welcome Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to\nGemini AI',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: themeSettings.textColor,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Experience the power of AI with natural conversations',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: themeSettings.textColorSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Quick Actions
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Actions',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: themeSettings.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _ActionCard(
                                icon: Icons.chat_bubble_outline,
                                title: 'New Chat',
                                onTap: () => Navigator.pushNamed(context, RoutesName.chat),
                                themeSettings: themeSettings,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _ActionCard(
                                icon: Icons.image_outlined,
                                title: 'Image Generation',
                                onTap: () {
                                  // TODO: Implement image generation
                                },
                                themeSettings: themeSettings,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Recent Chats
                if (recentChats.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Chats',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: themeSettings.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, RoutesName.chat),
                            child: Text(
                              'View All',
                              style: TextStyle(color: themeSettings.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final chat = recentChats[index];
                          return Card(
                            color: themeSettings.systemBubbleColor.withOpacity(0.8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: themeSettings.primaryColor,
                                child: Icon(Icons.chat, color: themeSettings.textColor),
                              ),
                              title: Text(
                                chat.name,
                                style: TextStyle(color: themeSettings.textColor),
                              ),
                              subtitle: Text(
                                '${chat.messages.length} messages',
                                style: TextStyle(color: themeSettings.textColorSecondary),
                              ),
                              trailing: Icon(Icons.arrow_forward, color: themeSettings.textColorSecondary),
                              onTap: () => Navigator.pushNamed(
                                context,
                                RoutesName.chat,
                                arguments: chat.id,
                              ),
                            ),
                          );
                        },
                        childCount: recentChats.length,
                      ),
                    ),
                  ),
                ],

                const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final ThemeSettings themeSettings;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.themeSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: themeSettings.userBubbleColor.withOpacity(0.8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: themeSettings.textColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: themeSettings.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
