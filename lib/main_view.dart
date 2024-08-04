import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'home_view.dart';
import 'views/profile_pages/blogs_view.dart';
import 'views/profile_pages/profile_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentTab = 0;
  final List<Widget> screens = [
    const HomeView(),
    const BlogsView(),
    const ProfileView(),
  ];
  final List<void> methods = [];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: const Color.fromARGB(255, 6, 111, 173),
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                  onPressed: () {
                    setState(() {
                      currentScreen = const HomeView();
                      currentTab = 3;
                    });
                  },
                ),
                GButton(
                  icon: LineIcons.newspaper,
                  text: 'Blogs',
                  onPressed: () {
                    setState(() {
                      currentScreen = const BlogsView();
                      currentTab = 3;
                    });
                  },
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                  onPressed: () {
                    {
                      setState(() {
                        currentScreen = const ProfileView();
                        currentTab = 3;
                      });
                    }
                  },
                ),
              ],
              selectedIndex: currentTab,
              onTabChange: (index) {
                setState(() {
                  currentTab = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
