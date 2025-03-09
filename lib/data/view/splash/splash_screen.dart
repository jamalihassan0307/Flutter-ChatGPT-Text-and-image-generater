import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../configs/constants/app_images.dart';
import '../../../configs/routes/routes_name.dart';
import '../../providers/theme_settings_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Navigate to login screen after animation
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, RoutesName.login);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeSettings = ref.watch(themeSettingsProvider);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Image.asset(
                    themeSettings.backgroundImage,
                    fit: BoxFit.cover,
                    //   color: Colors.black.withOpacity(0.7),
                    //   colorBlendMode: BlendMode.darken,
                  ));
            },
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Image.asset(
                          AppImages.appLogo,
                          height: 150,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Animated Text
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Column(
                        children: [
                          Text(
                            'Gemini AI',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: themeSettings.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Experience the future of AI',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: themeSettings.textColorSecondary,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 64),

                // Loading Indicator
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(themeSettings.primaryColor),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Version Text
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Text(
                    'Version 1.0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeSettings.textColorSecondary,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
