import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'dart:convert';
import 'dart:math';
import 'displayhistorypage.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  Random random = new Random();
  late String urlstring;
  late Uri url;
  var Data;
  var json_holder = [];
  bool loading = false;
  List<String> tweet_list = <String>[];
  String sentiment_score = 'a';


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
                suffixIcon: loading
                ? CircularProgressIndicator()
                : GestureDetector(
                onTap: () async {

                  setState(() {
                    loading = true;
                  });

                  Data = await Getdata(url); // json came as a list, must specified index 
                  var DecodedData = jsonDecode(Data);

                  setState(()  {
                    sentiment_score = (DecodedData[0]['score']).toString();

                    for (int i = 0; i < 10; i++) {
                      int randomNumber = random.nextInt(200);
                      tweet_list.add(DecodedData[0]['tweets'][randomNumber]);
                    }

                    loading = false;
                    FocusScope.of(context).unfocus();
                  });

                  // create a json var out of search result
                  var temp = {
                    'Query': DecodedData[0]['Query'],
                    'score': sentiment_score,
                    'tweets': tweet_list,
                  };

                  // Retrieve the data from Firebase Firestore
                  final snapshot = await FirebaseFirestore.instance
                      .collection('Users ID')
                      .doc(user.uid)
                      .get();
                  var retrievedData = snapshot.data();
                  var jsonHolder = [];
                  if (retrievedData != null) {
                    // If there is data in Firebase, append the new data to it
                    jsonHolder = jsonDecode(retrievedData['Data']);
                    jsonHolder.add(temp);
                  } else {
                    // If there is no data in Firebase, create a new JSON object with the new data
                    jsonHolder.add(temp);
                  }

                  // Convert the JSON object to a string and send it to Firebase
                  var tempJSON = jsonEncode(jsonHolder);

                  // send to database
                  try {
                    Map<String, dynamic> admin = {
                      "Data": tempJSON,
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
          ),
          Text(
            sentiment_score,
          ),
          Expanded(         
            child: ListView.builder(
              itemCount: tweet_list.length,
              itemBuilder: (BuildContext context,int index) {
                return Card(
                  child: ListTile(title: Text(tweet_list[index]),)
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
