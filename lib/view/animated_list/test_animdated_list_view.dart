import 'package:flutter/material.dart';
import 'package:shrew_kit/view/pivot_list/pivot_list_view.dart';

class TestAnimatedListView extends StatefulWidget {
  const TestAnimatedListView({super.key});

  @override
  State<TestAnimatedListView> createState() => _TestAnimatedListViewState();
}

class _TestAnimatedListViewState extends State<TestAnimatedListView> {
  int index = 0;
  bool toggleWidgetList = false;

  List<Widget> widget1List = [
    Container(
      width: double.infinity,
      color: Colors.red,
      height: 300,
      child: const Text('1'),
    ),
    Container(
      width: double.infinity,
      color: Colors.blue,
      height: 300,
      child: const Text('2'),
    ),
    Container(
      width: double.infinity,
      color: Colors.cyan,
      height: 300,
      child: const Text('3'),
    ),
    Container(
      width: double.infinity,
      color: Colors.green,
      height: 300,
      child: const Text('4'),
    ),
  ];

  List<Widget> widget2List = [
    Container(
      width: double.infinity,
      color: Colors.red,
      height: 300,
      child: const Text('1'),
    ),
    Container(
      width: double.infinity,
      color: Colors.blue,
      height: 300,
      child: const Text('2'),
    ),
    Container(
      width: double.infinity,
      color: Colors.green,
      height: 300,
      child: const Text('4'),
    ),
  ];

  int get listLength =>
      (toggleWidgetList) ? widget1List.length : widget2List.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TestAnimatedListView'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PivotListView(
                pivotIndex: index,
                physics: const NeverScrollableScrollPhysics(),
                chilren: (toggleWidgetList) ? widget1List : widget2List),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (index > 0) index = index - 1;
                      });
                    },
                    child: const Text('-')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (index < listLength) index = index + 1;
                      });
                    },
                    child: const Text('+')),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        toggleWidgetList = !toggleWidgetList;
                      });
                    },
                    child: const Text('toggle')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
