import 'dart:convert';

String prettyJson(Map map) => JsonEncoder.withIndent('    ').convert(map);

String prettyPrintJson(Map map) => JsonEncoder.withIndent('    ').convert(map);

String jsonPrettyPrint(Map map) => JsonEncoder.withIndent('    ').convert(map);
