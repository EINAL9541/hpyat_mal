enum RouteKeys {
  splash('/splash', 'splash'),
  onboarding('/onboarding', 'onboarding'),
  forest('/', 'forest'),
  health('/health', 'health'),
  breathing('/breathing', 'breathing'),
  journal('/journal', 'journal'),
  savings('/savings', 'savings'),
  settings('/settings', 'settings'),
  settingsPersonalInfo('/settings/personal-info', 'settingsPersonalInfo'),
  settingsTheme('/settings/theme', 'settingsTheme'),
  settingsLanguage('/settings/language', 'settingsLanguage'),
  settingsAboutUs('/settings/about-us', 'settingsAboutUs'),
  settingsFeedback('/settings/feedback', 'settingsFeedback');

  final String path;
  final String name;

  const RouteKeys(this.path, this.name);
}
