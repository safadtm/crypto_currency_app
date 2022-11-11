import 'package:crypto_currency_app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  Future<void> saveData(String key, String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(key, value);
  }

  void saveUserDetails() async {
    await saveData("name", nameController.text);
    await saveData("email", emailController.text);
    await saveData("age", ageController.text);
  }

  bool isDarkModeEnabled = AppTheme.isDarkModeEnabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkModeEnabled ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text("Profile Update"),
      ),
      body: Column(
        children: [
          customTextField("Name", nameController, false),
          customTextField("Email", emailController, false),
          customTextField("Age", ageController, true),
          ElevatedButton(
            onPressed: () {
              saveUserDetails();
            },
            child: const Text("Save Details"),
          ),
        ],
      ),
    );
  }

  Widget customTextField(
      String title, TextEditingController controller, bool isNum) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        style: TextStyle(
          fontSize: 17,
          color: isDarkModeEnabled ? Colors.white : Colors.black,
        ),
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDarkModeEnabled ? Colors.white : Colors.black,
            ),
          ),
          hintText: title,
          hintStyle: TextStyle(
            color: isDarkModeEnabled ? Colors.white : Colors.black,
          ),
        ),
        keyboardType: isNum ? TextInputType.number : null,
      ),
    );
  }
}
