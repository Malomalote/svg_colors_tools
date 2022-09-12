import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svg_colors_tools/models/file_svg.dart';

import '../providers/providers.dart';
import '../utils/utils.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  Color pickerColor = Colors.white;

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  Color colorReplace = Colors.white;

  @override
  Widget build(
    BuildContext context,
  ) {
    var replaceStyleSwitch = ref.watch(replaceStyleProvider);
print(replaceStyleSwitch);

    final currentTheme = ref.read(darkThemeProvider.notifier);
    final fileSvg = ref.watch(fileSvgProvider);
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
                          ref
                              .read(fileSvgProvider.notifier).update((state) => loadSvgFile(result.files.single));
                              ref.read(replaceStyleProvider.notifier).update((state) => false);
                        }
                        // else {
                        //    User canceled the picker
                        // }
                      },
                      child: const Text('Load file')),
                ],
              ),
              (fileSvg.currentSvg != '')
                  ? Expanded(
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // originalSvg.contains('<style')
                          fileSvg.hasStyleTag
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Replace style element ${replaceStyleSwitch}'),
                                    Switch(
                                        // value: replaceStyle,
                                        value: replaceStyleSwitch,
                                            
                                        onChanged: (bool value) {
                                          ref.read(replaceStyleProvider.notifier).update((state)=>value);

                                          replaceStyleSwitch?
                                          
                                          fileSvg.currentSvg=fileSvg.originalSvg
                                          :
                                          fileSvg.currentSvg=svgRemoveStyleLabel(fileSvg.originalSvg);
                                          // fileSvg.currentSvg=svgRemoveStyleLabel(fileSvg.originalSvg)
                                          // :
                                          // fileSvg.currentSvg=fileSvg.originalSvg;

                                        }),
                                  ],
                                )
                              : Container(),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: size.height / 2.5,
                            child: SvgPicture.string(fileSvg.currentSvg,
                                fit: BoxFit.contain, height: size.height / 2.6),
                          ),
                          const SizedBox(height: 20),
                          Flexible(
                            child: ListView(
                              shrinkWrap: true,
                              primary: false,
                              clipBehavior: Clip.hardEdge,
                              children: [
                                ...fileSvg.listColors.map((color) {
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
                                                  labelTypes: const [],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: const Text('Got it'),
                                                  onPressed: () {
                                                    setState(() {
                                                      fileSvg.currentSvg =
                                                          replaceColor(
                                                              fileSvg
                                                                  .currentSvg,
                                                              color,
                                                              colorToHex(
                                                                      pickerColor)
                                                                  .toLowerCase()
                                                                  .replaceFirst(
                                                                      'ff',
                                                                      '#'));
                                                      fileSvg.listColors[
                                                              fileSvg
                                                                  .listColors
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
                                  fileName: fileSvg.outputFileName,
                                );

                                if (outputFile == null) {
                                } else {
                                  File newFile = File(outputFile);
                                  newFile.writeAsStringSync(
                                      fileSvg.currentSvg);
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
