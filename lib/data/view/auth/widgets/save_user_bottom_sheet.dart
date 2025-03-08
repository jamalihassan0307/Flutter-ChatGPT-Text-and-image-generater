import 'package:flutter/material.dart';
import '../../../models/saved_user.dart';
import '../../../services/shared_prefs_service.dart';

class SaveUserBottomSheet extends StatelessWidget {
  final String email;
  final String password;
  final String? name;
  final bool isUpdate;

  const SaveUserBottomSheet({
    super.key,
    required this.email,
    required this.password,
    this.name,
    this.isUpdate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isUpdate ? 'Update Login Details?' : 'Save Login Details?',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isUpdate 
              ? 'Would you like to update your saved login details?'
              : 'Would you like to save your login details for next time?',
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Not Now'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () async {
                  final user = SavedUser(
                    email: email,
                    password: password,
                    name: name,
                    savedAt: DateTime.now(),
                  );
                  await SharedPrefsService.saveUser(user);
                  Navigator.pop(context);
                },
                child: Text(isUpdate ? 'Update' : 'Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 