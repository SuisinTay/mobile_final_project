import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/home.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final signUpText = TextEditingController();

  final String _imageUrl =
  'https://appsgeyser.com/geticon.php?widget=Deriv%20App_12008741&width=512';

  textFieldChecking(){
    String signUpTextField;

    signUpTextField = signUpText.text;

    if(signUpTextField == ''){
      final snackBar = SnackBar(
        content: const Text('Sign Up Field is Empty'),
        action: SnackBarAction(
          label: 'X', 
          onPressed: (){}
        ),
      );

      ScaffoldMessenger.of(this.context).showSnackBar(snackBar);
    }
    else{
      final channel = IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

      channel.stream.listen((message) {
        final decodedMessage = jsonDecode(message);
        if(decodedMessage['data']['response'] == 'OK'){
          Navigator.push(
            this.context, 
            MaterialPageRoute(
              builder: (context)=>Home()
            )
          );
        }
        else{
          final snackBar = SnackBar(
            content: const Text('Error Connecting to Websocket'),
            action: SnackBarAction(
              label: 'X', 
              onPressed: (){}
            ),
          );

          ScaffoldMessenger.of(this.context).showSnackBar(snackBar);
        }
        channel.sink.close();
      });

      channel.sink.add('{"type": "sign_in","data": {"name": "$signUpTextField"}}');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.purple[100],
      body: Center(
        child: SingleChildScrollView(
          child: 
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                width: 340,
                height: 100,
                child:
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(width: 20.0, height: 100.0),
                    const Text(
                      'Be',
                      style: TextStyle(fontSize: 43.0,fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20.0, height: 100.0),
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Italic',
                        color: Colors.red
                      ),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          RotateAnimatedText('Square'),
                          RotateAnimatedText('OPTIMISTIC'),
                          RotateAnimatedText('AWESOME'),
                        ],
                      ),
                    ),
                  ],
                ), 
              ),
              // Text('Welcome to Besquare',
              // style: 
              //   TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold
              //   ),
              // ),
              AnimatedContainer(
                duration: const Duration(seconds: 2),
                curve: Curves.bounceIn,
                padding: EdgeInsets.only(top: 20,bottom: 20),
                width: 400,
                child: Image(
                  width: 300,
                  height: 200,
                  image: NetworkImage(_imageUrl),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:10),
                // padding: EdgeInsets.only(top: 20),
                width: 300,
                height: 30,
                child: 
                TextField(
                  controller: signUpText,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.people),
                    border: OutlineInputBorder(),
                    labelText: 'Username'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 150),
                child: 
                  Container(
                    width: 300,
                    height: 30,
                    child:
                    ElevatedButton(
                      child: Text('Sign In'),
                      onPressed: textFieldChecking,
                    ),
                  ),
              ),
              
            ],
          ),
        )
      ),
      //This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
