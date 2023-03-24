import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Container(
          height: 50,
          child: Hero(
              tag: 'logo',
              child: Image.asset(
                'images/Icon/appIcon.png',
              )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return const SizedBox(
              height: 15.0,
            );
          },
          separatorBuilder: (context, index) {
            return notificationItem(title: 'Notification $index', body: 'This is body number $index',);
          },
          itemCount: 0,
        ),
      ),
    );
  }

  Widget notificationItem({
    required String title,
    required String body,
  }) {
    return Container(
      width: double.infinity,
      height: 100,

      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(offset: Offset(1,1), blurRadius: 2,blurStyle: BlurStyle.outer),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 20.0,),
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
              child: const Icon(Icons.notifications_active),),
          const SizedBox(width: 20.0,),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.black,
              ),),
              Text(body, style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 15.0,
                color: Colors.grey,
              ),),


            ],
          ),
        ],
      ),
    );
  }
}
