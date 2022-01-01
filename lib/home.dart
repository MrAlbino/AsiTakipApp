import 'package:asi_takip/vaccinesinfo.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import './children.dart';
import './add_child.dart';
class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState()=> _HomePageState();
}

class _HomePageState extends State<HomePage>{

  GlobalKey _NavKey = GlobalKey();
  var PagesAll = [ChildrenPage(),AddChildPage(),VaccineInfoPage()];

  var myindex =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CurvedNavigationBar(


        backgroundColor: Colors.transparent,

        key: _NavKey,
        items: [
          Icon((myindex == 0) ? Icons.child_care : Icons.child_care_outlined),
          Icon((myindex == 1) ? Icons.local_hospital : Icons.local_hospital_outlined),
          Icon((myindex == 2) ? Icons.article : Icons.article_outlined),
        ],
        buttonBackgroundColor: Colors.white,
        onTap: (index){
          setState(() {
              myindex = index;
          });
        },
        //Curves.fastLinearToSlowEaseIn
       // color: Colors.blue.shade300,
        animationCurve: Curves.fastLinearToSlowEaseIn, color: Colors.blue.shade300,
      ),
      body: PagesAll[myindex],
    );
  }
}
