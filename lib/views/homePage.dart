import 'package:flutter/material.dart';
import 'userPage.dart';
import 'eventsPage.dart';
import 'friendsPage.dart';
import '../constanst.dart';

class HomePage extends StatefulWidget {
  final int userId;                               //Id of the user that is logged in
  const HomePage({Key? key, required this.userId}): super(key: key);

  @override
  _HomePageState createState() =>
      _HomePageState();
}


///Home page widget, holds the bottom navigation bar and the 3 pages that can be accessed from it

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;               //Index of the selected page            
  List<Widget> _widgetOptions = [];     //List of the possible pages
  _HomePageState();

  @override
  void didChangeDependencies() {
      super.didChangeDependencies();

  _widgetOptions = <Widget>[            //Initialize the list of pages
    UserPage(userId: widget.userId),
    EventsPage(userId: widget.userId),
    FriendsPage(userId: widget.userId),
  ];
}

  void _onItemTapped(int index) {      //Change the selected page
    setState(() {                     //Set the state of the widget
      _selectedIndex = index;         //Change the index of the selected page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(                   //App bar of the home page                
        title: const Text('UMad?'),     //Title of the app
        centerTitle: true,
        leading: IconButton(            //Logout button 
          icon: const Icon(Icons.logout, semanticLabel: "Logout icon",),
          onPressed: () {
            Navigator.pop(context);     //Go back to the login page (This navigator only changes between the home page and the login page)
          },
        )
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),  //Show the selected page
      ),
      bottomNavigationBar: BottomNavigationBar(           //Bottom navigation bar
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(                        //Home page button     
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(                      //Events page button                
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(                    //Friends page button             
            icon: Icon(Icons.person),
            label: 'Friends',
          ),
        ],
        currentIndex: _selectedIndex,                 //Index of the selected page
        selectedItemColor: Constants().colorButton,
        onTap: _onItemTapped,                        //Change the selected page               
      ),
    );
  }
}
