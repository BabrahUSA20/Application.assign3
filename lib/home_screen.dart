import 'package:design/calculator.dart';
import 'package:design/sign_in_screen.dart';
import 'package:design/sign_up_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const HomeScreen({super.key, required this.onThemeChanged});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  List<Widget> _screens = [
    SignInScreen(isDarkMode: false),
    SignUpScreen(isDarkMode: false),
    CalculatorScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.blue, Colors.red],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            child: const Text(
              'UBE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: 'Sign In',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.app_registration),
              label: 'Sign Up',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate),
              label: 'Calculator',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        drawer: Drawer(
          child: Container(
            color: _isDarkMode ? Colors.grey[800] : Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.blue, Colors.red],
                    ),
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  leading: Icon(Icons.account_circle, color: _isDarkMode ? Colors.white : Colors.black),
                  title: Text('Sign In', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: 20)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  leading: Icon(Icons.account_circle, color: _isDarkMode ? Colors.white : Colors.black),
                  title: Text('Sign Up', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: 20)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  leading: Icon(Icons.calculate, color: _isDarkMode ? Colors.white : Colors.black),
                  title: Text('Calculator', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: 20)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
                ListTile(
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                        _screens[0] = SignInScreen(isDarkMode: _isDarkMode);
                        _screens[1] = SignUpScreen(isDarkMode: _isDarkMode);
                        widget.onThemeChanged(value ? ThemeMode.dark : ThemeMode.light);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}