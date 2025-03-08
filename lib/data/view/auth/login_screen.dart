import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../configs/utils.dart';
import '../../../configs/routes/routes_name.dart';
import '../../../configs/constants/app_images.dart';
import '../../../configs/theme/app_theme.dart';
import '../../../data/view/auth/widgets/saved_users_bottom_sheet.dart';
import '../../../data/view/auth/widgets/save_user_bottom_sheet.dart';
import '../../../data/services/shared_prefs_service.dart';
import '../../providers/theme_settings_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.black.withOpacity(0.7),
                    colorBlendMode: BlendMode.darken,
                  ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and Welcome Text
                    Image.asset(
                      AppImages.appLogo,
                      height: 100,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: themeSettings.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to continue your AI journey',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: themeSettings.textColorSecondary,
                          ),
                    ),
                    const SizedBox(height: 48),

                    // Login Form
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              style: TextStyle(color: themeSettings.textColor),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: themeSettings.textColorSecondary),
                                prefixIcon: Icon(Icons.email, color: themeSettings.textColorSecondary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: themeSettings.textColorSecondary.withOpacity(0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: themeSettings.primaryColor),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SavedUsersBottomSheet(
                                    onUserSelected: (user) {
                                      _emailController.text = user.email;
                                      _passwordController.text = user.password;
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              style: TextStyle(color: themeSettings.textColor),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: themeSettings.textColorSecondary),
                                prefixIcon: Icon(Icons.lock, color: themeSettings.textColorSecondary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: themeSettings.textColorSecondary.withOpacity(0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: themeSettings.primaryColor),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: themeSettings.textColorSecondary,
                                  ),
                                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                ),
                              ),
                              obscureText: !_isPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            // Login Button
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeSettings.primaryColor,
                                foregroundColor: themeSettings.textColor,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(themeSettings.textColor),
                                      ),
                                    )
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: themeSettings.textColor,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 20),

                            // Sign Up Link
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(context, RoutesName.signup, (route) => false);
                              },
                              child: Text(
                                "Don't have an account? Sign up",
                                style: TextStyle(color: themeSettings.textColorSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // TODO: Implement actual login logic
        await Future.delayed(const Duration(seconds: 1));

        Utils.flushBarSuccessMessage("Login Successful", context);

        // Check if user is already saved
        final existingUser = await SharedPrefsService.getSavedUser(_emailController.text);

        // Show save/update prompt if not saved or password changed
        if (mounted && (existingUser == null || existingUser.password != _passwordController.text)) {
          await showModalBottomSheet(
            context: context,
            builder: (context) => SaveUserBottomSheet(
              email: _emailController.text,
              password: _passwordController.text,
              name: null,
              isUpdate: existingUser != null,
            ),
          );
        }

        Navigator.pushReplacementNamed(context, RoutesName.home);
      } catch (e) {
        Utils.flushBarErrorMessage(e.toString(), context);
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
}
