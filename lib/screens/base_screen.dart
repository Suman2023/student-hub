import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_hub/providers/base_screen_providers.dart';
import 'package:student_hub/screens/account_screen.dart';
import 'package:student_hub/screens/articles_screen.dart';
import 'package:student_hub/screens/feeds_screen.dart';
import 'package:student_hub/screens/test_screen.dart';
import 'package:student_hub/screens/videoes_screen.dart';

import '../providers/accounts_screen_providers.dart';

class BaseScreen extends ConsumerStatefulWidget {
  const BaseScreen({super.key, this.data});
  final Map<String, dynamic>? data;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseScreenState();
}

class _BaseScreenState extends ConsumerState<BaseScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> getPages(int accountPage) {
    return [
      const FeedsScreen(text: "1"),
      ArticlesScreen(),
      const VideoesScreen(),
      const TestScreen(),
      const AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final navigationCurrentIndex = ref.watch(navigationBarIndexStateProvider);
    final pageController = ref.watch(pageViewControllerProvider);
    final isLoggedIn = ref.watch(isLoggedInStateProvider);
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: getPages(isLoggedIn ? 0 : 1),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationCurrentIndex,
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.shifting,
        onTap: (int index) {
          ref.read(navigationBarIndexStateProvider.notifier).state = index;
          pageController.jumpToPage(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.timeline),
            label: 'Timeline',
            backgroundColor: Colors.blue[300],
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.solidNewspaper),
            label: 'Articles',
            backgroundColor: Colors.green[300],
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.video),
            label: 'Videoes',
            backgroundColor: Colors.red[300],
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.penToSquare),
            label: 'Test',
            backgroundColor: Colors.brown[300],
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.faceSmile),
            label: 'Account',
            backgroundColor: Colors.amber[300],
          ),
        ],
      ),
    );
  }
}
