
import 'package:flutter/material.dart';
import 'package:tdv2_showcase_web/object/meta.dart';
import 'package:tdv2_showcase_web/widget/fazpass_remove_info_view.dart';

import 'fazpass_info_view.dart';

class FazpassMetaView extends StatefulWidget {
  const FazpassMetaView({
    super.key,
    required this.tween,
    required this.interval,
    required this.duration,
    required this.meta,
    required this.shouldAnimate,
  });

  final Tween<double> tween;
  final Interval interval;
  final int duration;
  final Meta meta;
  final bool shouldAnimate;

  @override
  State<StatefulWidget> createState() => _FazpassMetaViewState();
}

class _FazpassMetaViewState extends State<FazpassMetaView> with SingleTickerProviderStateMixin {

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

  late Widget child = ExpansionTile(
    title: const Text(
      'Detail',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
    childrenPadding: const EdgeInsets.all(16),
    children: [
      if (widget.meta is FazpassMeta) FazpassInfoView(widget.meta as FazpassMeta),
      if (widget.meta is FazpassRemoveMeta) FazpassRemoveInfoView(widget.meta as FazpassRemoveMeta),
    ],
  );

  @override
  Widget build(BuildContext context) => widget.shouldAnimate ?
  SizeTransition(
    sizeFactor: animation,
    child: child,
  ) : child;
}