import 'package:auto_size_text/auto_size_text.dart';
import 'package:election_app/Models/Colors.dart';
import 'package:election_app/Models/Images.dart';
import 'package:election_app/Models/Utils.dart';
import 'package:election_app/Views/Results/Results.dart';
import 'package:election_app/Views/Vote/Vote.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomeDrawer extends StatefulWidget {
  int selection = 1;

  HomeDrawer({Key? key, required selection}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState(selection: selection);
}

class _HomeDrawerState extends State<HomeDrawer> {
  int selection;

  _HomeDrawerState({required this.selection});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 20.0,
        ),
        SizedBox(
          height: Utils.displaySize.width * 0.3,
          child: Image.asset(UtilImages.logoPNG),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Align(
          alignment: Alignment.center,
          child: AutoSizeText(
            "Election System",
            style: GoogleFonts.openSans(
                fontSize: 18.0, color: UtilColors.primaryColor),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        ListTile(
          tileColor: UtilColors.whiteColor,
          leading: Icon(
            Icons.home,
            color: UtilColors.blackColor.withOpacity(0.8),
          ),
          title: Text(
            'Home',
            style: GoogleFonts.openSans(
                color: UtilColors.blackColor, fontWeight: FontWeight.w400),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: UtilColors.primaryColor,
            size: 15.0,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => Results()));
          },
          tileColor: UtilColors.whiteColor,
          leading: Icon(
            Icons.airplane_ticket,
            color: UtilColors.blackColor.withOpacity(0.8),
          ),
          title: Text(
            'Results',
            style: GoogleFonts.openSans(
                color: UtilColors.blackColor, fontWeight: FontWeight.w400),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: UtilColors.primaryColor,
            size: 15.0,
          ),
        )
      ],
    );
  }
}
