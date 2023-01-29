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
  String sentiment_score = '';
  String tweet_selected = '';

  var temp = {
    'Query': "Party",
    'score': 0.3,
    'tweets': "[b'hi']",
  };


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
              urlstring = 'https://tweet-sentimentscore.herokuapp.com/?Query=' + value.toString();
              url = Uri.parse(urlstring);
            },
            decoration: InputDecoration(
                suffixIcon: GestureDetector(
              onTap: () async {
                Data = await Getdata(url);
                var DecodedData = jsonDecode(Data);
                DecodedData.add(temp);

                setState(()  {
                  sentiment_score = (DecodedData[0]['score']).toString();

                  for (int i = 0; i < 10; i++) {
                    print(i);
                  } 
                  tweet_selected = (DecodedData[0]['tweets'][1]).toString();

                });

                // retrieve


                // send to database
                try {
                  Map<String, dynamic> admin = {
                    "Data": DecodedData,
                    "uid": user.uid
                  };
                  final databaseReference = FirebaseFirestore.instance
                      .collection('Users ID')
                      .doc(user.uid);
                  await databaseReference.set(admin);
                } catch (e) {
                  print(e);
                }
              },
              child: const Icon(Icons.search),
            )),
          ),
          Text(
            sentiment_score,
          ),
          Text(
            tweet_selected,
          ),
          ElevatedButton(
            onPressed: () async {
              Map<String, dynamic> admin = {"Data": sentiment_score, "uid": user.uid};
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
