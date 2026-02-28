import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

/// Abstraction over opening URLs (e.g. store link). Keeps presentation free of I/O.
@lazySingleton
class UrlLauncherService {
  /// Opens [urlString] in external app (e.g. browser or store).
  /// Returns true if launched, false if unable to open.
  Future<bool> openUrl(String urlString) async {
    final url = Uri.tryParse(urlString);
    if (url == null) return false;
    if (!await canLaunchUrl(url)) return false;
    return launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
