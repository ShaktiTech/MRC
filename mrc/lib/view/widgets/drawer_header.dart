import 'package:flutter/material.dart';
import 'package:mrc/utils/mycolor.dart';

class DrawerHeaderView extends StatelessWidget {
DrawerHeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 55,
      padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           Container(
                  
                  child: Image.asset('assets/mrc-logo.png',
                       width: 42,
                       height: 42,
                    fit: BoxFit.contain,),
                ),
                SizedBox(width: 5,),
          Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
 Text(
            "Mekong River Commission",
            style: TextStyle(color: MyColor.primaryColor,fontWeight: FontWeight.bold ,fontSize: 14),
          ),
          Text(
            "For Sustainable Development",
            style: TextStyle(
              color: MyColor.primaryColor,
              fontSize: 10,
            ),
          ),
          ],)
        ],
      ),
    );
  }
}

