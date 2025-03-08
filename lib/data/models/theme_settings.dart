import 'dart:ui';

class ThemeSettings {
  final String backgroundImage;
  final Color primaryColor;
  final Color secondaryColor;
  final Color systemBubbleColor;
  final Color userBubbleColor;

  const ThemeSettings({
    required this.backgroundImage,
    required this.primaryColor,
    required this.secondaryColor,
    required this.systemBubbleColor,
    required this.userBubbleColor,
  });

  ThemeSettings copyWith({
    String? backgroundImage,
    Color? primaryColor,
    Color? secondaryColor,
    Color? systemBubbleColor,
    Color? userBubbleColor,
  }) {
    return ThemeSettings(
      backgroundImage: backgroundImage ?? this.backgroundImage,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      systemBubbleColor: systemBubbleColor ?? this.systemBubbleColor,
      userBubbleColor: userBubbleColor ?? this.userBubbleColor,
    );
  }

  factory ThemeSettings.fromJson(Map<String, dynamic> json) {
    return ThemeSettings(
      backgroundImage: json['backgroundImage'] as String,
      primaryColor: Color(json['primaryColor'] as int),
      secondaryColor: Color(json['secondaryColor'] as int),
      systemBubbleColor: Color(json['systemBubbleColor'] as int),
      userBubbleColor: Color(json['userBubbleColor'] as int),
    );
  }

  Map<String, dynamic> toJson() => {
        'backgroundImage': backgroundImage,
        'primaryColor': primaryColor.value,
        'secondaryColor': secondaryColor.value,
        'systemBubbleColor': systemBubbleColor.value,
        'userBubbleColor': userBubbleColor.value,
      };
}
