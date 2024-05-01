import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrc/utils/mycolor.dart';

class CustomDialogWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showDialogclass(context, "", ""),
    );
  }

  showDialogclass(BuildContext context, String title, String text) {
    return showDialog(
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0,10.0,10.0,10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.error,
                      color: Colors.red,
                    )),
                  //   TextSpan(
                  //     text: title,
                  //     style:
                  //         GoogleFonts.openSans(
                  //   color: MyColor.titleColor,
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 20.0,
                  
                  // )
                  //   ),
                  ],
                ),
              ),
               SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.left,
                style: GoogleFonts.openSans(
                    color: MyColor.kBlackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  
                  )
              ),
              // Text(
              //   '\u{26A0} ${title}',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              // ),
              SizedBox(height: 12),
              Text(
                text,
                textAlign: TextAlign.left,
                style: GoogleFonts.openSans(
                    color: MyColor.textligth,
                    // fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  
                  ),
              ),
              SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: MyColor.cborder),
                  child: Text('Close', style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    
                    ),),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            ],
          ),
        ),
      ),
      context: context,
      barrierDismissible: false,
    );
  }
}
