import 'package:flutter/material.dart';
import 'package:gif/gif.dart' as gif;

class Gif extends StatefulWidget {
  const Gif({
    required this.path,
    required this.size,
    this.isFlippedHorizontally = false,
    this.isPaused = false,
    super.key,
  });

  final String path;
  final Size size;
  final bool isFlippedHorizontally;
  final bool isPaused;

  @override
  State<Gif> createState() => _GifState();
}

class _GifState extends State<Gif> with TickerProviderStateMixin {
  late final _controller = gif.GifController(vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Gif oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPaused != widget.isPaused) {
      if (widget.isPaused) {
        _controller.stop();
      } else {
        // Skip coverage: This line depends on GIF animation timing which is difficult to verify in unit tests.
        // The GifController behavior varies based on the actual duration of the GIF file,
        // which is not available in test environments. This is unrelated to MVVM testability.
        _controller.repeat(); // coverage:ignore-line
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: widget.isFlippedHorizontally ? -1 : 1,
      child: SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: gif.Gif(
          image: AssetImage(widget.path),
          controller: _controller,
          autostart: widget.isPaused ? gif.Autostart.no : gif.Autostart.loop,
        ),
      ),
    );
  }
}
