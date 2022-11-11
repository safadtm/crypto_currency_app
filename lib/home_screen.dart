import 'dart:convert';

import 'package:crypto_currency_app/coin_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crypto_currency_app/app_theme.dart';
import 'package:crypto_currency_app/update_profile_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url =
      "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=100&page=1&sparkline=false";

  String name = "", email = "", age = "";

  bool isDarkMode = AppTheme.isDarkModeEnabled;

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  void getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("name") ?? "";
      email = prefs.getString("email") ?? "";
      age = prefs.getString("age") ?? "";
    });
  }

  ///////
  Future<List<CoinDetailsModel>> getCoinsDetails() async {
    Uri uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200 || response.statusCode == 201) {
      List coinsData = json.decode(response.body);

      List<CoinDetailsModel> data =
          coinsData.map((e) => CoinDetailsModel.fromJson(e)).toList();

      return data;
    } else {
      return <CoinDetailsModel>[];
    }
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getCoinsDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _globalKey.currentState!.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        title: Text(
          "CryptoCurrency App",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
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

      /////////////////////////////////////BODY//////////////

      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefix: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  hintText: "Search for a coin",
                ),
              ),
            ),

            //////////

            Expanded(
              child: FutureBuilder(
                future: getCoinsDetails(),
                builder:
                    (context, AsyncSnapshot<List<CoinDetailsModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return coinDetails(snapshot.data![index]);
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("Error Occured"),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget coinDetails(CoinDetailsModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: SizedBox(
          height: 50,
          width: 50,
          child: Image.network(model.image),
        ),
        title: Text(
          "${model.name}\n${model.symbol}",
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
            text: "Rs.${model.currentPrice}\n",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: "${model.priceChangePercentage24h}",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
