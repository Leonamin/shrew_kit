import 'package:flutter/material.dart';
import 'package:shrew_kit/view/slider/component/shrew_slider.dart';
import 'package:shrew_kit/view/slider/component/slider_desc.dart';
import 'package:shrew_kit/view/slider/component/slider_thumb_shape.dart';

const Color primaryColor = Color(0xFF5ED270);
final Color secondaryColor = Colors.grey.shade300;

final BoxDecoration defaultBoxDecoration = BoxDecoration(
  color: const Color(0xFFFFFFFF),
  border: Border.all(color: const Color(0xFF5ED270)),
  borderRadius: BorderRadius.circular(8),
);
const descriptionTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 10,
  fontWeight: FontWeight.w400,
);

class TestSliderView extends StatefulWidget {
  TestSliderView({super.key});

  @override
  State<TestSliderView> createState() => _TestSliderViewState();
}

class _TestSliderViewState extends State<TestSliderView> {
  final min = 0.0;

  final max = 80.0;

  final List<SliderDesc> sliderDescList = [
    SliderDesc(value: 0, desc: '매우 낮음'),
    SliderDesc(value: 40, desc: '보통'),
    SliderDesc(value: 80, desc: '매우 높음'),
  ];

  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: defaultBoxDecoration,
          child: ShrewSlider(
            thumbColor: primaryColor,
            value: _value,
            min: min,
            max: max,
            sliderDescList: sliderDescList,
            onChanged: (p0) => setState(() => _value = p0),
            thumbShape: const SliderThumbShape(
              thumbRadius: 15,
            ),
          ),
        ),
      ),
    );
  }
}
