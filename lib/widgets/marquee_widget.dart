import 'dart:async';
import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const MarqueeWidget({
    super.key,
    required this.text,
    required this.style,
    this.duration = const Duration(seconds: 18),
  });

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  late ScrollController _scrollController;
  bool _scrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  void _startScrolling() {
    if (!mounted || _scrolling) return;
    _scrolling = true;
    _scroll();
  }

  void _scroll() async {
    if (!mounted || !_scrollController.hasClients) {
      _scrolling = false;
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final remainingScroll = maxScroll - currentScroll;

    // Prevent animation crash if scroll extent is zero
    if (remainingScroll <= 0) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _scrollController.jumpTo(0.0);
        _scroll();
      }
      return;
    }

    // Calculate duration proportional to remaining scroll
    final animationDuration = widget.duration * (remainingScroll / maxScroll);

    _scrollController
        .animateTo(maxScroll, duration: animationDuration, curve: Curves.linear)
        .then((_) {
          if (mounted) {
            _scrollController.jumpTo(0.0);
            _scroll();
          }
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: [
          Text(widget.text, style: widget.style),
          const SizedBox(width: 80),
          Text(widget.text, style: widget.style),
          const SizedBox(width: 80),
        ],
      ),
    );
  }
}
