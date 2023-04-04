import 'package:dr_nashar/screens/home.dart';
import 'package:dr_nashar/screens/profileScreen.dart';
import 'package:flutter/material.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  // Bottom bar index
  int currentIndex = 0;

  // Screen
  List<Widget> screens = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  // Screen Titles
  List<String> screensTitles = [
    'Home',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
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
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'NotificationsScreen');
                },
                icon: const Icon(Icons.notifications_active),
              )),
        ],
        centerTitle: true,
        backgroundColor: Colors.black,
        title: SizedBox(
          height: 50,
          child: Hero(
              tag: 'logo',
              child: Image.asset(
                'images/Icon/appIcon.png',
              )),
        ),
      ),
      body: screens.elementAt(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        currentIndex: currentIndex,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        elevation: 0.0,
        items: [
          BottomNavigationBarItem(
            icon: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) => currentIndex == 0
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff08CE5D),
                          Color(0xff098FEA),
                        ],
                      ).createShader(bounds)
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                            Colors.white,
                            Colors.white,
                          ]).createShader(bounds),
                child: const Icon(Icons.home_filled)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) => currentIndex == 1
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff08CE5D),
                          Color(0xff098FEA),
                        ],
                      ).createShader(bounds)
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                            Colors.white,
                            Colors.white,
                          ]).createShader(bounds),
                child: const Icon(Icons.person)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
