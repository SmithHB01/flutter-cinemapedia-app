// Flutter
import 'package:flutter/material.dart';

// Third Party
import 'package:go_router/go_router.dart';

// Project
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'home-screen';

  final List<Widget> children;
  final StatefulNavigationShell navigationShell;

  const HomeScreen({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        widget.navigationShell.currentIndex,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
    }

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: widget.children,
      ),
      bottomNavigationBar:
          CustomBottomNavigationBar(navigationShell: widget.navigationShell),
    );
  }
}
