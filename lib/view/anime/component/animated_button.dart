import 'package:flutter/material.dart';
import 'package:shrew_kit/util/widget_util.dart';

class AnimatedToggleButton extends StatefulWidget {
  const AnimatedToggleButton({
    super.key,
    required this.on,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.fastOutSlowIn,
    this.iconSize = 24,
    this.openIcon = Icons.add,
    this.closeIcon = Icons.close,
    this.openLabel,
    this.closeLabel,
    this.openLabelStyle,
    this.closeLabelStyle,
    this.openColor,
    this.closeColor,
    this.openIconColor,
    this.closeIconColor,
    this.openPadding = const EdgeInsets.all(0),
    this.closePadding = const EdgeInsets.all(0),
    this.openMargin = const EdgeInsets.all(0),
    this.closeMargin = const EdgeInsets.all(0),
  });

  final bool on;
  final Duration duration;
  final Curve curve;

  final double iconSize;

  final IconData openIcon;
  final IconData closeIcon;
  final String? openLabel;
  final String? closeLabel;
  final TextStyle? openLabelStyle;
  final TextStyle? closeLabelStyle;
  final Color? openColor;
  final Color? closeColor;
  final Color? openIconColor;
  final Color? closeIconColor;
  final EdgeInsets openPadding;
  final EdgeInsets closePadding;
  final EdgeInsets openMargin;
  final EdgeInsets closeMargin;

  @override
  State<AnimatedToggleButton> createState() => _AnimatedToggleButtonState();
}

class _AnimatedToggleButtonState extends State<AnimatedToggleButton> {
  late final Color openColor =
      widget.openColor ?? Theme.of(context).colorScheme.primary;
  late final Color closeColor = widget.closeColor ?? Colors.white;

  late final TextStyle openLabelStyle = widget.openLabelStyle ??
      const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  late final TextStyle closeLabelStyle = widget.closeLabelStyle ??
      const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  late Size openSize;
  late Size closeSize;

  Color get color => widget.on ? openColor : closeColor;
  double get borderRadius => widget.on ? openSize.width : closeSize.width;
  double get width => widget.on ? openSize.width : closeSize.width;
  double get height => widget.on ? openSize.height : closeSize.height;

  double get openOpacity => widget.on ? 1 : 0;
  double get closeOpacity => widget.on ? 0 : 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    double openTextWidth = 0;
    double closeTextWidth = 0;
    double openTextHeight = 0;
    double closeTextHeight = 0;

    if (widget.openLabel != null) {
      openTextWidth = WidgetUtil.getTextWidth(
        text: widget.openLabel!,
        style: openLabelStyle,
      );
      openTextHeight = WidgetUtil.getTextHeight(
        text: widget.openLabel!,
        style: openLabelStyle,
        screenWidth: MediaQuery.of(context).size.width,
      );
    }

    var openWidth = openTextWidth +
        widget.iconSize +
        widget.openPadding.horizontal +
        widget.openMargin.horizontal +
        4;
    var openHeight = openTextHeight +
        widget.openPadding.vertical +
        widget.openMargin.vertical;

    if (openWidth < 56) {
      openWidth = 56;
    }
    if (openHeight < 56) {
      openHeight = 56;
    }

    openSize = Size(openWidth, openHeight);

    if (widget.closeLabel != null) {
      closeTextWidth = WidgetUtil.getTextWidth(
        text: widget.closeLabel!,
        style: closeLabelStyle,
      );
      closeTextHeight = WidgetUtil.getTextHeight(
        text: widget.closeLabel!,
        style: closeLabelStyle,
        screenWidth: MediaQuery.of(context).size.width,
      );
    }

    var closeWidth = closeTextWidth +
        widget.iconSize +
        widget.closePadding.horizontal +
        widget.closeMargin.horizontal +
        4;
    var closeHeight = closeTextHeight +
        widget.closePadding.vertical +
        widget.closeMargin.vertical;
    if (closeWidth < 56) {
      closeWidth = 56;
    }
    if (closeHeight < 56) {
      closeHeight = 56;
    }

    closeSize = Size(closeWidth, closeHeight);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      constraints: const BoxConstraints(minHeight: 56, minWidth: 56),
      width: width,
      height: height,
      padding: widget.on ? widget.openPadding : widget.closePadding,
      margin: widget.on ? widget.openMargin : widget.closeMargin,
      alignment: widget.on ? Alignment.center : AlignmentDirectional.topCenter,
      duration: widget.duration,
      curve: widget.curve,
      child: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: openOpacity,
                duration: widget.duration,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      widget.openIcon,
                      size: widget.iconSize,
                      color: widget.openIconColor,
                    ),
                    if (widget.openLabel != null)
                      Text(
                        widget.openLabel!,
                        style: openLabelStyle,
                      ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: closeOpacity,
                duration: widget.duration,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      widget.closeIcon,
                      size: widget.iconSize,
                      color: widget.closeIconColor,
                    ),
                    if (widget.closeLabel != null)
                      ClipRect(
                        child: Text(
                          widget.closeLabel!,
                          style: closeLabelStyle,
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension EdgeInsetsExt on EdgeInsets {
  // double get width => this.horizontal
}
