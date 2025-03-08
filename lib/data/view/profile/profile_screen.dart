import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_text_and_image_processing/data/models/saved_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../configs/utils.dart';
import '../../../configs/constants/app_images.dart';
import '../../../configs/theme/app_theme.dart';
import '../../../configs/routes/routes_name.dart';
import '../../services/shared_prefs_service.dart';
import '../../providers/chat_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final chats = ref.watch(chatProvider); // Get chats from provider

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
        title: const Text('Profile'),
      ),
      body: Stack(
        children: [
          // Background Image with error handling
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: '${AppImages.profileBg}?auto=format&fit=crop&w=800&q=80',
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
                            color: AppTheme.primaryColor,
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
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user?.email ?? 'Not logged in',
                            style: const TextStyle(
                              color: Colors.white70,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
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
                title: const Text('Clear Chat History'),
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
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: onTap,
    );
  }
}

class _SavedUsersSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          const Text(
            'Saved Users',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<SavedUser>>(
            future: SharedPrefsService.getSavedUsers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('No saved users found'),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final user = snapshot.data![index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppTheme.primaryColor,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(user.email),
                    subtitle: Text(user.name ?? ''),
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
  }
}
