
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdv2_showcase_web/object/data.dart';
import 'package:tdv2_showcase_web/object/meta.dart';
import 'package:tdv2_showcase_web/util/color_picker.dart';
import 'package:tdv2_showcase_web/util/constants.dart';
import 'package:tdv2_showcase_web/util/date_parser.dart';
import 'package:tdv2_showcase_web/widget/fazpass_meta_view.dart';

class EntryView extends StatefulWidget {
  const EntryView({super.key, required this.data, required this.onFinished});

  final EntryData data;
  final Function() onFinished;

  @override
  State<EntryView> createState() => _EntryViewState();
}

class _EntryViewState extends State<EntryView> {

  late List<String> messages;
  List<Tween<double>> animations = [];
  List<Interval> intervals = [];

  bool finishedLoading = true;

  @override
  void initState() {
    super.initState();

    messages = Constants.entryViewLoadingMessages[widget.data.type] ?? [];

    final animationsLength = messages.length + 1;
    for (var i = 0; i < animationsLength; i++) {
      var start = 0.0 + (i/animationsLength);
      var end = 0.0 + ((i+1)/animationsLength);
      var anim = Tween<double>(begin: 0.0, end: 1.0);
      var interval = Interval(start, end, curve: Curves.easeOut);

      animations.add(anim);
      intervals.add(interval);
    }

    if (widget.data.shouldAnimate) {
      finishedLoading = false;

      Timer(Duration(milliseconds: Constants.entryViewAnimationDuration * messages.length-1), () {
        setState(() {
          finishedLoading = true;
        });
        widget.onFinished();
      });
    }
  }

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0).copyWith(bottom: 18),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      widget.data.type,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    DateParser.millisDateToDisplay(widget.data.timestamp),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.data.meta is FazpassValidateMeta) Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Score: ',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: '${(widget.data.meta as FazpassValidateMeta).scoring}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Risk level: ',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: (widget.data.meta as FazpassValidateMeta).risk_level,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  color: (widget.data.meta as FazpassValidateMeta).risk_level.toLowerCase() == 'low'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: Constants.entryViewAnimationDuration),
                child: finishedLoading
                    ? Icon(
                  Icons.check_circle,
                  size: 76.0,
                  color: ColorPicker.pickColorByDataType(widget.data.type),
                )
                    : const SizedBox.square(dimension: 58.0),
              ),
            ],
          ),
        ),
        for (var i = 0; i < messages.length; i++) _AnimatedListTile(
          key: ValueKey('${widget.data.key}:list-tile:$i'),
          tween: animations[i],
          interval: intervals[i],
          duration: Constants.entryViewAnimationDuration * animations.length,
          message: messages[i],
          shouldAnimate: widget.data.shouldAnimate,
        ),
        if (widget.data.meta != null) FazpassMetaView(
          key: ValueKey('${widget.data.key}:meta-view'),
          tween: animations.last,
          interval: intervals.last,
          duration: Constants.entryViewAnimationDuration * animations.length,
          meta: widget.data.meta!,
          shouldAnimate: widget.data.shouldAnimate,
        ),
      ],
    ),
  );
}

class _AnimatedListTile extends StatefulWidget {
  const _AnimatedListTile({
    super.key,
    required this.tween,
    required this.interval,
    required this.duration,
    required this.message,
    required this.shouldAnimate});

  final Tween<double> tween;
  final Interval interval;
  final int duration;
  final String message;
  final bool shouldAnimate;

  @override
  State<StatefulWidget> createState() => _AnimatedListTileState();
}

class _AnimatedListTileState extends State<_AnimatedListTile> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    if (widget.shouldAnimate) {
      controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration),
        value: widget.shouldAnimate ? 0.0 : 1.0,
      );
      animation = widget.tween.animate(CurvedAnimation(
        parent: controller,
        curve: widget.interval,
      ));

      controller.forward();
    }
  }

  @override
  void dispose() {
    if (widget.shouldAnimate) controller.dispose();
    super.dispose();
  }

  late Widget child = ListTile(
    horizontalTitleGap: 0,
    minVerticalPadding: 0,
    dense: true,
    visualDensity: VisualDensity.compact,
    title: Text(widget.message),
  );

  @override
  Widget build(BuildContext context) => widget.shouldAnimate ? SizeTransition(
    sizeFactor: animation,
    child: child,
  ) : child;

}