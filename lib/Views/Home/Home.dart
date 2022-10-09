import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:election_app/Views/Home/HomeDrawer.dart';
import 'package:election_app/Views/Vote/Vote.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:election_app/Models/Colors.dart';
import 'package:election_app/Models/Utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class HomeUser extends StatefulWidget {
  const HomeUser({Key? key}) : super(key: key);

  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final double topSpace = Utils.displaySize.width * 0.4;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
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
                            onTap: () {
                              if (_scaffoldKey.currentState!.hasDrawer &&
                                  _scaffoldKey.currentState!.isEndDrawerOpen) {
                                _scaffoldKey.currentState!.openEndDrawer();
                              } else {
                                _scaffoldKey.currentState!.openDrawer();
                              }
                            },
                            child: Icon(
                              Icons.menu,
                              color: UtilColors.whiteColor,
                            ),
                          ),
                          AutoSizeText(
                            "Election System",
                            style: GoogleFonts.openSans(
                                fontSize: 18.0, color: UtilColors.whiteColor),
                          ),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                result = null;
                              });
                            },
                            child: Icon(
                              Icons.restore,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Utils.displaySize.width * 0.6,
                            height: Utils.displaySize.width * 0.6,
                            child: QRView(
                              key: qrKey,
                              onQRViewCreated: _onQRViewCreated,
                              overlay: QrScannerOverlayShape(
                                borderColor: (result != null)
                                    ? UtilColors.greenColor
                                    : UtilColors.redColor,
                                borderRadius: 25,
                                borderLength: 30,
                                borderWidth: 10,
                                cutOutSize: 500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          AutoSizeText(
                            "Scan Your QR",
                            style: GoogleFonts.openSans(
                                fontSize: 18.0, color: UtilColors.blackColor),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          AutoSizeText(
                            "Please scan your qr code to vote",
                            style: GoogleFonts.openSans(
                                fontSize: 13.0, color: UtilColors.greyColor),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          (result == null)
                              ? const SizedBox.shrink()
                              : TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        UtilColors.greenColor),
                                    foregroundColor: MaterialStateProperty.all(
                                        UtilColors.whiteColor),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      goNow();
                                    });
                                  },
                                  child: const Text('Scan Complete, Vote Now.'))
                        ],
                      ),
                    ),
                  ))
            ],
          )),
    ));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> goNow() async {
    print('hello');
    Utils.showLoader(context);
    await http
        .get(Uri.parse('${Utils.apiUrl}elections/nominators/${result!.code}'))
        .then((response) {
      Utils.hideLoaderCurrrent(context);
      if (response.statusCode == 200) {
        if (response.body == "2") {
          Utils.showToast(
              "You have already votes or no available election found.");
        } else {
          print(response.body);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => Vote(
                      dataList: jsonDecode(response.body),
                      userId: result!.code)));
        }
      }
    });
  }
}
