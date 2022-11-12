// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:crypto_currency_app/app_theme.dart';
import 'package:crypto_currency_app/coin_details.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoinGraphScreen extends StatefulWidget {
  final CoinDetailsModel coinDetailsModel;
  const CoinGraphScreen({
    super.key,
    required this.coinDetailsModel,
  });

  @override
  State<CoinGraphScreen> createState() => _CoinGraphScreenState();
}

class _CoinGraphScreenState extends State<CoinGraphScreen> {
  bool isLoading = true,
      isFirstTime = true,
      isDarkMode = AppTheme.isDarkModeEnabled;
  List<FlSpot> flSpotList = [];
  double minX = 0.0, minY = 0.0, maxX = 0.0, maxY = 0.0;

  @override
  void initState() {
    super.initState();
    getChartData("1");
  }

  ////////
  ///
  ///
  void getChartData(String days) async {
    /////
    ///
    ///
    if (isFirstTime) {
      isFirstTime = false;
    } else {
      setState(() {
        isLoading = true;
      });
    }

    String apiUrl =
        "https://api.coingecko.com/api/v3/coins/${widget.coinDetailsModel.id}/market_chart?vs_currency=inr&days=$days";

    Uri uri = Uri.parse(apiUrl);

    final response = await http.get(uri);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> result = json.decode(response.body);

      List rawList = result["prices"];

      List<List> chartData = rawList.map((e) => e as List).toList();

      List<PriceAndTime> priceAndTimeList = chartData
          .map(
            (e) => PriceAndTime(
              time: e[0] as int,
              price: e[1] as double,
            ),
          )
          .toList();

      /////////
      ///
      flSpotList = [];

      for (var element in priceAndTimeList) {
        flSpotList.add(
          FlSpot(element.time.toDouble(), element.price),
        );
      }

      minX = priceAndTimeList.first.time.toDouble();
      maxX = priceAndTimeList.last.time.toDouble();

      minY = priceAndTimeList.first.price;
      maxY = priceAndTimeList.last.price;

      priceAndTimeList.sort(
        (a, b) => a.price.compareTo(b.price),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,

      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          widget.coinDetailsModel.name,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 22,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      /////////
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: "${widget.coinDetailsModel.name} Price\n",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  "Rs.${widget.coinDetailsModel.currentPrice}\n",
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "${widget.coinDetailsModel.priceChangePercentage24h}\n",
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            TextSpan(
                              text: "Rs.$maxY",
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 200),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: LineChart(
                      LineChartData(
                        minX: minX,
                        minY: minY,
                        maxX: maxX,
                        maxY: maxY,
                        borderData: FlBorderData(
                          show: false,
                        ),
                        titlesData: FlTitlesData(
                          show: false,
                        ),
                        gridData: FlGridData(
                          getDrawingVerticalLine: (value) {
                            return FlLine(strokeWidth: 0);
                          },
                          getDrawingHorizontalLine: (value) {
                            return FlLine(strokeWidth: 0);
                          },
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: flSpotList,
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            getChartData("1");
                          },
                          child: const Text("1d"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            getChartData("15");
                          },
                          child: const Text("15d"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            getChartData("30");
                          },
                          child: const Text("30d"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class PriceAndTime {
  late int time;
  late double price;
  PriceAndTime({
    required this.time,
    required this.price,
  });
}
