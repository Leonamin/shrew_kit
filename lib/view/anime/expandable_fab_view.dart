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
      backgroundColor: Colors.white,
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
        primaryChild: AnimatedToggleButton(
          on: isOpen,
          openColor: Theme.of(context).colorScheme.primary,
          openIconColor: Theme.of(context).colorScheme.onPrimary,
          openLabel: '기록하기 ',
          openPadding: EdgeInsets.symmetric(horizontal: 10),
          openLabelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          closeColor: Colors.white,
          closeBorderColor: Theme.of(context).colorScheme.primary,
          onTap: onTapPrimary,
        ),
        open: isOpen,
        children: [
          _CategoryButton(
            onTap: onTapChild,
            icon: Icon(Icons.park_sharp),
            title: '산책하기',
            width: 130,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: Colors.white,
            borderColor: Theme.of(context).colorScheme.primary,
          ),
          _CategoryButton(
            onTap: onTapChild,
            icon: Icon(Icons.note_add_outlined),
            title: '일지작성',
            width: 130,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: Colors.white,
            borderColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  onTapPrimary() {
    setState(() {
      isOpen = !isOpen;
    });
  }

  onTapChild() {
    if (isOpen) {
      setState(() {
        isOpen = false;
      });
    } else {}
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    super.key,
    required this.icon,
    required this.title,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.textStyle,
    this.width,
    this.height,
    this.color,
    this.borderColor = Colors.transparent,
    this.borderRadius = 8,
    this.borderWidth = 1,
    this.onTap,
  });

  final Widget icon;
  final String title;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final EdgeInsets padding;
  final Color? color;
  final Color borderColor;
  final double borderRadius;
  final double borderWidth;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
          border: Border.all(
            width: borderWidth,
            color: borderColor,
          ),
        ),
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            Text(
              title,
              style: textStyle ??
                  TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
