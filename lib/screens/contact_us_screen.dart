import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: CupertinoColors.lightBackgroundGray,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: SizedBox(
          height: 50,
          child: Hero(
            tag: 'logo',
            child: Image.asset('images/Icon/appIcon.png'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
          child: Column(
            children: [
              Text(
                localization.contact_us,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                localization.contact_us_body,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 32),
              ContactCard(
                icon: MaterialCommunityIcons.web,
                text: 'Dr. Nashar Website',
                backgroundColor: const Color(0xFF1e1f1f),
                foregroundColor: Colors.white,
                onTap: () => _launchURL('https://www.dr-nashar.com/'),
              ),
              const SizedBox(height: 16),
              ContactCard(
                icon: Fontisto.facebook,
                text: 'Facebook Page',
                backgroundColor: const Color(0xFF3982e4),
                foregroundColor: Colors.white,
                onTap: () => _launchURL(
                    'https://www.facebook.com/drnashar?mibextid=LQQJ4d'),
              ),
              const SizedBox(height: 16),
              ContactCard(
                icon: FontAwesome.youtube_play,
                text: 'Youtube Channel',
                backgroundColor: const Color(0xFFff0000),
                foregroundColor: Colors.white,
                onTap: () => _launchURL('https://www.youtube.com/@drnashar'),
              ),
              const SizedBox(height: 16),
              ContactCard(
                icon: MaterialCommunityIcons.whatsapp,
                text: 'WhatsApp',
                backgroundColor: const Color(0xFF0dbf42),
                foregroundColor: Colors.white,
                onTap: () => _launchURL(
                    'https://chat.whatsapp.com/JMFWUpJNrqnJ7x5HfpYCMn'),
              ),
              const SizedBox(height: 16),
              ContactCard(
                icon: FontAwesome5Brands.telegram,
                text: 'Telegram',
                backgroundColor: const Color(0xFF3390ec),
                foregroundColor: Colors.white,
                onTap: () => _launchURL('https://t.me/drnasharx'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }
}

class ContactCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  const ContactCard({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.backgroundColor = Colors.black,
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: foregroundColor,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
