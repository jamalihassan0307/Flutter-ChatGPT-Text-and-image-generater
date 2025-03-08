import 'package:flutter/material.dart';
import '../../../models/saved_user.dart';
import '../../../services/shared_prefs_service.dart';

class SavedUsersBottomSheet extends StatelessWidget {
  final Function(SavedUser user) onUserSelected;

  const SavedUsersBottomSheet({
    super.key,
    required this.onUserSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                  child: Text('No saved users found'),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final user = snapshot.data![index];
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(user.email),
                    subtitle: Text(user.name ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await SharedPrefsService.removeSavedUser(user.email);
                        Navigator.pop(context);
                      },
                    ),
                    onTap: () {
                      onUserSelected(user);
                      Navigator.pop(context);
                    },
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