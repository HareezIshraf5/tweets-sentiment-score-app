import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
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
  String sentiment_score = '';

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 50, 60, 87),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 50, 60, 87),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
        title: Text(
          "Homepage | ${user.email}",
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: Center(
          child: Container(
              decoration: const BoxDecoration(color: Color(0x323c57)),
              margin: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 60,
                    width: 250.0,
                    child: Text('FeelTweets',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: 35,
                        )),
                  ),
                  TextField(
                    onChanged: (value) {
                      // if this API does not work this mean that :-
                      // this API call towards our hosted API currently will not return anything since it depends on Twitter API, which is currently changed to a paid plan.
                      // Twitter claim that it will be changed on 13 February 2023
                      // the call function can be referred to api.dart
                      // further evaluation process can be made by checking our hosted API github repo
                      // find it here : https://github.com/aminnurrasyid/tweet-sentimentscore-api
                      urlstring =
                          'https://tweet-sentimentscore.herokuapp.com/?Query=' +
                              value.toString();
                      url = Uri.parse(urlstring);
                    },
                    decoration: InputDecoration(
                        hintText: 'Search a  keyword',
                        filled: true,
                        fillColor: Color.fromARGB(255, 220, 225, 231),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 220, 225, 231),
                              width: 2.0),
                        ),
                        suffixIcon: loading
                            ? CircularProgressIndicator()
                            : GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    loading = true;
                                  });

                                  Data = await Getdata(
                                      url); // json came as a list, must specified index
                                  var DecodedData = jsonDecode(Data);

                                  setState(() {
                                    sentiment_score =
                                        (DecodedData[0]['score']).toString();

                                    for (int i = 0; i < 10; i++) {
                                      int randomNumber = random.nextInt(200);
                                      tweet_list.add(DecodedData[0]['tweets']
                                          [randomNumber]);
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
                                  final snapshot = await FirebaseFirestore
                                      .instance
                                      .collection('Users ID')
                                      .doc(user.uid)
                                      .get();
                                  var retrievedData = snapshot.data();
                                  var jsonHolder = [];
                                  if (retrievedData != null) {
                                    // If there is data in Firebase, append the new data to it
                                    jsonHolder =
                                        jsonDecode(retrievedData['Data']);
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
                                    final databaseReference = FirebaseFirestore
                                        .instance
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
                  // ElevatedButton(
                  //  onPressed: () async {
                  //   Map<String, dynamic> admin = {
                  //   "Data": sentiment_score,
                  //  "uid": user.uid
                  // };
                  // final databaseReference = FirebaseFirestore.instance
                  //     .collection('Users')
                  //     .doc(user.uid);
                  //  await databaseReference.set(admin);
                  // },
                  // child: const Text("Save Tweets"),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FirebaseDataPage()),
                      );
                    },
                    child: Text("History"),
                  ),
                  Text(
                    "Sentiment Score : ${sentiment_score}",
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 28, 150, 226),
                      fontSize: 25,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tweet_list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            child: ListTile(
                          title: Text(tweet_list[index]),
                        ));
                      },
                    ),
                  ),
                ],
              ))),
    );
  }
}

