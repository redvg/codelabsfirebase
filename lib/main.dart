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

  Widget _buildListItem(BuildContext context, DocumentSnapshot documentSnapshot){

    return new ListTile(

      key: new ValueKey(documentSnapshot.documentID),

      title: new Container(

        decoration: new BoxDecoration(

          border: new Border.all(

            color: const Color(0x80000000),
          ),

          borderRadius: new BorderRadius.circular(5.0),
        ),

        padding: const EdgeInsets.all(10.0),

        child: new Row(

          children: <Widget>[

            new Expanded(

              child: new Text(documentSnapshot['name']),
            ),

            new Text(documentSnapshot['votes'].toString(),)
          ],
        ),
      ),
      
      onTap: () => Firestore.instance.runTransaction((transaction) async {

        DocumentSnapshot freshDocumentSnapshot = await transaction.get(documentSnapshot.reference);

        await transaction.update(freshDocumentSnapshot.reference, {'votes': freshDocumentSnapshot['votes'] + 1});
      }),
    );
  }

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

            itemExtent: 55.0,

            itemBuilder:  (context, index) => _buildListItem(context, snapshot.data.documents[index]),
          );
        },
      ),
    );
  }
}