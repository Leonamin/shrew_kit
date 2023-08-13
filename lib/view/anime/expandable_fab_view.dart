// ignore_for_file: prefer_const_constructors

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
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
            print('나 빌드 되고 있어!');
            return AnimatedToggleButton(
              on: isOpen,
              child: isOpen ? _buildCloseFab() : _buildOpenFab(),
            );
          })
        ],
      ),
      floatingActionButton: SpeedDialFAB(
        controller: _animationController,
        // primaryChild: _buildFAB(),
        primaryChild: GestureDetector(
          onTap: () {
            setState(() {
              isOpen = !isOpen;
            });
          },
          child: AnimatedToggleButton(
            key: ValueKey('primary'),
            on: isOpen,
            child: isOpen ? _buildCloseFab() : _buildOpenFab(),
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

  _buildFAB() {
    return AnimatedSizeAndFade(
        child: isOpen ? _buildCloseFab() : _buildOpenFab());
  }

  _buildOpenFab() {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: InkWell(
        onTap: () {
          setState(() {
            isOpen = !isOpen;
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(Icons.add), Text('기록하기')],
        ),
      ),
    );
  }

  _buildCloseFab() {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.close)],
            ),
          ),
        ),
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
