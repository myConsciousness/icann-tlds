// Copyright 2023 Shinya Kato. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

// Package imports:
import 'package:http/http.dart';
import 'package:icann_tlds/src/tlds.g.dart';
import 'package:punycode/punycode.dart';
import 'package:test/test.dart';

void main() {
  test('Check all tlds', () async {
    final response = await get(
      Uri.http(
        'data.iana.org',
        '/TLD/tlds-alpha-by-domain.txt',
      ),
    );

    final body = response.body;

    bool _isPunycode(String domain) {
      return domain.startsWith('xn--');
    }

    final data = body
        .split('\n')
        .sublist(1)
        .map((item) => item.toLowerCase())
        .map((item) =>
            _isPunycode(item) ? punycodeDecode(item.substring(4)) : item)
        .where((element) => element.isNotEmpty)
        .toList()
      ..sort();

    for (final tld in data) {
      expect(tlds.contains(tld), isTrue);
    }
  });
}
