import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_text_and_image_processing/data/models/saved_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../configs/utils.dart';
// import '../../../configs/constants/app_images.dart';
import '../../../configs/theme/app_theme.dart';
import '../../../configs/routes/routes_name.dart';
import '../../services/shared_prefs_service.dart';
import '../../providers/chat_provider.dart';
import '../../../data/view/settings/theme_settings_screen.dart';
import '../../providers/theme_settings_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final chats = ref.watch(chatProvider);
    final themeSettings = ref.watch(themeSettingsProvider);

    // Calculate stats
    final totalChats = chats.length;
    final totalMessages = chats.fold<int>(
      0,
      (sum, chat) => sum + chat.messages.length,
    );
    final totalImages = 0; // TODO: Implement image tracking

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(color: themeSettings.textColor),
        ),
      ),
      body: Stack(
        children: [
          // Updated Background Image
          Positioned.fill(
            child: themeSettings.backgroundImage.startsWith('assets/')
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(themeSettings.backgroundImage),
                        fit: BoxFit.cover,
                        // colorFilter: ColorFilter.mode(
                        //   Colors.black.withOpacity(0.7),
                        //   BlendMode.darken,
                        // ),
                      ),
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: themeSettings.backgroundImage,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.7),
                    colorBlendMode: BlendMode.darken,
                    errorWidget: (context, url, error) => Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    placeholder: (context, url) => Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Profile Picture
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: themeSettings.primaryColor,
                            width: 3,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white24,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: themeSettings.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // User Info
                  FutureBuilder<List<SavedUser>>(
                    future: SharedPrefsService.getSavedUsers(),
                    builder: (context, snapshot) {
                      final user = snapshot.data?.firstOrNull;
                      return Column(
                        children: [
                          Text(
                            user?.name ?? 'Guest User',
                            style: TextStyle(
                              color: themeSettings.textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user?.email ?? 'Not logged in',
                            style: TextStyle(
                              color: themeSettings.textColorSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Chats', totalChats.toString()),
                      _buildStatItem('Messages', totalMessages.toString()),
                      _buildStatItem('Images', totalImages.toString()),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Settings Section
                  _buildSettingsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    final themeSettings = ref.watch(themeSettingsProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: themeSettings.systemBubbleColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: themeSettings.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: themeSettings.textColorSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    final themeSettings = ref.watch(themeSettingsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: TextStyle(
            color: themeSettings.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsTile(
          icon: Icons.people,
          title: 'Saved Users',
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => _SavedUsersSheet(),
            );
          },
        ),
        _buildSettingsTile(
          icon: Icons.notifications,
          title: 'Notifications',
          onTap: () {
            // TODO: Implement notifications settings
          },
        ),
        _buildSettingsTile(
          icon: Icons.delete_outline,
          title: 'Clear Chat History',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Clear Chat History', style: TextStyle(color: themeSettings.textColor)),
                content: const Text(
                  'Are you sure you want to clear all chat history? This action cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Clear all chats
                      await ref.read(chatProvider.notifier).clearAllChats();
                      if (mounted) {
                        Navigator.pop(context);
                        Utils.flushBarSuccessMessage(
                          'Chat history cleared',
                          context,
                        );
                      }
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            );
          },
        ),
        _buildSettingsTile(
          icon: Icons.color_lens,
          title: 'Theme Settings',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ThemeSettingsScreen()),
            );
          },
        ),
        _buildSettingsTile(
          icon: Icons.logout,
          title: 'Logout',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Clear saved user data
                      final currentUser = await SharedPrefsService.getSavedUsers().then((users) => users.firstOrNull);
                      if (currentUser != null) {
                        await SharedPrefsService.removeSavedUser(currentUser.email);
                      }
                      // Clear chat history
                      await ref.read(chatProvider.notifier).clearAllChats();
                      if (mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesName.login,
                          (route) => false,
                        );
                      }
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final themeSettings = ref.watch(themeSettingsProvider);
    return ListTile(
      tileColor: themeSettings.systemBubbleColor.withOpacity(0.1),
      leading: Icon(icon, color: themeSettings.textColor),
      title: Text(
        title,
        style: TextStyle(color: themeSettings.textColor),
      ),
      trailing: Icon(Icons.chevron_right, color: themeSettings.textColor),
      onTap: onTap,
    );
  }
}

class _SavedUsersSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final themeSettings = ref.watch(themeSettingsProvider);
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saved Users',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeSettings.textColor,
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<SavedUser>>(
                future: SharedPrefsService.getSavedUsers(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'No saved users found',
                          style: TextStyle(
                            color: themeSettings.textColor,
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data![index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: themeSettings.primaryColor,
                          child: Icon(Icons.person, color: themeSettings.textColor),
                        ),
                        title: Text(user.email, style: TextStyle(color: themeSettings.textColor)),
                        subtitle: Text(user.name ?? '', style: TextStyle(color: themeSettings.textColor)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await SharedPrefsService.removeSavedUser(user.email);
                            if (context.mounted) {
                              Navigator.pop(context);
                              Utils.flushBarSuccessMessage(
                                'User removed',
                                context,
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
