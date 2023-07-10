import 'package:flutter/material.dart';

class NeoView extends StatefulWidget {
  const NeoView({super.key});

  @override
  NeoViewState createState() => NeoViewState();
}

class NeoViewState extends State<NeoView> {
  double x = 0;
  double y = 0;
  double z = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Transform(
          transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
            ..rotateX(x)
            ..rotateY(y)
            ..rotateZ(z),
          alignment: FractionalOffset.center,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                print(details.delta.dx);
                y = y - details.delta.dx / 100;
                x = x + details.delta.dy / 100;
              });
            },
            child: Container(
              color: Colors.red,
              height: 200.0,
              width: 200.0,
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                        boxShadow: const [
                          BoxShadow(blurRadius: 1, color: Colors.black12),
                        ],
                      ),
                      height: 30.0,
                      width: 30.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
