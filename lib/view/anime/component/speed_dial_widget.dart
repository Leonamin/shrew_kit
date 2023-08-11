library speed_dial_fab_widget;

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:shrew_kit/view/anime/component/fab_builder.dart';

enum ExpandableFabType { fan, up, side }

enum ExpandableFabPos { right, left }

class ExpandableFab extends StatefulWidget {
  static final FloatingActionButtonLocation location = _ExpandableFabLocation();

  final List<Widget> children;

  /// 애니메이션 길이
  final Duration duration;

  final Duration? reverseDuration;

  /// 애니메이션 커브
  final Curve curve;

  /// 펼쳐진 버튼간 간격
  final double distance;

  final double fanAngle;

  final ExpandableFabType type;
  final ExpandableFabPos pos;

  final FloatingActionButtonBuilder? openButtonBuilder;
  final FloatingActionButtonBuilder? closeButtonBuilder;

  final VoidCallback? onOpen;
  final VoidCallback? afterOpen;
  final VoidCallback? onClose;
  final VoidCallback? afterClose;

  final Offset childrenOffset;

  const ExpandableFab({
    super.key,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration,
    this.curve = Curves.easeInBack,
    this.distance = 20,
    this.fanAngle = 90,
    this.type = ExpandableFabType.up,
    this.pos = ExpandableFabPos.right,
    required this.children,
    this.openButtonBuilder,
    this.closeButtonBuilder,
    this.onOpen,
    this.afterOpen,
    this.onClose,
    this.afterClose,
    this.childrenOffset = Offset.zero,
  });

  @override
  State createState() => ExpandableFabState();
}

class ExpandableFabState extends State<ExpandableFab>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late final FloatingActionButtonBuilder _openButtonBuilder;
  late final FloatingActionButtonBuilder _closeButtonBuilder;

  bool _open = false;
  bool get isOpen => _open;

  void toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        widget.onOpen?.call();
        _controller.forward().then((value) {
          widget.afterOpen?.call();
        });
      } else {
        widget.onClose?.call();
        _controller.reverse().then((value) {
          widget.afterClose?.call();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration ?? widget.duration,
    );

    _openButtonBuilder = widget.openButtonBuilder ??
        DefaultFloatingActionButtonBuilder(
          fabSize: ExpandableFabSize.small,
          child: const Icon(Icons.menu),
        );
    _closeButtonBuilder = widget.closeButtonBuilder ??
        DefaultFloatingActionButtonBuilder(
          fabSize: ExpandableFabSize.small,
          child: const Icon(Icons.close),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void forceExpandSecondaryFab() {
    _controller.forward();
  }

  void forceCollapseSecondaryFab() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final location = ExpandableFab.location as _ExpandableFabLocation;
    Offset? offset;
    Widget? cache;
    return ValueListenableBuilder<ScaffoldPrelayoutGeometry?>(
      valueListenable: location.scaffoldGeometry,
      builder: ((context, geometry, child) {
        if (geometry == null) {
          return const SizedBox.shrink();
        }
        double x;
        if (widget.pos == ExpandableFabPos.right) {
          x = kFloatingActionButtonMargin + geometry.minInsets.right;
        } else {
          x = -kFloatingActionButtonMargin - geometry.minInsets.left;
        }
        final bottomContentHeight =
            geometry.scaffoldSize.height - geometry.contentBottom;
        final y = kFloatingActionButtonMargin +
            math.max(geometry.minViewPadding.bottom, bottomContentHeight);
        if (offset != Offset(x, y)) {
          offset = Offset(x, y);
          cache = _buildButtons(offset!);
        }
        return _open ? FocusScope(child: cache!) : cache!;
      }),
    );
  }

  Widget _buildButtons(Offset offset) {
    return GestureDetector(
      onTap: () => toggle(),
      child: Stack(
        alignment: widget.pos == ExpandableFabPos.right
            ? Alignment.bottomRight
            : Alignment.bottomLeft,
        children: [
          Container(),
          ..._buildExpandingActionButtons(offset),
          Transform.translate(
            offset: -offset,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // _buildPrimaryButton(context),
                AnimatedOpacity(
                  opacity: _open ? 1.0 : 0.0,
                  curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
                  duration: widget.duration,
                  child:
                      _closeButtonBuilder.builder(context, toggle, _controller),
                ),
                _buildTapToOpenFab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons(Offset offset) {
    final children = <Widget>[];
    final count = widget.children.length;
    double buttonOffset = 0.0;
    if (_openButtonBuilder.size > _closeButtonBuilder.size) {
      buttonOffset = (_openButtonBuilder.size - _closeButtonBuilder.size) / 2;
    }
    var totalOffset = offset;
    if (widget.pos == ExpandableFabPos.right) {
      totalOffset += widget.childrenOffset + Offset(buttonOffset, buttonOffset);
    } else {
      totalOffset += Offset(-widget.childrenOffset.dx - buttonOffset,
          widget.childrenOffset.dy + buttonOffset);
    }

    for (var index = 0; index < count; index++) {
      final double dir, dist;
      final Curve curve;

      curve = Interval(
        0.0,
        1.0 - index / count / 6.0,
      );
      switch (widget.type) {
        case ExpandableFabType.fan:
          final half = (90 - widget.fanAngle) / 2;
          if (count > 1) {
            dir = widget.fanAngle / (count - 1) * index + half;
          } else {
            dir = widget.fanAngle + half;
          }
          dist = widget.distance;
          break;
        case ExpandableFabType.up:
          dir = 90;
          dist = widget.distance * (index + 1);
          break;
        case ExpandableFabType.side:
          dir = 0;
          dist = widget.distance * (index + 1);
          break;
      }
      children.add(
        _ExpandingActionButton(
          directionInDegrees: dir,
          maxDistance: dist,
          progress: _controller,
          offset: totalOffset,
          curve: curve,
          fabPos: widget.pos,
          child: widget.children[index],
        ),
      );
    }

    return children;
  }

  Widget _buildPrimaryButton(
    BuildContext context,
  ) {
    if (isOpen) {
      return _closeButtonBuilder.builder(
        context,
        toggle,
        _controller,
      );
    }
    return _openButtonBuilder.builder(
      context,
      toggle,
      _controller,
    );
  }

  Widget _buildTapToOpenFab() {
    final duration = widget.duration;
    final transformValues = _closeButtonBuilder.size / _openButtonBuilder.size;

    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? transformValues : 1.0,
          _open ? transformValues : 1.0,
          1.0,
        ),
        duration: duration,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
          duration: duration,
          child: _openButtonBuilder.builder(context, toggle, _controller),
        ),
      ),
    );
  }
}

class _ExpandableFabLocation extends StandardFabLocation {
  final ValueNotifier<ScaffoldPrelayoutGeometry?> scaffoldGeometry =
      ValueNotifier(null);

  @override
  double getOffsetX(
      ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    Future.microtask(() {
      this.scaffoldGeometry.value = scaffoldGeometry;
    });
    return 0;
  }

  @override
  double getOffsetY(
      ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    return -scaffoldGeometry.snackBarSize.height;
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
    required this.curve,
    required this.fabPos,
    required this.offset,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Offset offset;
  final Curve curve;
  final ExpandableFabPos fabPos;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final pos = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: fabPos == ExpandableFabPos.right ? offset.dx + pos.dx : null,
          left: fabPos == ExpandableFabPos.right ? null : -offset.dx + pos.dx,
          bottom: offset.dy + pos.dy,
          child: IgnorePointer(
            ignoring: progress.value != 1,
            child: child,
          ),
        );
      },
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: progress,
          curve: curve,
        ),
        child: child,
      ),
    );
  }
}
