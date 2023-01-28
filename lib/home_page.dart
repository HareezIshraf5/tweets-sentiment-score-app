import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'dart:convert';
import 'displayhistorypage.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  late String urlstring;
  late Uri url;
  var Data;
  String QueryText = 'Query Amin';

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          TextField(
            onChanged: (value) {
              urlstring = 'http://10.0.2.2:5000/api?Query=' + value.toString();
              url = Uri.parse(urlstring);
            },
            decoration: InputDecoration(
                suffixIcon: GestureDetector(
              onTap: () async {
                Data = await Getdata(url);
                var DecodedData = jsonDecode(Data);

                setState(() async {
                  QueryText = (DecodedData['score']).toString();
                  try {
                    Map<String, dynamic> admin = {
                      "Data": QueryText,
                      "uid": user.uid
                    };
                    final databaseReference = FirebaseFirestore.instance
                        .collection('Users ID')
                        .doc(user.uid);
                    await databaseReference.set(admin);
                  } catch (e) {
                    print(e);
                  }
                });
              },
              child: const Icon(Icons.search),
            )),
          ),
          Text(
            QueryText,
          ),
          ElevatedButton(
            onPressed: () async {
              Map<String, dynamic> admin = {"Data": QueryText, "uid": user.uid};
              final databaseReference =
                  FirebaseFirestore.instance.collection('Users').doc(user.uid);
              await databaseReference.set(admin);
            },
            child: const Text("Save Tweets"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FirebaseDataPage()),
              );
            },
            child: Text("History"),
          )
        ],
      )),
    );
  }
}
