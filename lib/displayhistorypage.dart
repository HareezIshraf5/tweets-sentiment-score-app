import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class TweetCard extends StatelessWidget {
  final String query;
  final String score;
  final List<String> tweets;

  TweetCard({required this.query,required  this.score,required  this.tweets});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Query: $query'),
            subtitle: Text('Score: $score'),
          ),
          Divider(),
          Column(
            children: tweets.map((tweet) => ListTile(
              title: Text(tweet),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class TweetList extends StatelessWidget {
  final List<dynamic> tweets;

  TweetList({required this.tweets});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      children: tweets.map((tweet) => TweetCard(
        query: tweet['Query'],
        score: tweet['score'],
        tweets: tweet['tweets'].cast<String>(),
      )).toList(),
    );
  }
}

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
            List reversedDecodedHistory = DecodedHistory.reversed.toList();


            return Center(
              child: Column(
                children: <Widget> [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: 
                        TweetList( //listview
                          tweets: reversedDecodedHistory,
                        ),
                    )
                    //"${documentSnapshot['Data']}" - to get whole json
                ]
              ),
            );
            }),
          );
        },
      ),
    );
  }
}
