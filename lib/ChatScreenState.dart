import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'ChatMessage.dart';
import 'main.dart';

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isComposing = false; //new

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose(); //new
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() { //new
      _isComposing = false; //new
    }); //new
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 500),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(
//          title: new Text("Friendlychat"),
//          elevation:
//          Theme
//              .of(context)
//              .platform == TargetPlatform.iOS ? 0.0 : 4.0),
      body: new Container( //modified
          child: new Column( //modified
            children: <Widget>[
              new Flexible(
                child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
              new Divider(height: 1.0),
              new Container(
                decoration: new BoxDecoration(color: Theme
                    .of(context)
                    .cardColor),
                child: _buildTextComposer(),
              ),
            ],
          ),
          decoration: Theme
              .of(context)
              .platform == TargetPlatform.iOS //new
              ? new BoxDecoration( //new
            border: new Border( //new
              top: new BorderSide(color: Colors.grey[200]), //new
            ),
          )
              : null),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme
          .of(context)
          .accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) { //new
                  setState(() { //new
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme
                    .of(context)
                    .platform == TargetPlatform.iOS ?
                new CupertinoButton( //new
                  child: new Text("Send"), //new
                  onPressed: _isComposing //new
                      ? () => _handleSubmitted(_textController.text)
                      : null,) :
                new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: _isComposing ?
                      () => _handleSubmitted(_textController.text) : null,
                )
            ),
          ],
        ),
      ),
    );
  }
}