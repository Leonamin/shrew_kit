
import 'package:flutter/material.dart';
import 'package:shrew_kit/view/fold_container.dart';

class PivotListView extends StatefulWidget {
  const PivotListView({
    super.key,
    required this.pivotIndex,
    required this.physics,
    required this.chilren,
  });
  final int pivotIndex;
  final ScrollPhysics physics;
  final List<Widget> chilren;

  @override
  State<PivotListView> createState() => _PivotListViewState();
}

class _PivotListViewState extends State<PivotListView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: widget.physics,
      children: widget.chilren
          .map((e) => FoldContainer(
                visible: widget.chilren.indexOf(e) <= widget.pivotIndex,
                child: e,
              ))
          .toList(),
    );
  }
}
