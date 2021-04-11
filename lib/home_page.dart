import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var myBoldTextStyle = TextStyle(
    fontSize: 35.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    decoration: TextDecoration.none,
    fontFamily: 'Cabin Sketch Bold',
    letterSpacing: 3,
  );

  var myRegularTextStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    decoration: TextDecoration.none,
    fontFamily: 'Cabin Sketch Regular',
    letterSpacing: 3,
  );

  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = "625a7118fed3ff3cf39b18e5044efad0a89b1a12";

  TextEditingController _controller = TextEditingController();

  StreamController _streamController;
  Stream _stream;

  Timer _debounce;

  _search() async {
    if (_controller.text == null || _controller.text.length == 0) {
      _streamController.add(null);
      return;
    }

    _streamController.add("waiting");
    Response response = await get(Uri.parse(_url + _controller.text.trim()),
        headers: {"Authorization": "Token " + _token});
    _streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();

    _streamController = StreamController();
    _stream = _streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
          child: Text(
            "WICKTIONARY",
            style: myBoldTextStyle,
          ),
        )),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 12.0, bottom: 20.0, top: 22.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextFormField(
                    onChanged: (String text) {
                      if (_debounce?.isActive ?? false) _debounce.cancel();
                      _debounce = Timer(const Duration(milliseconds: 1000), () {
                        _search();
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: "Search a word",
                        contentPadding: const EdgeInsets.only(left: 24.0),
                        border: InputBorder.none,
                        hintStyle:
                            myRegularTextStyle.copyWith(color: Colors.grey)),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  _search();
                },
              )
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text(
                  "Type something in search bar 😇",
                  style: myRegularTextStyle.copyWith(fontSize: 20.0),
                ),
              );
            }
            print("Hi Error");

            print(snapshot.data);

            try {
              if (snapshot.data[0]["message"] == "No definition :(") {
                return Center(
                  child: Text(
                    "No definition found 🥺",
                    style: myRegularTextStyle.copyWith(
                      fontSize: 20.0,
                    ),
                  ),
                );
              }
            } catch (e) {
              if (snapshot.data == "waiting") {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data["definitions"].length,
                itemBuilder: (BuildContext context, int index) {
                  return ListBody(
                    children: <Widget>[
                      Container(
                        color: Colors.teal[50],
                        child: ListTile(
                          leading: snapshot.data["definitions"][index]
                                      ["image_url"] ==
                                  null
                              ? null
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot
                                      .data["definitions"][index]["image_url"]),
                                ),
                          title: Text(
                            _controller.text.trim() +
                                " (" +
                                snapshot.data["definitions"][index]["type"] +
                                ")",
                            style: myRegularTextStyle.copyWith(
                              fontSize: 24.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.data["pronunciation"],
                          style: myRegularTextStyle.copyWith(
                              fontSize: 25.0, color: Colors.red),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.data["definitions"][index]["definition"],
                          style: myRegularTextStyle.copyWith(
                              fontSize: 25.0, letterSpacing: 1),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return SizedBox(
              height: 0.0,
            );
          },
        ),
      ),
    );
  }
}
