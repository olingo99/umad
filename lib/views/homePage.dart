import 'package:flutter/material.dart';
import 'userPage.dart';
import 'eventsPage.dart';

class HomePage extends StatefulWidget {
  final int userId;
  const HomePage({Key? key, required this.userId}): super(key: key);

  @override
  _HomePageState createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [];
  _HomePageState();

    @override
    void didChangeDependencies() {
        super.didChangeDependencies();

  print(this.widget);
  _widgetOptions = <Widget>[
    UserPage(userId: widget.userId),
    EventsPage(userId: widget.userId),
    const Text(
      'Index 2: School',
      style: optionStyle,
    ),
    const Text(
      'Index 3: School',
      style: optionStyle,
    ),
  ];
}

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  





  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.userId == 0 ? const Text('Home') : const Text('User'),
        centerTitle: true,
        leading: widget.userId == 0 ? null : IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
