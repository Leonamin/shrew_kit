// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shrew_kit/view/anime/component/speed_dial_widget.dart';

class ExpandableFabView extends StatefulWidget {
  @override
  ExpandableFabViewState createState() => ExpandableFabViewState();
}

class ExpandableFabViewState extends State<ExpandableFabView> {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Press the FAB!')),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        curve: Curves.bounceInOut,
        duration: Duration(milliseconds: 300),
        distance: 50,
        type: ExpandableFabType.up,
        reverseDuration: Duration(milliseconds: 300),
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.wallet)),
          IconButton(onPressed: () {}, icon: Icon(Icons.close)),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
        ],
      ),
    );
  }
}
