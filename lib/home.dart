import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_project/create_post.dart';
import 'package:mobile_project/view_posts.dart';
import 'package:web_socket_channel/io.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _items = [];

  final channel = IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

  void readAPI()async{
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      List _tempList = [];
      for(int i = 0; i < decodedMessage['data']['posts'].length; i++){
        _tempList.add(decodedMessage['data']['posts'][i]);
      }
      setState(() {
        _items = _tempList;
      });
      channel.sink.close();
    });
    channel.sink.add('{"type": "get_posts","data": {"lastId": "","sortBy": "date"}}');
  }

  // void sortByAlpha(){
  //   _items = [];
  //   channel.stream.listen((message) {
  //     final decodedMessage = jsonDecode(message);
  //     List _tempList = [];
  //     for(int i = 0; i < decodedMessage['data']['posts'].length; i++){
  //       _tempList.add(decodedMessage['data']['posts'][i]);
  //     }
  //     setState(() {
  //       _items = _tempList;
  //     });
  //     channel.sink.close();
  //   });
  //   channel.sink.add('{"type": "get_posts","data": {"lastId": "","sortBy": "alphabet"}}');
  // }

  deletePost(int index,String passedID,String passedAuthor){
    final channel = IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
    print(index);
    channel.stream.listen((event) {print(event);});
    channel.sink.add('{"type": "sign_in","data": {"name": "$passedAuthor"}}');
    setState(() {
      _items.removeAt(index);
    channel.sink.add('{"type": "delete_post","data": {"postId": "$passedID"}}');
    });
    // channel.sink.close();
  }

  String sortImage (String imgUrl, bool containKey){
    try {
     return Uri.parse(imgUrl)
    .isAbsolute &&
    containKey
    ? '${imgUrl}'
    : 'https://i.pinimg.com/564x/06/60/e9/0660e9e63f1059921cce2de4f8f0d509.jpg';
    } catch (e) {
return 'https://i.pinimg.com/564x/06/60/e9/0660e9e63f1059921cce2de4f8f0d509.jpg';
    }
    
  }

  @override
  void initState() {
    super.initState();
    readAPI();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Post Requests'),
        ),
        backgroundColor: Colors.orange[50],
        body: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.yellow),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: 
                        IconButton(
                          onPressed: (){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context)=>Create_Post()
                              )
                            );
                          }, 
                          icon: Icon(Icons.add)
                        ),
                    ),
                    Expanded(
                      flex: 1,
                      child: 
                        Container(
                          child: 
                            Text('')
                        )
                    ),
                    Container(
                      child: 
                        IconButton(
                          onPressed: (){
                            // sortByAlpha();
                          }, 
                          icon: Icon(Icons.sort_by_alpha)
                        ),
                    ),
                    Container(
                      child: 
                        IconButton(
                          onPressed: (){}, 
                          color: Colors.red,
                          icon: Icon(Icons.favorite)
                        ),
                    ),
                  ],
                ),
              ),
              _items.isNotEmpty ? Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context,index){
                    return InkWell(
                      child: 
                      AnimatedContainer(
                        duration: const Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn,
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blue,width: 2))),
                        margin: const EdgeInsets.all(10),
                        padding: EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Image(
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    // Appropriate logging or analytics, e.g.
                                    // myAnalytics.recordError(
                                    //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                                    //   exception,
                                    //   stackTrace,
                                    // );
                                    return const Text('Error');
                                  },
                                  height: 80,
                                  width: 100,
                                  image: 
                                  NetworkImage(sortImage(_items[index]['image'], _items[index].containsKey('image')),
                                  ),
                                  ),
                                ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Align(alignment: Alignment.centerLeft,child: Text('Title: ${_items[index]["title"]}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),),
                                  Align(alignment: Alignment.centerLeft,child: 
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 4),
                                      child: Text('Description: ${_items[index]["description"]}',style: TextStyle(fontSize: 10,color: Colors.grey),),
                                    ),
                                  ),
                                  Align(alignment: Alignment.centerLeft,child: Text('Create Date: ${_items[index]["date"]}',style: TextStyle(fontSize: 12,color: Colors.indigo),)),
                                ],
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: (){
                                      // print(_items[index]["_id"]);
                                      deletePost(index,_items[index]["_id"],_items[index]["author"]);
                                    }, 
                                    color: Colors.grey,
                                    icon: Icon(Icons.delete)),
                                  IconButton(
                                    onPressed: (){}, 
                                    color: Colors.red,
                                    icon: Icon(Icons.favorite))
                                ],
                              )
                            ),
                          ],
                        ),
                      ),
                      onTap: (){
                        final textTitle = _items[index]["title"];
                        final textDesc = _items[index]["description"];
                        final textImage = _items[index]["image"];
                        
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context)=>ViewPost(Title: textTitle,Description: textDesc,Image: textImage,)
                              )
                            );
                      },
                    );
                    }
                )
              ) : Container()
            ],
          ),
      ),
    );
  }
}
