

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_colors_tools/models/file_svg.dart';

// final fileSvgProvider=StateNotifierProvider<FileSvgNotifier,FileSvg>((ref) => FileSvgNotifier());

// class FileSvgNotifier extends StateNotifier<FileSvg> {
//   FileSvgNotifier() : super(FileSvg(currentSvg: '', originalSvg: '', outputFileName: 'output.svg', mapColors: {},hasStyleTag: false, listColors: []));

//   void init(FileSvg fileSvg){
//     state.currentSvg=fileSvg.currentSvg;
//     state.originalSvg=fileSvg.originalSvg;
//     state.outputFileName=fileSvg.outputFileName;
//     state.mapColors=fileSvg.mapColors;
//     state.hasStyleTag=fileSvg.hasStyleTag;
//     state.listColors=fileSvg.listColors;
//   }
// }

final fileSvgProvider=StateProvider<FileSvg>(((ref) => FileSvg(currentSvg: '', originalSvg: '', outputFileName: 'output.svg', mapColors: {},hasStyleTag: false, listColors: [])));
