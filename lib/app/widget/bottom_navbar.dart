import 'package:flutter/material.dart';
import 'package:hm_tracker/constants/color.dart';
import 'package:get/get.dart';

class CustomBottomNavbar extends StatefulWidget {
  const CustomBottomNavbar({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  int selectedIndex = 0;
  onTapped(int index) {
    setState(() {
      selectedIndex = widget.currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: appWhite,
      showSelectedLabels: true,
      currentIndex: selectedIndex,
      showUnselectedLabels: true,
      fixedColor: Colors.black,
      unselectedItemColor: Colors.grey,
      elevation: 10,
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              onTapped(0);
              Get.offNamed('/home');
            },
            icon: Icon(
              Icons.home,
              color: widget.currentIndex == 0 ? primary : Colors.black,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              onTapped(1);
              Get.offNamed('/income');
            },
            icon: Icon(
              Icons.south_west,
              color: widget.currentIndex == 1 ? primary : Colors.black,
            ),
          ),
          label: 'Pemasukan',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              onTapped(2);
              Get.offNamed('/favorite');
            },
            icon: const Icon(Icons.favorite),
            color: widget.currentIndex == 2 ? primary : Colors.black,
          ),
          label: 'Favorit',
        ),
      ],
    );
  }
}
