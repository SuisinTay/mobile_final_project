import 'package:flutter/material.dart';

class ViewPost extends StatefulWidget{
  // ignore: non_constant_identifier_names
  ViewPost({Key? key, required this.Title, required this.Description, required this.Image}) : super(key: key);

  // ignore: non_constant_identifier_names
  final String Title,Description,Image;
  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Post'),
      ),
      body: ListView(
        children: [
          Container(
            child: Image(
              image: NetworkImage(widget.Image)
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: 
            Container(
              padding: EdgeInsets.only(top: 10,left: 5),
              child: Text(
                'Title: ' + widget.Title,
                style: 
                TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: 
            Container(
              padding: EdgeInsets.only(top: 15,left: 5),
              child: Text(
                'Description: ' + widget.Description,
                style: 
                TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}