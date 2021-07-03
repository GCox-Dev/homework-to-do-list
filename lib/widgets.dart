import 'package:flutter/material.dart';

class Pallete {
  static Color bgColor = Colors.grey[200];
  static Color bgCard = Colors.grey[300];
  static Color highCard = Colors.grey[350];
  static Color textField = Colors.grey[400];

  static Color accent = Colors.orange[500];
}

class StyledScaffold extends StatelessWidget {
  final List<Widget> children;
  StyledScaffold({Key key, @required this.children}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.accent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Pallete.accent,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Pallete.bgColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: children,
          ),
        ),
      ),
    );
  }
}

class TextContainer extends StatelessWidget {
  final String text;
  final Color textColor;
  TextContainer({Key key, @required this.text, this.textColor=Colors.black}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5)),
          color: Pallete.textField,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.black)),
          ),
          child: ListView(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      alignment: Alignment.center,
                      child: Text("$text",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: textColor
                          ))))
            ],
            scrollDirection: Axis.horizontal,
          ),
        ));
  }
}

class StyledCard extends StatelessWidget {
  final Widget child;
  final bool raised;
  StyledCard({Key key, this.child, this.raised = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: (raised) ? Pallete.highCard : Pallete.bgCard,
      shape: cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}

class TitleCard extends StatelessWidget {
  final String title;
  final bool isHome;
  TitleCard({Key key, @required this.title, this.isHome = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Pallete.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
      ),
      child: SizedBox(
        height: 100,
        child: Center(
          child: Text(title,
              style: TextStyle(
                fontSize: (isHome && isHome != null) ? 38 : 30,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
    );
  }
}

RoundedRectangleBorder cardDecoration =
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)));
