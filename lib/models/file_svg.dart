import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../utils/utils.dart';


class FileSvg {
  String currentSvg;
  String originalSvg;
  String outputFileName;
  bool hasStyleTag;
  Map<String, String> mapColors;
  List<String> listColors;

  FileSvg({
    required this.currentSvg,
    required this.originalSvg,
    required this.outputFileName,
    required this.hasStyleTag,
    required this.mapColors,
    required this.listColors,
  });
}

FileSvg loadSvgFile(PlatformFile platformFile) {
  File file = File(platformFile.path!);
  String originalSvg = file.readAsStringSync();
  String currentSvg = originalSvg;
  Map<String, String> mapColors = searchColors(originalSvg);
  currentSvg = normalizeColors(currentSvg, mapColors);
  List<String> listColors = mapColors.values.toList();
  String outputFileName = platformFile.name.replaceAll('.svg', '_copia.svg');
  bool hasStyleTag = originalSvg.contains('<style');
  return FileSvg(
      currentSvg: currentSvg,
      originalSvg: originalSvg,
      outputFileName: outputFileName,
      hasStyleTag: hasStyleTag,
      mapColors: mapColors,
      listColors: listColors);
}
