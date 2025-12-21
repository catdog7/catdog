import 'dart:convert';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    colors: true,
    printEmojis: false,
    printTime: false,
    lineLength: 120,
    errorMethodCount: 8,
    noBoxingByDefault: false,
    levelColors: null,
    levelEmojis: null,
  ),
  output: ConsoleOutput(),
  filter: ProductionFilter(),
  level: Level.debug,
);


void mylogger(dynamic jsonObject) {
  var encoder = const JsonEncoder.withIndent('  '); // 두 칸 들여쓰기
  var prettyJson = encoder.convert(jsonObject);
  print('Time: ${DateTime.now().toString()} ==============');
  prettyJson.split('\n').forEach((line) => print(line));
  print('==============');
}
