import 'package:flutter/material.dart';
import 'browser_screen.dart';
import 'downloads_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Erome Downloader'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.public), text: 'Browser'),
            Tab(icon: Icon(Icons.download), text: 'Downloads'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          BrowserScreen(),
          DownloadsScreen(),
        ],
      ),
    );
  }
}
