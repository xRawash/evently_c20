import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/sources/routes_manager.dart';
import 'package:evently_app_abbas/features/main_layout/tabs/fav/fav.dart';
import 'package:evently_app_abbas/features/main_layout/tabs/home/home.dart';
import 'package:evently_app_abbas/features/main_layout/tabs/profile/profile.dart';
import 'package:flutter/material.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int tappedIndex = 0;
  List<Widget> tabs = [
    Home(),
    Favourite(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: tabs[tappedIndex],
      floatingActionButton: FloatingActionButton(

        onPressed: (){
          Navigator.pushNamed(context, RoutesManager.createEvent);
        }, child: Icon(Icons.add),),
      bottomNavigationBar: _buildBottomNavBar,
    );
  }

  void _onTap(int newIndex){
    setState(() {
      tappedIndex = newIndex;
    });
  }

  Widget get _buildBottomNavBar{
    return BottomNavigationBar(

        currentIndex: tappedIndex,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(icon: Icon(tappedIndex == 0 ? Icons.home: Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(tappedIndex == 1 ? Icons.favorite : Icons.favorite_border), label: "Fav"),
          BottomNavigationBarItem(icon: Icon(tappedIndex == 2? Icons.person_2 : Icons.person_2_outlined), label: "Profile"),
        ]);
  }
}
