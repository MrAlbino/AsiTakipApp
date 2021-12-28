import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import './home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
var uuid = const Uuid();
final FirebaseAuth _auth = FirebaseAuth.instance;


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

  final _fs=  FirebaseFirestore.instance;


  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    CollectionReference childrenRef= _fs.collection('Children');
    CollectionReference usersRef= _fs.collection('Users');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title:  Text("Cocuk ekle",
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
                      decoration: InputDecoration(

                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                      decoration: InputDecoration(

                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      controller: surnameController,
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
              Expanded(
                flex: 1,

                child: TextButton(
                  onPressed: () async{
                    User? user =_auth.currentUser;
                    String userId = user!.uid;
                    Map<String, dynamic> childData= {
                      'name': nameController.text,
                      'surname': surnameController.text,
                      'parent': userId,
                      'birthOfDate': selectedDate,
                    };

                    var id=uuid.v4();
                    await childrenRef.doc((id)).set(childData);

                    await usersRef.doc(userId).update({'children':FieldValue.arrayUnion([id])});
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder:(context)=> HomePage()));
                  },
                  child: const Text('Oluştur'),
                  style: ButtonStyle(elevation: MaterialStateProperty.all(2), shape: MaterialStateProperty.all(const CircleBorder()),
                    backgroundColor: MaterialStateProperty.all(Colors.indigo), foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
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