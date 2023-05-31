import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_hub/providers/base_screen_providers.dart';
import 'package:student_hub/screens/account_screen.dart';
import 'package:student_hub/screens/articles_screen.dart';
import 'package:student_hub/screens/feeds_screen.dart';
import 'package:student_hub/screens/test_screen.dart';
import 'package:student_hub/screens/videoes_screen.dart';

class BaseScreen extends ConsumerWidget {
  BaseScreen({super.key});

  final _pages = [
    const FeedsScreen(text: "1"),
    const ArticlesScreen(),
    const VideoesScreen(),
    const TestScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationCurrentIndex = ref.watch(navigationBarIndexStateProvider);
    final pageController = ref.watch(pageViewControllerProvider);
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: _pages,
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
