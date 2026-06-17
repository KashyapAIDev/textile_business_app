import 'package:flutter/material.dart';

class HoverScaleContainer extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final BorderRadius? borderRadius;

  const HoverScaleContainer({
    super.key,
    required this.child,
    this.scale = 1.03,
    this.duration = const Duration(milliseconds: 200),
    this.borderRadius,
  });

  @override
  State<HoverScaleContainer> createState() => _HoverScaleContainerState();
}

class _HoverScaleContainerState extends State<HoverScaleContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = widget.borderRadius ?? BorderRadius.circular(12);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(
          _isHovered ? widget.scale : 1.0,
          _isHovered ? widget.scale : 1.0,
          1.0,
        ),
        decoration: BoxDecoration(
          borderRadius: effectiveRadius,
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: ClipRRect(borderRadius: effectiveRadius, child: widget.child),
      ),
    );
  }
}
