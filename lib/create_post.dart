import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile_project/home.dart';
import 'package:web_socket_channel/io.dart';

// ignore: camel_case_types
class Create_Post extends StatefulWidget{
  @override
  _Create_PostState createState() => _Create_PostState();
}

class _Create_PostState extends State<Create_Post> {
  final titleText = TextEditingController();

  final descText = TextEditingController();

  final imageText = TextEditingController();

  final channel = IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

  void signInProcess(){
    channel.sink.add('{"type": "sign_in","data": {"name": "tay"}}');
  }

  createPostRequest(){
    String titleCheck = titleText.text;
    String descCheck = descText.text;
    String imageCheck = imageText.text;

    if(titleCheck == '' || descCheck == '' || imageCheck == ''){
      final snackBar = SnackBar(
        content: const Text('Fill Up All The Fields'),
        action: SnackBarAction(
          label: 'X', 
          onPressed: (){}
        ),
      );

      // ScaffoldMessenger.of(this.context).showSnackBar(snackBar);
      print("Empty");
    }
    else{
      channel.stream.listen((event) {
        final decodedMessage = jsonDecode(event);
        print(decodedMessage);

        channel.sink.close();
      });

      channel.sink.add('{"type": "create_post","data": {"title": "$titleCheck","description": "$descCheck","image": "$imageCheck"}}');

      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context)=>Home()
        )
      );
    }
  }

  @override
  void initState() {
    super.initState();
    signInProcess();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Post Request',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Post Request'),
        ),
        backgroundColor: Colors.green[100],
        body: Container(
          // color: Colors.teal,
          margin: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Title: '),
                  ]
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10,top: 5),
                  height: 50,
                  width: 400,
                  child: 
                    TextField(
                      controller: titleText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title'),
                    ),
                ),
                Row(
                  children: [
                    Text('Description:'),
                  ]
                ),
                Container(
                  height: 80,
                  width: 400,
                  padding: EdgeInsets.only(bottom: 10,top: 5),
                  child: TextField(
                    controller: descText,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description'
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text('Image Url: '),
                  ],
                ),
                Container(
                  height: 80,
                  padding: EdgeInsets.only(top: 5),
                  child: TextField(
                    controller: imageText,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Image Url',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 260),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          createPostRequest();
                        }, 
                        child: Text('Create Post')
                      ),
                      ElevatedButton(
                        onPressed: (){
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context)=>Home()
                            )
                          );
                        }, 
                        child: Text('Cancel')
                      )
                    ],
                  ),
                )
              ],
            )
          )
        ),
      ),
    );
  }
}