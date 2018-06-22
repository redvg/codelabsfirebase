import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{

  const MyApp();

  @override
  Widget build(BuildContext context){

    return new MaterialApp(

      title: 'Baby Names',

      home: const HomePage(

        title: 'Baby Names Votes',
      ),
    );
  }
}

class HomePage extends StatelessWidget{

  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context){

    return new Scaffold(

      appBar: new AppBar(

        title: new Text(title),),
      
      body: new StreamBuilder(

        stream: Firestore.instance.collection('babynames').snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) return const Text('loading..');

          return new ListView.builder(

            itemCount: snapshot.data.documents.length,

            padding: const EdgeInsets.only(

              top: 10.0,
            ),

            itemExtent: 25.0,

            itemBuilder: (context, index) {

              DocumentSnapshot documentSnapshot = snapshot.data.documents[index];

              return new Text('${documentSnapshot['name']} ${documentSnapshot['votes']}');
            },
          );
        },
      ),
    );
  }
}