import 'package:catdog/ui/pages/feed/view/feed_view.dart';
import 'package:catdog/ui/pages/home/widgets/navigation_body.dart';
import 'package:catdog/ui/widgets/main_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NavigationBody(selectedIndex: _selectedIndex),
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        onWritePressed: () { print('Write button tapped');
        Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FeedView()),
      );
        }
      ),
    );
  }
}
