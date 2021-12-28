import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import './home.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//var uuid = const Uuid();
//final FirebaseAuth _auth = FirebaseAuth.instance;


class AddChildPage extends StatefulWidget{
  const AddChildPage({Key? key}) : super(key: key);

  @override
  _AddChildPage createState()=> _AddChildPage();
}

class _AddChildPage extends State<AddChildPage>{

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  //final _fs=  FirebaseFirestore.instance;


  TextEditingController nameController = TextEditingController();
  TextEditingController explanationController = TextEditingController();
  TextEditingController destinationDayController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title:  Text("Asi",
          style: GoogleFonts.pacifico(fontSize: 25,color:Colors.white),

        ),
        centerTitle: true,
      ),
      body:
      Form(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0,0,0,12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: MyContainer(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text("Adı",style:TextStyle(
                        color:Colors.black54,fontSize: 20,fontWeight: FontWeight.bold
                    ),
                    ),
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: nameController,
                    ),
                  ],
                )
                ),
              ),
              Expanded(
                flex: 2,
                child: MyContainer(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text("Soyadı",style:TextStyle(
                        color:Colors.black54,fontSize: 20,fontWeight: FontWeight.bold
                    ),
                    ),
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: nameController,
                    ),
                  ],
                )
                ),
              ),

              Expanded(
                flex: 2,
                child: MyContainer(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [

                    Text("${selectedDate.toLocal()}".split(' ')[0],style:TextStyle(
                        color:Colors.black54,fontSize: 20,fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 20.0,),


                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Doğum Tarihini Seçiniz'),
                    ),
                  ],
                )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyContainer extends StatelessWidget {

  final Color colorUser;
  final Widget child;
  const MyContainer({this.colorUser=Colors.white,required this.child,Key? key}) : super(key: key) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      margin: const EdgeInsets.fromLTRB(12,5,12,0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)
        ,color: colorUser,
      ),
    );
  }
}