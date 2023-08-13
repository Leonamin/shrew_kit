// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shrew_kit/view/anime/component/animated_button.dart';
import 'package:shrew_kit/view/anime/component/speed_dial_fab.dart';

class ExpandableFabView extends StatefulWidget {
  const ExpandableFabView({super.key});

  @override
  ExpandableFabViewState createState() => ExpandableFabViewState();
}

class ExpandableFabViewState extends State<ExpandableFabView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        value: isOpen ? 1 : 0,
        vsync: this,
        duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Builder(builder: (context) {
            return AnimatedToggleButton(
              on: isOpen,
            );
          })
        ],
      ),
      floatingActionButton: SpeedDialFAB(
        controller: _animationController,
        primaryChild: GestureDetector(
          onTap: () {
            setState(() {
              isOpen = !isOpen;
            });
          },
          child: AnimatedToggleButton(
            key: ValueKey('primary'),
            on: isOpen,
            openColor: Theme.of(context).colorScheme.primary,
            openIconColor: Theme.of(context).colorScheme.onPrimary,
            closeColor: Color(0xFFF5F5F5),
            openLabel: '기록하기',
            openPadding: EdgeInsets.symmetric(horizontal: 10),
            openLabelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
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
