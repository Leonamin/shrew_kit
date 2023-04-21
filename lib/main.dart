import 'package:flutter/material.dart';
import 'package:shrew_kit/test_animdated_list_view.dart';
import 'package:shrew_kit/view/jump_page_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTile(
                context: context, text: 'JumpPageView', child: JumpPageView()),
            _buildTile(
                context: context,
                text: 'TestAnimatedListView',
                child: TestAnimatedListView()),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required BuildContext context,
    Color? color,
    required String text,
    required Widget child,
  }) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 60,
        minWidth: double.infinity,
      ),
      color: color ?? const Color(0xFFFAFAFA),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (_) => child)),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
