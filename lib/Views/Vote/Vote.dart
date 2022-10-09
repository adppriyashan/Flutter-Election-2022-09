import 'package:auto_size_text/auto_size_text.dart';
import 'package:election_app/Models/Images.dart';
import 'package:election_app/Views/Home/HomeDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:election_app/Models/Colors.dart';
import 'package:election_app/Models/Utils.dart';
import 'package:http/http.dart' as http;

class Vote extends StatefulWidget {
  var dataList;
  var userId;

  Vote({Key? key, required this.dataList, required this.userId})
      : super(key: key);

  @override
  _VoteState createState() => _VoteState(dataList: dataList, userId: userId);
}

class _VoteState extends State<Vote> {
  var dataList;
  var userId;

  _VoteState({required this.dataList, required this.userId});

  final double topSpace = Utils.displaySize.width * 0.4;

  @override
  void initState() {
    super.initState();
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
                            "Vote",
                            style: GoogleFonts.openSans(
                                fontSize: 18.0, color: UtilColors.whiteColor),
                          ),
                          GestureDetector(
                            onTap: () async {},
                            child: Icon(
                              Icons.live_help,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [for (var rec in dataList) getVoteCard(rec)],
                      ),
                    ),
                  ))
            ],
          )),
    ));
  }

  getVoteCard(rec) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        "${rec['name']} (${rec['ref']})",
                        style: GoogleFonts.openSans(
                            fontSize: 16.0, color: UtilColors.blackColor),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      AutoSizeText(
                        rec['party_data']['name'],
                        style: GoogleFonts.openSans(
                            fontSize: 12.0, color: UtilColors.greyColor),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      AutoSizeText(
                        rec['election_data']['election_date'],
                        style: GoogleFonts.openSans(
                            fontSize: 12.0, color: UtilColors.greyColor),
                      ),
                    ],
                  )
                ],
              ),
              TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all(UtilColors.greenColor),
                  ),
                  onPressed: () {
                    submitVote(userId.toString(), rec['id'].toString());
                  },
                  child: const Text('Vote'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitVote(userId, nominator) async {
    Utils.showLoader(context);
    await http
        .get(
            Uri.parse(Utils.apiUrl + 'vote/submit/' + userId + '/' + nominator))
        .then((response) {
      Utils.hideLoaderCurrrent(context);
      if (response.statusCode == 200) {
        if (response.body == '1') {
          Utils.showToast('Successfully Voted');
          Navigator.pop(context);
        }
      } else {
        Utils.showToast('Something Wrong');
      }
    });
  }
}
