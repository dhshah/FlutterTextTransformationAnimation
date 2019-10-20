library text_animation;

import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';

/// A Widget which animates the text inside of it any time it changes.
/// It does so by taking in an alphabet and creating a tween of characters
/// between the start and end.
/// EG: if you text changes from 'a' to 'g' and the alphabet is 'abcdefg', the
/// tween will lerp bcdef to g.
/// The lerp always moves towards the end.
/// If the text changes from 'd' to 'a', the lerp will lerp through d b c a.
///
/// This widget looks best when used with a monospace font.
class TextTransformationAnimation extends ImplicitlyAnimatedWidget {
  final String text;
  final Duration duration;

  /// Defaults to symbols on the US Keyboard, can be overridden to contain all a
  /// custom set of alphabets.
  final Map<String, int> _alphabetToPosition;
  final Map<int, String> _positionToAlphabet;

  TextTransformationAnimation(
      {@required this.text,
      @required this.duration,
      String alphabet =
          "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#\$%^&*()_+-={}[]:\";',./<>?`~|\\",
      Key key})
      : this._alphabetToPosition = Map<String, int>(),
        this._positionToAlphabet = Map<int, String>(),
        super(key: key, duration: duration) {
    for (int i = 0; i < alphabet.length; i++) {
      if (_alphabetToPosition.containsKey(alphabet[i])) {
        throw new FormatException(
            "Alphabet must contain a unique set of characters");
      }
      _positionToAlphabet.putIfAbsent(i, () => alphabet[i]);
      _alphabetToPosition.putIfAbsent(alphabet[i], () => i);
    }
  }

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() {
    return TextTransformationAnimationState();
  }
}

class TextTransformationAnimationState
    extends AnimatedWidgetBaseState<TextTransformationAnimation> {
  TransformTextTween _transformTextTween;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_transformTextTween.evaluate(animation)}',
    );
  }

  @override
  void forEachTween(visitor) {
    _transformTextTween = visitor(
      _transformTextTween,
      widget.text,
      (value) => TransformTextTween(
          begin: value,
          alphabetToPosition: widget._alphabetToPosition,
          positionToAlphabet: widget._positionToAlphabet),
    );
  }
}

class TransformTextTween extends Tween<String> {
  final Map<String, int> alphabetToPosition;
  final Map<int, String> positionToAlphabet;
  static Random _random = Random();

  TransformTextTween(
      {String begin,
      String end,
      @required this.alphabetToPosition,
      @required this.positionToAlphabet})
      : super(begin: begin, end: end);

  String lerp(double t) {
    var strBuilder = StringBuffer();
    int strLen;
    if (begin.length <= end.length) {
      strLen = begin.length + ((end.length - begin.length) * t).round();
    } else {
      strLen = begin.length - ((begin.length - end.length) * t).round();
    }
    for (int i = 0; i < strLen; i++) {
      if (begin.length > i) {
        strBuilder.write(positionToAlphabet[lerpDouble(
                alphabetToPosition[begin[i]],
                end.length > i
                    ? alphabetToPosition[end[i]]
                    : _random.nextInt(alphabetToPosition.length),
                t)
            .round()]);
      } else {
        strBuilder.write(t == 1
            ? end[i]
            : positionToAlphabet[_random.nextInt(alphabetToPosition.length)]);
      }
    }
    return strBuilder.toString();
  }
}
