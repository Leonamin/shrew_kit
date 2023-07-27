import 'package:flutter/material.dart';
import 'package:shrew_kit/common/constants/color_hue.dart';

class ColorChartView extends StatefulWidget {
  const ColorChartView({super.key});

  @override
  State<ColorChartView> createState() => _ColorChartViewState();
}

class _ColorChartViewState extends State<ColorChartView> {
  @override
  Widget build(BuildContext context) {
    const divider = SizedBox(height: 10);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Chart'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            _ColorBox(color: ColorHue.bluePrimary),
            divider,
            _ColorBox(color: ColorHue.bluePrimary2),
            divider,
            _ColorBox(color: ColorHue.bluePrimary3),
            divider,
            _ColorBox(color: ColorHue.bluePrimary4),
            divider,
            _ColorBox(color: ColorHue.bluePrimary5),
            divider,
            _ColorBox(color: ColorHue.greenPrimary),
            divider,
            _ColorBox(color: ColorHue.greenPrimary2),
            divider,
            _ColorBox(color: ColorHue.greenPrimary3),
            divider,
            _ColorBox(color: ColorHue.greenPrimary4),
            divider,
            _ColorBox(color: ColorHue.greenPrimary5),
            divider,
            _ColorBox(color: ColorHue.secondary),
            divider,
            _ColorBox(color: ColorHue.secondary2),
            divider,
            _ColorBox(color: ColorHue.secondary3),
            divider,
            _ColorBox(color: ColorHue.secondary4),
            divider,
            _ColorBox(color: ColorHue.secondary5),
          ],
        ),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  const _ColorBox({
    super.key,
    required this.color,
  });
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      constraints:
          const BoxConstraints(maxHeight: 50, maxWidth: double.infinity),
    );
  }
}
