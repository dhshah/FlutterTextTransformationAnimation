# FlutterTextTransformationAnimationWidget

A Widget which transforms the text inside of it via series of character changes.


![Demo of Text Transformation](https://i.imgur.com/7S13O5n.gif)


## Example

```dart
String text = "Transformation";
...
Scaffold(
  appBar: AppBar(
    title: TextTransformationAnimation(
      text: _title,
      duration: Duration(milliseconds: 1000),
    ),
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: () => setState(() => _title = "Text Transformation"),
    tooltip: 'Increment',
    child: Icon(Icons.add),
  ),
)
...
```