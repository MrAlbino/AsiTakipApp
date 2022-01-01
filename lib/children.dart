import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import './vaccine.dart';
import 'custom_dialog.dart';
import 'login.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;

class ChildrenPage extends StatefulWidget{
  const ChildrenPage({Key? key}) : super(key: key);

  @override
  _ChildrenPageState createState()=> _ChildrenPageState();
}


class _ChildrenPageState extends State<ChildrenPage>{
  final _fs=  FirebaseFirestore.instance;

  Color getMyColor(DateTime date, bool done) {
    if (done) {
      return Colors.green;
    } else if(DateTime.now().isBefore(date)){
      return Colors.orange.shade200;
    }
    else{
      return Colors.red.shade500;
    }

  }


  @override
  Widget build(BuildContext context) {
    CollectionReference todosRef= _fs.collection('Children');
    CollectionReference _usersRef= _fs.collection('Users');
    final User? user =_auth.currentUser;
    final userId = user!.uid;
    final now = DateTime.now();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title:  Text("Çocuklarım",
          style: GoogleFonts.pacifico(fontSize: 25,color:Colors.white),

        ),
        centerTitle: true,

        actions: <Widget>[
          // First button - decrement
          IconButton(
              icon: const Icon(Icons.logout_outlined), // The "-" icon
              onPressed:() {

                _showDialog(context);
              } // The `_decrementCounter` function
          ),

          // Second button - increment
        ],

      ),
      body:Center(
        child: Container(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                /// Neyi dinlediğimiz bilgisi, hangi streami
                stream: todosRef.where('parent' ,isEqualTo: userId).snapshots(),
                /// Streamden her yerni veri aktığında, aşağıdaki metodu çalıştır
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return const Center(
                        child: Text('Bir Hata Oluştu, Tekrar Deneyiniz'));
                  } else {
                    if (asyncSnapshot.hasData) {
                      List<DocumentSnapshot> listOfDocumentSnap =
                          asyncSnapshot.data.docs;
                      return Flexible(
                        child: ListView.builder(
                          itemCount: listOfDocumentSnap.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(
                                    '${listOfDocumentSnap[index]['name']+" "+listOfDocumentSnap[index]['surname']}',
                                    style: const TextStyle(fontSize: 24)),
                                subtitle: Text(
                                    DateFormat('dd-MM-yyyy').format(DateTime.parse((listOfDocumentSnap[index]['birthOfDate']).toDate().toString())),
                                    style: const TextStyle(fontSize: 16)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        var todoId= listOfDocumentSnap[index].id;
                                        await listOfDocumentSnap[index]
                                            .reference
                                            .delete();
                                        _usersRef.doc(userId).update({'children':FieldValue.arrayRemove([todoId])});
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_forward),
                                      onPressed: ()  {
                                        var userAge=daysBetween(DateTime.parse((listOfDocumentSnap[index]['birthOfDate']).toDate().toString()),now);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => VaccinePage(
                                             childId : listOfDocumentSnap[index].id,
                                             childName:listOfDocumentSnap[index]['name'],
                                             childSurname:listOfDocumentSnap[index]['surname'],
                                             userDay:userAge
                                          )),
                                        );

                                      },
                                    ),
                                    ]
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  _showDialog(BuildContext context){
    BlurryDialog  alert = BlurryDialog("Are you sure you want to exit?",()
    {
      Navigator.of(context).pop();
      _auth.signOut();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder:(context)=> LoginPage()));
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

