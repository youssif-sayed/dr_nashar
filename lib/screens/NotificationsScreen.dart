import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: SizedBox(
          height: 50,
          child: Hero(
            tag: 'logo',
            child: Image.asset(
              'images/Icon/appIcon.png',
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Center(
                child: Text(AppLocalizations.of(context)!.no_notifications_yet),
              ),
            );
          }
          final notifications = snapshot.data!.docs;
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: notifications.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 15.0);
            },
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return notificationItem(
                title: notification['title'],
                body: notification['body'],
                imageUrl: notification['imageUrl'],
                context: context
              );
            },
          );
        },
      ),
    );
  }

  Widget notificationItem({
    required String title,
    required String body,
    String? imageUrl,
    context
  }) {
    return Container(
      constraints: BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Column(

        children: [
          if (imageUrl != null)
            ClipRRect(

              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: MediaQuery.of(context).size.width/1.5,

                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 12,),
          Row(
            children: [
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) => const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff08CE5D),
                    Color(0xff098FEA),
                  ],
                ).createShader(bounds),
                child: const Icon(Icons.notifications_active),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      body,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20.0),

            ],
          ),
        ],
      ),
    );
  }
}
