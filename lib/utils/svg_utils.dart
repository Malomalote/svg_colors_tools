import 'colors_utils.dart';

String svgRemoveStyleLabel(String input) {
  String transformsvg = input;
  if (input.contains('<style')) {
    int posInit = input.indexOf('<style');
    int posEnd = input.indexOf('</style>');
    String styleString = input
        .substring(posInit, posEnd + '</style>'.length)
        .replaceAllMapped(RegExp('<style.*'), (match) => '')
        .replaceAll('</style>', '');

    transformsvg = transformsvg.replaceAllMapped(
        RegExp('<style.*/style>', dotAll: true), (match) => '');

    List<String> stylesRaw = styleString.split('.');
    List<Pair<String, String>> styles = [];
    for (var l in stylesRaw) {
      String first = l.split('{').first;
      String second = l.split('{').last.split('}').first;
      styles.add(Pair(first, second));
    }
    for (var j in styles) {
      transformsvg =
          transformsvg.replaceAll('class="${j.first}"', 'style="${j.second}"');
    }
  }
  return transformsvg;
}

//from https://stackoverflow.com/questions/64282563/list-of-tuples-in-flutter-dart
class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);

  @override
  String toString() => 'Pair(a: $first, b: $second)';
}

Map<String,String> searchColors(String input) {
   Map<String,String> listColors2={};

  final regexp2 = RegExp(
      r'#([a-fA-F0-9]{6}|[a-fA-F0-9]{3})\b|(\")?(black|silver|gray|white|maroon|red|purple|fuchsia|green|lime|olive|yellow|navy|blue|teal|aqua)\b(\")?|(rgb)\([^\)]*\)');

  final match2 = regexp2.allMatches(input);
  if (match2.isNotEmpty) {
    for (int i = 0; i < match2.length; i++) {
      var newColor = match2.elementAt(i).group(0).toString();
      // print(newColor);
      if (newColor.contains('rgb')) {
        newColor = rgbToHexColor(newColor);
      } else {
        if (!newColor.contains('#')) {
          newColor = colorKeywords[newColor.replaceAll('"', '')];
        }
      }
      listColors2.addAll({match2.elementAt(i).group(0).toString() : newColor});
    }
  } else {
    print(' no match!!');
  }
  return listColors2;
}

String normalizeColors(String input, Map<String,String> mapColors){
  String toReturn=input;
  mapColors.forEach((key, value) => toReturn=toReturn.replaceAll(key.toString(), value.toString()));
  return toReturn;
}




String replaceColor(String input, String originalColor, String newColor) {
  String toReturn = input.replaceAll(originalColor, newColor);

  return toReturn;
}
