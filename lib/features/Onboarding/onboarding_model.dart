class OnboardingPage {
  final String title;
  final String description;
  final String illustrationPath;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.illustrationPath,
  });
}

final List<OnboardingPage> onboardingPages = [
  const OnboardingPage(
    title: 'Earn Points on Every Action',
    description:
        'Collect points from your daily activities and watch your balance grow effortlessly',
    illustrationPath: 'assets/onboarding/amico.svg',
  ),
  const OnboardingPage(
    title: 'Secure Point Transactions',
    description:
        'Every point transaction is fully encrypted to give you the highest level of security',
    illustrationPath: 'assets/onboarding/rafiki.svg',
  ),
  const OnboardingPage(
    title: 'Find the Nearest Kiosk',
    description:
        'Quickly discover the closest kiosk to you, visit it, and instantly add points to your balance with ease',
    illustrationPath: 'assets/onboarding/pana.svg',
  ),
];
