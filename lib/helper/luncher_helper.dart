import 'package:url_launcher/url_launcher.dart';

class LauncherHelper {
  LauncherHelper._();
  static LauncherHelper launcher = LauncherHelper._();
  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url, forceWebView: true, enableJavaScript: true)
      : throw 'Could not launch $_url';

  sendEmail() => _launchURL('mailto:');
  sendSms() => _launchURL('sms:');
  sendTel() => _launchURL('tel:');
  openWebPage(String url) => _launchURL(url);
}
