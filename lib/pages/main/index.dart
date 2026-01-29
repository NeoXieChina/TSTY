import 'package:flutter/material.dart';
import 'package:tsty_app/components/common/YiBaseBackground.dart';
import 'package:tsty_app/components/main/bottomNavigationBarCustom.dart';
import 'package:tsty_app/constants/tabList.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  List<Widget> get pages => TabListConstant.tabList.map((tabItem) {
    return tabItem["page"] as Widget;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: YiBaseBackground(
              child: IndexedStack(index: _currentIndex, children: pages),
            ),
          ),
          bottomNavigationBar: BottomNavigationBarCustom(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() {
              _currentIndex = index;
            }),
          ),
        );
      },
    );
  }
}
