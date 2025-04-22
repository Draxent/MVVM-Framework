import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gif/gif.dart' as gif;
import 'package:example/src/widgets/gif.dart';

import '../app_wrapper.dart';

const _gifPath = 'assets/images/mario_walking.gif';
const _gifSize = Size(100, 100);

void main() {
  group('Gif', () {
    testWidgets('should display gif with correct dimensions', (tester) async {
      await tester.pumpWidget(_buildGif());

      final sizedBox = find.byType(SizedBox);
      expect(sizedBox, findsOneWidget);
      final sizedBoxWidget = tester.widget<SizedBox>(sizedBox);
      expect(sizedBoxWidget.width, _gifSize.width);
      expect(sizedBoxWidget.height, _gifSize.height);
      expect(find.byType(gif.Gif), findsOneWidget);
      final gifWidget = tester.widget<gif.Gif>(find.byType(gif.Gif));
      expect((gifWidget.image as AssetImage).assetName, _gifPath);
      expect(gifWidget.autostart, gif.Autostart.loop);
    });

    testWidgets('should handle when is paused', (tester) async {
      await tester.pumpWidget(_buildGif(isPaused: true));

      final gifWidget = tester.widget<gif.Gif>(find.byType(gif.Gif));
      expect(gifWidget.autostart, gif.Autostart.no);
    });

    testWidgets('should handle horizontal flipping correctly', (tester) async {
      await tester.pumpWidget(_buildGif(isFlippedHorizontally: true));

      final transformScale = find.byType(Transform).first;
      expect(transformScale, findsOneWidget);
      final transformWidget = tester.widget<Transform>(transformScale);
      expect(transformWidget.transform, Matrix4.identity()..setEntry(0, 0, -1));
    });

    testWidgets('should handle state changes between paused and playing', (
      tester,
    ) async {
      await tester.pumpWidget(_buildGif(isPaused: false));
      var gifWidget = tester.widget<gif.Gif>(find.byType(gif.Gif));
      expect(gifWidget.autostart, gif.Autostart.loop);

      await tester.pumpWidget(_buildGif(isPaused: true));
      await tester.pumpAndSettle();

      gifWidget = tester.widget<gif.Gif>(find.byType(gif.Gif));
      expect(gifWidget.autostart, gif.Autostart.no);
    });
  });
}

Widget _buildGif({bool isPaused = false, bool isFlippedHorizontally = false}) =>
    AppWrapper(
      child: Gif(
        path: _gifPath,
        size: _gifSize,
        isPaused: isPaused,
        isFlippedHorizontally: isFlippedHorizontally,
      ),
    );
