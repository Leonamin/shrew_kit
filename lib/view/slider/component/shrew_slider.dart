import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shrew_kit/util/widget_util.dart';
import 'package:shrew_kit/view/slider/component/slider_desc.dart';

class ShrewSlider extends StatelessWidget {
  ShrewSlider({
    super.key,
    required this.sliderDescList,
    required this.value,
    required this.min,
    required this.max,
    this.onChanged,
    this.thumbShape,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 10,
      fontWeight: FontWeight.w400,
    ),
    this.thumbColor = Colors.blue,
    this.trackColor = Colors.grey,
  }) {
    assert(min < max);
    assert((min <= value && value <= max));
  }
  final double value;
  final double min;
  final double max;
  final List<SliderDesc> sliderDescList;
  final Function(double)? onChanged;
  final SliderComponentShape? thumbShape;
  final TextStyle textStyle;
  final Color thumbColor;
  final Color trackColor;

  double get range => max - min;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SliderTheme(
          data: SliderThemeData(
            thumbColor: thumbColor,
            overlayColor: Colors.transparent,
            trackHeight: 3,
            thumbShape: thumbShape,
          ),
          child: Slider(
            thumbColor: thumbColor,
            activeColor: trackColor,
            inactiveColor: trackColor,
            value: value,
            onChanged: _onChanged,
            min: min,
            max: max,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _SliderDescWidget(
            rangeValue: range,
            descList: sliderDescList,
            textStyle: textStyle,
          ),
        ),
      ],
    );
  }

  void _onChanged(double value) {
    if (value == value.toInt()) return;
    HapticFeedback.mediumImpact();
    onChanged?.call(value);
  }
}

class _SliderDescWidget extends StatelessWidget {
  const _SliderDescWidget({
    super.key,
    required this.rangeValue,
    required this.descList,
    required this.textStyle,
  });
  final double rangeValue;
  final List<SliderDesc> descList;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: largestTextHeight,
        ),
        child: Stack(
          children: descList.map((e) {
            final pos = constraints.maxWidth * _getPosPercentage(e.value) / 100;

            final textSize =
                WidgetUtil.getTextWidth(text: e.desc, style: textStyle);
            var centerPos = pos - (textSize / 2);
            if (centerPos < 0) {
              centerPos = 0;
            } else if (centerPos + textSize > constraints.maxWidth) {
              centerPos = constraints.maxWidth - textSize;
            }
            return Positioned(
              left: centerPos,
              child: RichText(
                text: TextSpan(
                  text: e.desc,
                  style: textStyle,
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  double _getPosPercentage(double value) {
    return value / rangeValue * 100;
  }

  double get largestTextHeight {
    return descList.map((e) {
      final height = getTextHeight(
        text: e.desc,
        style: textStyle,
        screenWidth: getTextWidth(
              text: e.desc,
              style: textStyle,
            ) +
            1,
      );
      return height;
    }).reduce((value, element) => value > element ? value : element);
  }

  double getTextWidth({
    required String text,
    required TextStyle style,
  }) {
    var width = WidgetUtil.getTextWidth(text: text, style: style) + 2;
    return width;
  }

  double getTextHeight(
      {required String text,
      required TextStyle style,
      required double screenWidth}) {
    var height = WidgetUtil.getTextHeight(
          text: text,
          style: style,
          screenWidth: screenWidth,
        ) +
        2;
    return height;
  }
}
