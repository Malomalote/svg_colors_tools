

final Map colorKeywords=
  {
    'black':'#000000',
    'silver':'#c0c0c0',
    'gray':'#808080',
    'white':'#ffffff',
    'maroon':'#800000',
    'red':'#ff0000',
    'purple':'#800080',
    'fuchsia':'#ff00ff',
    'green':'#008000',
    'lime':'#00ff00',
    'olive':'#808000',
    'yellow':'#ffff00',
    'navy':'#000080',
    'blue':'#0000ff',
    'teal':'#008080',
    'aqua':'#00ffff',
  };

String rgbToHexColor(String rgbColor){
  String toReturn=rgbColor;
  toReturn=toReturn.replaceAll('rgb(', '');
  toReturn=toReturn.replaceAll(')', '');
  final components=toReturn.split(',');
  if(components.length!=3) return '';
  int red;
  int green;
  int blue;
  if(components[0].contains('%')){
    red= (double.parse(components[0].replaceAll('%',''))*255/100).round();
    green= (double.parse(components[1].replaceAll('%',''))*255/100).round();
    blue= (double.parse(components[2].replaceAll('%',''))*255/100).round();
  } else{
    red= int.parse(components[0]);
    green= int.parse(components[1]);
    blue= int.parse(components[2]);
  }
  toReturn='#${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
  return toReturn;
}
