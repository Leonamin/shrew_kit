import 'package:flutter/material.dart';

class SpeedDialFAB extends StatefulWidget {
  const SpeedDialFAB({
    Key? key,
    required this.primaryChild,
    required this.children,
    this.controller,
    this.duration = const Duration(milliseconds: 450),
    required this.open,
    this.primaryPadding,
    this.childrenPadding,
    this.childrenDistance,
  }) : super(key: key);

  final bool open;
  final Widget primaryChild;
  final List<Widget> children;

  final AnimationController? controller;

  final Duration duration;

  final EdgeInsets? primaryPadding;
  final EdgeInsets? childrenPadding;
  final double? childrenDistance;

  @override
  State<StatefulWidget> createState() {
    return _SpeedDialFABState();
  }
}

class _SpeedDialFABState extends State<SpeedDialFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Animation<double>> _speedDialChildAnimations =
      <Animation<double>>[];

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _animationController = widget.controller ??
        AnimationController(
          value: widget.open ? 1 : 0,
          vsync: this,
          duration: widget.duration,
        );
    _animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    final double fractionOfOneSpeedDialChild = 1.0 / widget.children.length;
    for (int speedDialChildIndex = 0;
        speedDialChildIndex < widget.children.length;
        ++speedDialChildIndex) {
      final List<TweenSequenceItem<double>> tweenSequenceItems =
          <TweenSequenceItem<double>>[];

      final double firstWeight =
          fractionOfOneSpeedDialChild * speedDialChildIndex;
      if (firstWeight > 0.0) {
        tweenSequenceItems.add(TweenSequenceItem<double>(
          tween: ConstantTween<double>(0.0),
          weight: firstWeight,
        ));
      }

      tweenSequenceItems.add(TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: fractionOfOneSpeedDialChild,
      ));

      final double lastWeight = fractionOfOneSpeedDialChild *
          (widget.children.length - 1 - speedDialChildIndex);
      if (lastWeight > 0.0) {
        tweenSequenceItems.add(TweenSequenceItem<double>(
            tween: ConstantTween<double>(1.0), weight: lastWeight));
      }

      _speedDialChildAnimations.insert(
          0,
          TweenSequence<double>(tweenSequenceItems)
              .animate(_animationController));
    }
  }

  @override
  void didUpdateWidget(covariant SpeedDialFAB oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.open != widget.open) {
      _animate();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int speedDialChildAnimationIndex = 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (!_animationController.isDismissed)
          Padding(
            padding: widget.childrenPadding ?? const EdgeInsets.only(right: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: widget.children.map<Widget>((Widget speedDialChild) {
                final Widget speedDialChildWidget = Opacity(
                  opacity:
                      _speedDialChildAnimations[speedDialChildAnimationIndex]
                          .value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ScaleTransition(
                        scale: _speedDialChildAnimations[
                            speedDialChildAnimationIndex],
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: widget.childrenDistance ?? 8),
                          child: speedDialChild,
                        ),
                      ),
                    ],
                  ),
                );
                speedDialChildAnimationIndex++;
                return speedDialChildWidget;
              }).toList(),
            ),
          ),
        _buildPrimaryWidget(),
      ],
    );
  }

  Widget _buildPrimaryWidget() {
    return Padding(
      padding: widget.primaryPadding ?? const EdgeInsets.only(right: 4),
      child: widget.primaryChild,
    );
  }

  void _animate() async {
    if (widget.open) {
      await _animationController.forward();
    } else {
      await _animationController.reverse();
    }
  }
}
