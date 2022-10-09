import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:election_app/Models/Images.dart';
import 'package:election_app/Views/Home/HomeDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:election_app/Models/Colors.dart';
import 'package:election_app/Models/Utils.dart';
import 'package:http/http.dart' as http;

class Results extends StatefulWidget {
  Results({Key? key}) : super(key: key);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  var dataList = [];

  final double topSpace = Utils.displaySize.width * 0.4;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      drawer: Drawer(
        child: HomeDrawer(
          selection: 1,
        ),
      ),
      backgroundColor: UtilColors.primaryColor,
      body: SizedBox(
          width: Utils.displaySize.width,
          height: Utils.displaySize.height,
          child: Column(
            children: [
              Expanded(
                  flex: 0,
                  child: Container(
                    decoration: BoxDecoration(color: UtilColors.primaryColor),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 18.0, bottom: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: UtilColors.whiteColor,
                            ),
                          ),
                          AutoSizeText(
                            "Results",
                            style: GoogleFonts.openSans(
                                fontSize: 18.0, color: UtilColors.whiteColor),
                          ),
                          GestureDetector(
                            onTap: () async {
                              getData();
                            },
                            child: Icon(
                              Icons.refresh,
                              color: UtilColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: UtilColors.whiteColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 15.0, left: 15.0, right: 15.0),
                      child: (dataList.isEmpty)
                          ?const Align(
                            alignment: Alignment.center,
                            child: Text('No Data Found'),
                          )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (var rec in dataList) getResultsCard(rec)
                              ],
                            ),
                    ),
                  ))
            ],
          )),
    ));
  }

  getResultsCard(rec) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: SizedBox(
                        height: Utils.displaySize.width * 0.1,
                        child: Image.asset(UtilImages.logoPNG),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          rec['name'].toString(),
                          style: GoogleFonts.openSans(
                              fontSize: 14.0, color: UtilColors.blackColor),
                        ),
                        AutoSizeText(
                          (rec['type'].toString()=='1')?"Presidential Election":"Provincial Election",
                          style: GoogleFonts.openSans(
                              fontSize: 12.0, color: UtilColors.greyColor),
                        ),
                        AutoSizeText(
                          rec['election_date'].toString(),
                          style: GoogleFonts.openSans(
                              fontSize: 12.0, color: UtilColors.greyColor),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20.0),
                AutoSizeText(
                  "Nominators Result",
                  style: GoogleFonts.openSans(
                      fontSize: 15.0, color: UtilColors.blackColor),
                ),
                const SizedBox(height: 10.0),
                for (var nominator in rec['nominators_data'])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          nominator['name'].toString(),
                          style: GoogleFonts.openSans(
                              fontSize: 13.0, color: UtilColors.greyColor),
                        ),
                        AutoSizeText(
                          "Votes : ${nominator['vote_count']}",
                          style: GoogleFonts.openSans(
                              fontSize: 12.0, color: UtilColors.greenColor),
                        ),
                      ],
                    ),
                  )
              ],
            )),
      ),
    );
  }

  Future<void> getData() async {
    Utils.showLoader(context);
    await http
        .get(Uri.parse('${Utils.apiUrl}elections/results'))
        .then((response) {
      print(response.body);
      Utils.hideLoaderCurrrent(context);
      if (response.statusCode == 200) {
        setState(() {
          dataList = jsonDecode(response.body);
        });
      } else {
        Utils.showToast('Something Wrong');
      }
    });
  }
}
