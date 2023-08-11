import 'package:flutter/material.dart';
import 'dart:math' as math;

enum ExpandableFabSize { small, regular, large }

extension ExpandableFabSizeExt on ExpandableFabSize {
  double get size {
    switch (this) {
      case ExpandableFabSize.large:
        return 96.0;
      case ExpandableFabSize.small:
        return 40.0;
      default:
        return 56.0;
    }
  }
}

class FloatingActionButtonBuilder {
  const FloatingActionButtonBuilder({
    required this.size,
    required this.builder,
  });

  final Widget Function(BuildContext context, VoidCallback? onPressed,
      Animation<double> progress) builder;

  /// The size of the FAB. Used for position calculations and animations.
  final double size;
}

class DefaultFloatingActionButtonBuilder extends FloatingActionButtonBuilder {
  DefaultFloatingActionButtonBuilder({
    this.fabSize = ExpandableFabSize.regular,
    this.foregroundColor,
    this.backgroundColor,
    this.shape,
    this.heroTag,
    this.child,
  }) : super(
          size: _actualSize(fabSize),
          builder: (BuildContext context, VoidCallback? onPressed,
              Animation<double> progress) {
            var func = FloatingActionButton.small;
            switch (fabSize) {
              case ExpandableFabSize.large:
                func = FloatingActionButton.large;
                break;
              case ExpandableFabSize.small:
                break;
              default:
                func = FloatingActionButton.new;
            }
            return func.call(
              autofocus: true,
              foregroundColor: foregroundColor,
              backgroundColor: backgroundColor,
              shape: shape,
              heroTag: heroTag,
              onPressed: onPressed,
              child: child,
            );
          },
        );

  final ExpandableFabSize fabSize;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final Object? heroTag;
  final Widget? child;
}

class RotateFloatingActionButtonBuilder extends FloatingActionButtonBuilder {
  RotateFloatingActionButtonBuilder({
    this.fabSize = ExpandableFabSize.regular,
    this.foregroundColor,
    this.backgroundColor,
    this.shape,
    this.heroTag,
    this.child,
    this.angle = math.pi / 2,
  }) : super(
          size: _actualSize(fabSize),
          builder: (BuildContext context, VoidCallback? onPressed,
              Animation<double> progress) {
            return AnimatedBuilder(
              animation: progress,
              builder: (context, _) {
                return Transform.rotate(
                  angle: progress.value * angle,
                  child: DefaultFloatingActionButtonBuilder(
                    foregroundColor: foregroundColor,
                    backgroundColor: backgroundColor,
                    shape: shape,
                    heroTag: heroTag,
                    fabSize: fabSize,
                    child: child,
                  ).builder(context, onPressed, progress),
                );
              },
            );
          },
        );
  final ExpandableFabSize fabSize;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final Object? heroTag;
  final Widget? child;
  final double angle;
}

double _actualSize(ExpandableFabSize fabSize) {
  switch (fabSize) {
    case ExpandableFabSize.large:
      return 96.0;
    case ExpandableFabSize.small:
      return 40.0;
    default:
      return 56.0;
  }
}
