import 'package:flutter/material.dart';

class WidGetButton extends StatelessWidget {

  final String text;
  final VoidCallback callback;

  const WidGetButton({Key key, this.text, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 150,
        child: RaisedButton(
          onPressed: callback,
          child: Text(
            text,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}