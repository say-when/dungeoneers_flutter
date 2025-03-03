class SystemInfo {
  final String userAgent;
  final String documentDirectory;
  final String libraryDirectory;
  final String soundsDirectory;
  final String bundleDirectory;
  final String tempDirectory;
  final bool isTablet;

  SystemInfo({
    required this.userAgent,
    required this.documentDirectory,
    required this.libraryDirectory,
    required this.soundsDirectory,
    required this.bundleDirectory,
    required this.tempDirectory,
    required this.isTablet,
  });
}
