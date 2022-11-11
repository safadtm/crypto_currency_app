import 'package:crypto_currency_app/app_theme.dart';
import 'package:crypto_currency_app/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "", email = "", age = "";

  bool isDarkMode = AppTheme.isDarkModeEnabled;

  void getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("name") ?? "";
      email = prefs.getString("email") ?? "";
      age = prefs.getString("age") ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text(
          "CryptoCurrency App",
        ),
      ),
      drawer: Drawer(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
              ),
              accountName: Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              accountEmail: Text(
                email,
                style: TextStyle(
                  fontSize: 17,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              currentAccountPicture: const Icon(
                Icons.account_circle,
                size: 70,
                color: Colors.blue,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfileScreen(),
                  ),
                );
              },
              leading: Icon(
                Icons.account_box,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              title: Text(
                "Update Profile",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 17,
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                prefs.setBool("isDarkMode", isDarkMode);

                setState(() {
                  isDarkMode = !isDarkMode;
                });

                AppTheme.isDarkModeEnabled = isDarkMode;

                await prefs.setBool("isDarkMode", isDarkMode);
              },
              leading: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              title: Text(
                isDarkMode ? "Light Mode" : "Dark Mode",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
