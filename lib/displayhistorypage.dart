import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDataPage extends StatefulWidget {
  FirebaseDataPage({Key? key}) : super(key: key);

  @override
  _FirebaseDataPageState createState() => _FirebaseDataPageState();
}

class _FirebaseDataPageState extends State<FirebaseDataPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('Users');

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  String query_keyword = '';
  String sentiment_score = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
        title: Text("Firebase Data"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users ID')
            .where("uid", isEqualTo: user.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading... noo");
          }
          
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) {
              final DocumentSnapshot documentSnapshot =
                  snapshot.data!.docs[index];

            List DecodedHistory = jsonDecode(documentSnapshot['Data']);

            final item =  DecodedHistory[0]['tweets'];

              return Center(
                child: Column(
                  children: <Widget>[
                    Expanded(         
                      child: ListView.builder(
                        itemCount: item.length,
                        itemBuilder: (BuildContext context,int index) {
                          return Card(
                            child: ListTile(title: Text(item[index]),)
                          );
                        },
                      ),
                    ),
                    //Container(
                    //  padding: const EdgeInsets.all(8),
                    //  child: ClipRRect(
                    //    borderRadius: BorderRadius.circular(8),
                    //    child: Text(
                    //      DecodedHistory[0]['tweets'][0],
                    //    ),
                    //  ),
                    //),
                    //Padding(
                    //  padding: const EdgeInsets.all(8.0),
                    //  child: Text(
                    //    //DecodedHistory[0]['tweets'],  // to access the list
                    //    DecodedHistory[0]['tweets'][0], 
                    //    // DecodedHistory.length - to get the length of json
                    //    //"${documentSnapshot['Data']}" - to get whole json
                    //  ),
                    //),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
