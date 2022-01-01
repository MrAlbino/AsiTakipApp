import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom_dialog.dart';
import 'login.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class VaccineInfoPage extends StatefulWidget{


  const VaccineInfoPage({Key? key}) : super(key: key);

  @override
  _VaccineInfoPageState createState()=> _VaccineInfoPageState();
}


class _VaccineInfoPageState extends State<VaccineInfoPage>{
  final _fs=  FirebaseFirestore.instance;


  Color getMyColor(bool isExist) {
    if (isExist) {
      return Colors.green;
    }
    return Colors.red;

  }


  @override
  Widget build(BuildContext context) {
    CollectionReference vaccinesRef= _fs.collection('Vaccines');


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title:  Text('Aşılar',
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
                  stream: vaccinesRef.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot1){
                    return StreamBuilder<QuerySnapshot>(
                      /// Neyi dinlediğimiz bilgisi, hangi streami
                      stream: vaccinesRef.snapshots(),
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
                                          '${listOfDocumentSnap[index]['name']}',
                                          style: const TextStyle(fontSize: 24)),
                                      subtitle: Text(
                                          "Aşı Günü: "+(listOfDocumentSnap[index]['ejectionDay']).toString(),
                                          style: const TextStyle(fontSize: 16)),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                          children: [

                                      IconButton(
                                      icon: const Icon(Icons.info),
                                      color: Colors.green,
                                      onPressed: () async {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) => AlertDialog(
                                            title: Text('${listOfDocumentSnap[index]['name']}'),
                                            content: Text('${listOfDocumentSnap[index]['description']}'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, 'OK'),
                                                child: Text('TAMAM'),
                                              ),
                                            ],
                                          ),
                                        );

                                      },
                                    ),]


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
                    );}
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
    }
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
