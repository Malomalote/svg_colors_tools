import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../providers/theme_provider.dart';
import '../utils/svg_utils.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  String svg = '';
  String originalSvg = '';
  String outputName = 'output.svg';
  List<String> listColors = [];
  Map<String, String> mapColors = {};
  Color pickerColor = Colors.white;

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  bool replaceStyle = false;
  Color colorReplace = Colors.white;

  @override
  Widget build(
    BuildContext context,
  ) {
    final currentTheme = ref.read(darkTheme.notifier);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('SVG Replace style element')),
        actions: [
          IconButton(
              onPressed: () {
                currentTheme.state = !currentTheme.state;
              },
              icon: Icon(
                  currentTheme.state
                      ? Icons.nightlight_outlined
                      : Icons.wb_sunny_outlined,
                  size: 15))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['svg']);

                        if (result != null) {
                          File file = File(result.files.single.path!);
                          // svg = svgRemoveStyleLabel(file.readAsStringSync());

                          originalSvg = file.readAsStringSync();
                          svg = originalSvg;
                          mapColors = searchColors(originalSvg);
                          svg = normalizeColors(svg, mapColors);
                          listColors = mapColors.values.toList();
                          outputName = result.files.single.name;
                          outputName =
                              outputName.replaceAll('.svg', '_copia.svg');
                          replaceStyle = false;
                          setState(() {});
                        }
                        // else {
                        //    User canceled the picker
                        // }
                      },
                      child: const Text('Load file')),
                ],
              ),
              (svg != '')
                  ? Expanded(
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          originalSvg.contains('<style')
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Replace style element'),
                                    Switch(
                                        value: replaceStyle,
                                        onChanged: (bool value) {
                                          setState(() {
                                            replaceStyle = value;
                                            replaceStyle
                                                ? svg = svgRemoveStyleLabel(
                                                    originalSvg)
                                                : svg = originalSvg;
                                          });
                                        }),
                                  ],
                                )
                              : Container(),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: size.height / 2.5,
                            child: SvgPicture.string(svg,
                                fit: BoxFit.contain, height: size.height / 2.6),
                          ),
                          const SizedBox(height: 20),
                          Flexible(
                            // fit: FlexFit.tight,
                            // flex: 1,
                            child: ListView(
                              shrinkWrap: true,
                              primary: false,
                              clipBehavior: Clip.hardEdge,
                              children: [
                                ...listColors.map((color) {
                                  String colorText = '#000000';
                                  String part1 = color.substring(1, 3);
                                  String part2 = color.substring(3, 5);
                                  String part3 = color.substring(5, 7);

                                  if ((part1 == part2 ||
                                          part1 == part3 ||
                                          part2 == part3) &&
                                      int.parse(part1, radix: 16) < 128) {
                                    colorText = '#ffffff';
                                  }

                                  return ListTile(
                                    title: InkWell(
                                      onTap: () {
                                        pickerColor = colorFromHex(color)!;

                                        showDialog(
                                          useRootNavigator: true,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              scrollable: true,
                                              actionsAlignment:
                                                  MainAxisAlignment.end,
                                              alignment: Alignment.centerLeft,
                                              title:
                                                  const Text('Pick a color!'),
                                              content: SingleChildScrollView(
                                                child: ColorPicker(
                                                  enableAlpha: false,
                                                  pickerColor: pickerColor,
                                                  onColorChanged: changeColor,
                                                  // colorPickerWidth: 100,

                                                  labelTypes: const [],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: const Text('Got it'),
                                                  onPressed: () {
                                                    setState(() {
                                                      svg = replaceColor(
                                                          svg,
                                                          color,
                                                          colorToHex(
                                                                  pickerColor)
                                                              .toLowerCase()
                                                              .replaceFirst(
                                                                  'ff', '#'));
                                                      listColors[listColors
                                                              .indexOf(
                                                                  color)] =
                                                          colorToHex(
                                                                  pickerColor)
                                                              .toLowerCase()
                                                              .replaceFirst(
                                                                  'ff', '#');
                                                      colorReplace =
                                                          pickerColor;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: colorFromHex(colorText)!,
                                            ),
                                            color: colorFromHex(color),
                                          ),
                                          child: Center(
                                            child: Text(color,
                                                style: TextStyle(
                                                    color: colorFromHex(
                                                        colorText))),
                                          )),
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: () async {
                                String? outputFile =
                                    await FilePicker.platform.saveFile(
                                  dialogTitle: 'Please select an output file:',
                                  fileName: outputName,
                                );

                                if (outputFile == null) {
                                  // User canceled the picker
                                } else {
                                  File newFile = File(outputFile);
                                  newFile.writeAsStringSync(svg);
                                }
                              },
                              child: const Text('Save file')),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
