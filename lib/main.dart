import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/farm.dart';
import 'screens/browse_farms_screen.dart';
import 'screens/farm_detail_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/portfolio_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MZingiApp());
}

class MZingiApp extends StatelessWidget {
  const MZingiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M-Zingi Invest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tabIndex = 0;

  void _openFarm(Farm farm) {
    Navigator.of(context).push(_farmRoute(farm));
  }

  Route _farmRoute(Farm farm) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 420),
      pageBuilder: (context, animation, secondaryAnimation) =>
          FarmDetailScreen(farm: farm),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  void _goTo(int index) => setState(() => _tabIndex = index);

  @override
  Widget build(BuildContext context) {
    final screens = [
      LandingScreen(
        onOpenFarm: _openFarm,
        onBrowseAll: () => _goTo(1),
        onInvestNow: () => _goTo(1),
      ),
      BrowseFarmsScreen(onOpenFarm: _openFarm),
      const PortfolioScreen(),
    ];

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Palette.navGreen,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              for (int i = 0; i < NavBar.tabs.length; i++)
                ListTile(
                  title: Text(
                    NavBar.tabs[i],
                    style: TextStyle(
                      color: _tabIndex == i ? Palette.gold : Colors.white,
                      fontWeight: _tabIndex == i ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _goTo(i);
                  },
                ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          NavBar(
            currentIndex: _tabIndex,
            onSelect: _goTo,
            onInvestNow: () => _goTo(1),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              child: KeyedSubtree(
                key: ValueKey(_tabIndex),
                child: screens[_tabIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
