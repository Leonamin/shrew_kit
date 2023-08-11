// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shrew_kit/view/anime/component/speed_dial_fab.dart';

class ExpandableFabView extends StatefulWidget {
  const ExpandableFabView({super.key});

  @override
  ExpandableFabViewState createState() => ExpandableFabViewState();
}

class ExpandableFabViewState extends State<ExpandableFabView> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Press the FAB!')),
      floatingActionButton: SpeedDialFAB(
        primaryChild: _buildFAB(),
        open: isOpen,
        children: [
          _buildChildFAB(),
          _buildChildFAB(),
          _buildChildFAB(),
          _buildChildFAB(),
          _buildChildFAB(),
        ],
      ),
    );
  }

  _buildFAB() {
    return InkWell(
      onTap: () {
        setState(() {
          isOpen = !isOpen;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(Icons.add), Text('기록하기')],
      ),
    );
  }

  _buildChildFAB() {
    return InkWell(
      onTap: () {
        if (isOpen) {
          setState(() {
            isOpen = false;
          });
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(Icons.wrap_text), Text('자식')],
      ),
    );
  }
}
