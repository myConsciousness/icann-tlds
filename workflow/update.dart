// Copyright 2023 Shinya Kato. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:http/http.dart';
import 'package:punycode/punycode.dart';
import 'dart:io';

Future<void> main() async {
  final response = await get(
    Uri.http(
      'data.iana.org',
      '/TLD/tlds-alpha-by-domain.txt',
    ),
  );

  final body = response.body;

  final data = body
      .split('\n')
      .sublist(1)
      .map((item) => item.toLowerCase())
      .map(
          (item) => isPunycode(item) ? punycodeDecode(item.substring(4)) : item)
      .where((element) => element.isNotEmpty)
      .toList()
    ..sort();

  final file = File('./lib/src/tlds.g.dart');

  file.writeAsStringSync('''// Copyright 2023 Shinya Kato. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

// coverage:ignore-file
// ignore_for_file: type=lint
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ICANN TLDs Generator
// **************************************************************************

/// A constant list of TLDs from ICANN.
const tlds = <String>[
${_getTldElements(data)}];
''');
}

bool isPunycode(String domain) {
  return domain.startsWith('xn--');
}

String _getTldElements(List<String> tlds) {
  final buffer = StringBuffer();

  for (final tld in tlds) {
    buffer.writeln("  '$tld',");
  }

  return buffer.toString();
}
