import 'package:flutter/material.dart';
import 'package:open_hygiene/screens/profile_screen.dart';
import 'package:open_hygiene/screens/result_page.dart';
import 'package:open_hygiene/screens/search_page.dart';
import 'package:open_hygiene/services/auth_service.dart';

import '../models/establishment_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  Future<List<Establishment>>? _futureEstablishment;
  Map<String, TextEditingController> textEditingControllerMap = {};

  String? _selectedFilter;
  String? _selectedTown;
  String? _selectedName;

  @override
  void initState() {
    super.initState();
    _futureEstablishment = fetchEstablishment();
    textEditingControllerMap['filter'] = TextEditingController();
    textEditingControllerMap['town'] = TextEditingController();
    textEditingControllerMap['name'] = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Search';
      case 1:
        return 'Favorites';
      case 2:
        return 'Profile';
      default:
        return 'Open Hygien';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_getTitle(_selectedIndex)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          SearchPage(establishment: _futureEstablishment,
              textEditingControllerMap: textEditingControllerMap,
              onSelectedFilterChanged: (newFilter) {
                setState(() {
                  _selectedFilter = newFilter;
                });
              },
              onSelectedTownChanged: (newTown) {
                setState(() {
                  _selectedTown = newTown;
                });
              },
              onSelectedNameChanged: (newName) {
                setState(() {
                  _selectedName = newName;
                });
              },
          ),
          ResultPage(establishment: _futureEstablishment,
              selectedFilter: _selectedFilter,
            selectedTown: _selectedTown,
            selectedName: _selectedName,
          ),
          ProfileScreen(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Facilities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
