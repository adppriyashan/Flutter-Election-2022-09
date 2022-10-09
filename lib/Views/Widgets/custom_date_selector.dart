import 'package:election_app/Models/Colors.dart';
import 'package:election_app/Models/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomDateSelectorWithImage extends StatefulWidget {
  double height = 5.0;
  String hint;
  var initText;
  IconData icon_img;
  bool isIconAvailable;
  Color backgroundColor;
  var onConfirm;
  int type;

  static int TIME_SELECTOR = 1;
  static int DATE_SELECTOR = 2;
  static int DATE_TIME_SELECTOR = 3;

  CustomDateSelectorWithImage(
      {Key? key,
      required this.height,
      this.initText,
      required this.hint,
      required this.isIconAvailable,
      required this.icon_img,
      required this.backgroundColor,
      required this.type,
      required this.onConfirm})
      : super(key: key);

  @override
  State<CustomDateSelectorWithImage> createState() =>
      _CustomDateSelectorWithImageState(
          height: height,
          hint: hint,
          initText: initText,
          type: type,
          isIconAvailable: isIconAvailable,
          icon_img: icon_img,
          onConfirm: onConfirm,
          backgroundColor: this.backgroundColor);
}

class _CustomDateSelectorWithImageState
    extends State<CustomDateSelectorWithImage> {
  double height = 5.0;
  String hint;
  var initText;
  IconData icon_img;
  bool isIconAvailable;
  Color backgroundColor;
  var onConfirm;
  int type;

  static int TIME_SELECTOR = 1;
  static int DATE_SELECTOR = 2;
  static int DATE_TIME_SELECTOR = 3;

  String selectedText = '';

  _CustomDateSelectorWithImageState(
      {required this.height,
      required this.hint,
      required this.initText,
      required this.isIconAvailable,
      required this.backgroundColor,
      required this.icon_img,
      required this.type,
      required this.onConfirm});

  @override
  void initState() {
    initValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (initText != null) {
      selectedText = initText;
    }

    return Container(
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(5.0)),
      padding: EdgeInsets.symmetric(vertical: height, horizontal: 10.0),
      child: Row(
        children: [
          Icon(
            icon_img,
            color: UtilColors.primaryColor,
          ),
          Flexible(
              child: GestureDetector(
            onTap: () async {
              if (TIME_SELECTOR == type) {
                await DatePicker.showTimePicker(context,
                    showTitleActions: true,
                    showSecondsColumn: false,
                    theme: DatePickerTheme(backgroundColor: backgroundColor),
                    onConfirm: (time) {
                  onConfirm(time);
                  setState(() {
                    selectedText = Utils.formatTime(time);
                  });
                }, onChanged: (time) {
                  setState(() {
                    selectedText = Utils.formatTime(time);
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              } else if (DATE_TIME_SELECTOR == type) {
                await DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    theme: DatePickerTheme(backgroundColor: backgroundColor),
                    onConfirm: (time) {
                  onConfirm(time);
                  setState(() {
                    selectedText = Utils.formatDateTime(time);
                  });
                }, onChanged: (time) {
                  setState(() {
                    selectedText = Utils.formatDateTime(time);
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              } else {
                await DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    theme: DatePickerTheme(backgroundColor: backgroundColor),
                    onConfirm: (date) {
                  onConfirm(date);
                  setState(() {
                    selectedText = Utils.formatDate(date);
                  });
                }, onChanged: (date) {
                  setState(() {
                    selectedText = Utils.formatDate(date);
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              }
            },
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hint,
                      style: TextStyle(
                          fontFamily: 'Raleway-SemiBold',
                          color: UtilColors.blackColor,
                          fontSize: 11.0),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      (initText == null) ? selectedText : initText,
                      style: TextStyle(
                          fontFamily: 'Raleway-Medium',
                          color: UtilColors.blackColor,
                          fontSize: 15.0),
                    )
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  void initValues() {
    setState(() {
      if (TIME_SELECTOR == type) {
        selectedText = Utils.formatDateTime(DateTime.now());
      } else {
        selectedText = Utils.formatDateTime(DateTime.now());
      }
    });
  }
}
