import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:text_transformation_animation/text_transformation_animation.dart';

void main() {
  group('_TextTransformationWidget', () {
    testWidgets('widget renders', (WidgetTester tester) async {
      Key buttonKey = GlobalKey();
      String text = "Hello";
      Widget widget = MaterialApp(home: Scaffold(
        body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return ListView(children: [
            TextTransformationAnimation(
                text: text, duration: Duration(milliseconds: 1000)),
            ListTile(
                key: buttonKey,
                title: Icon(Icons.restaurant),
                onTap: () {
                  setState(() => text = "Bye");
                })
          ]);
        }),
      ));
      await tester.pumpWidget(widget);
      expect(find.text("Hello"), findsOneWidget);
      expect(find.byKey(buttonKey), findsOneWidget);
      await tester.tap(find.byKey(buttonKey));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.text("Bye"), findsOneWidget);
    });
  });

  group('_TextTransformationTween', () {
    test('interpolates text correctly', () {
      TransformTextTween tween = TransformTextTween(
          begin: "aaaaa",
          end: "ccccc",
          alphabetToPosition: Map.fromIterables(
              "abcdefghijklmnopqrstuvwxyz".split(''),
              List.generate(26, (i) => i)),
          positionToAlphabet: Map.fromIterables(List.generate(26, (i) => i),
              "abcdefghijklmnopqrstuvwxyz".split('')));
      expect(tween.lerp(0), "aaaaa");
      expect(tween.lerp(0.5), "bbbbb");
      expect(tween.lerp(1), "ccccc");
    });

    test('interpolates larger end string', () {
      TransformTextTween tween = TransformTextTween(
          begin: "a",
          end: "ccccc",
          alphabetToPosition: Map.fromIterables(
              "abcdefghijklmnopqrstuvwxyz".split(''),
              List.generate(26, (i) => i)),
          positionToAlphabet: Map.fromIterables(List.generate(26, (i) => i),
              "abcdefghijklmnopqrstuvwxyz".split('')));
      expect(tween.lerp(0), "a");
      expect(tween.lerp(0).length, 1);
      expect(tween.lerp(0.5).length, 3);
      expect(tween.lerp(1).length, 5);
      expect(tween.lerp(1), "ccccc");
    });

    test('interpolates larger start string', () {
      TransformTextTween tween = TransformTextTween(
          begin: "ccccc",
          end: "a",
          alphabetToPosition: Map.fromIterables(
              "abcdefghijklmnopqrstuvwxyz".split(''),
              List.generate(26, (i) => i)),
          positionToAlphabet: Map.fromIterables(List.generate(26, (i) => i),
              "abcdefghijklmnopqrstuvwxyz".split('')));
      expect(tween.lerp(0).length, 5);
      expect(tween.lerp(0), "ccccc");
      expect(tween.lerp(0.5).length, 3);
      expect(tween.lerp(1).length, 1);
      expect(tween.lerp(1), "a");
    });
  });
}
