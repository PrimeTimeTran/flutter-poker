import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutpoke/widgets/CardWidget.dart';

import 'package:flutpoke/utils/Deck.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final deck = new Deck();
    deck.shuffle();
    final cards = deck.getCards();
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi GO"),
      ),
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: cards.length,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: ((c, i) {
                return Container(
                  height: 200,
                  width: 100,
                  child: SvgPicture.asset("${cards[i].path}"),
                );
                return CardWidget(rank: cards[i].rank, suit: cards[i].suit);
              }),
            )
          ],
        ),
      ),
    );
  }
}
