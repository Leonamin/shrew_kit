import 'package:flutter/material.dart';

class JumpPageView extends StatefulWidget {
  const JumpPageView({super.key});

  @override
  State<JumpPageView> createState() => _JumpPageViewState();
}

class _JumpPageViewState extends State<JumpPageView> {
  late final List<Widget> pageViews;
  late List<Widget> visiblePageViews;
  late final PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    pageViews = createPageContents();
    visiblePageViews = createPageContents();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void animateToOne() {
    pageController.animateToPage(
      0,
      curve: Curves.easeIn,
      duration: const Duration(seconds: 1),
    );
  }

  void jumpAnimateEight() async {
    pageController.jumpToPage(6);
    await pageController.animateToPage(
      7,
      curve: Curves.easeIn,
      duration: const Duration(seconds: 1),
    );
  }

  void refreshChildren(Duration duration) {
    setState(() {
      visiblePageViews = createPageContents();
    });
  }

  void swapChildren(int pageCurrent, int pageTarget) {
    List<Widget> newVisiblePageViews = [];
    newVisiblePageViews.addAll(pageViews);

    if (pageTarget > pageCurrent) {
      newVisiblePageViews[pageCurrent + 1] = visiblePageViews[pageTarget];
    } else if (pageTarget < pageCurrent) {
      newVisiblePageViews[pageCurrent - 1] = visiblePageViews[pageTarget];
    }

    setState(() {
      visiblePageViews = newVisiblePageViews;
    });
  }

  Future quickJump(int pageCurrent, int pageTarget) async {
    int quickJumpTarget = 0;

    if (pageTarget > pageCurrent) {
      quickJumpTarget = pageCurrent + 1;
    } else if (pageTarget < pageCurrent) {
      quickJumpTarget = pageCurrent - 1;
    }
    await pageController.animateToPage(
      quickJumpTarget,
      curve: Curves.easeIn,
      duration: const Duration(seconds: 1),
    );
    pageController.jumpToPage(pageTarget);
  }

  void flashToEight() async {
    int pageCurrent = (pageController.page ?? 0).round();
    int pageTarget = 7;
    if (pageCurrent == pageTarget) {
      return;
    }
    swapChildren(pageCurrent, pageTarget);
    await quickJump(pageCurrent, pageTarget);
    WidgetsBinding.instance.addPostFrameCallback(refreshChildren);
  }

  List<Widget> createPageContents() {
    return <Widget>[
      const PageContent(1),
      const PageContent(2),
      const PageContent(3),
      const PageContent(4),
      const PageContent(5),
      const PageContent(6),
      const PageContent(7),
      const PageContent(8),
    ];
  }

  Widget header() {
    return Container(
      height: 40,
      color: Colors.white30,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ElevatedButton.icon(
                label: const Text('Animate to 1st page'),
                icon: const Icon(Icons.chevron_left),
                onPressed: animateToOne,
              ),
              ElevatedButton.icon(
                label: const Text('Combine to 8th page'),
                icon: const Icon(Icons.chevron_right),
                onPressed: jumpAnimateEight,
              ),
              ElevatedButton.icon(
                label: const Text('Flash Jump to 8th page'),
                icon: const Icon(Icons.chevron_right),
                onPressed: flashToEight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pageView() {
    return PageView(
      controller: pageController,
      children: <Widget>[
        ...visiblePageViews,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page View Jump'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: header(),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: pageView(),
            ),
          ],
        ),
      ),
    );
  }
}

class PageContent extends StatelessWidget {
  final int pageIndex;

  const PageContent(this.pageIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white30,
        border: Border.all(
          color: Colors.black26,
          width: 1.0,
        ),
      ),
      child: Center(
        child: Text(
          "Page #$pageIndex",
          textScaleFactor: 3,
        ),
      ),
    );
  }
}

class AddNoteSettings extends StatelessWidget {
  const AddNoteSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Center(child: Text("AddNoteSettings")),
    );
  }
}
