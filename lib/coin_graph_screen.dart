import 'package:flutter/material.dart';

class CoinGraphScreen extends StatefulWidget {
  final String coinId, coinName;
  const CoinGraphScreen(
      {super.key, required this.coinId, required this.coinName});

  @override
  State<CoinGraphScreen> createState() => _CoinGraphScreenState();
}

class _CoinGraphScreenState extends State<CoinGraphScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          widget.coinName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      /////////
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: "${widget.coinName} Price\n",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    children: const [
                      TextSpan(
                        text: "Rs.1255622.95\n",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: "2.1575\n",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text: "Rs.2054895.23",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
