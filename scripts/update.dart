import 'package:http/http.dart';
import 'package:punycode/punycode.dart';
import 'dart:io';

const _tldsFilePath = './lib/src/tlds.g.dart';
const _changesFilePath = './tld-changes.md';

Future<void> main() async {
  final tldsFile = File(_tldsFilePath);

  // Capture the previous list before overwriting so we can report the diff.
  final previousTlds =
      tldsFile.existsSync() ? parseExistingTlds(tldsFile.readAsStringSync()) : <String>[];

  final response = await get(
    Uri.http(
      'data.iana.org',
      '/TLD/tlds-alpha-by-domain.txt',
    ),
  );

  final data = response.body
      .split('\n')
      .sublist(1)
      .map((item) => item.toLowerCase())
      .map(
          (item) => isPunycode(item) ? punycodeDecode(item.substring(4)) : item)
      .where((element) => element.isNotEmpty)
      .toList()
    ..sort();

  tldsFile.writeAsStringSync('''// coverage:ignore-file
// ignore_for_file: type=lint
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ICANN TLDs Generator
// **************************************************************************

/// A constant list of TLDs from ICANN.
const tlds = <String>[
${_getTldElements(data)}];
''');

  // Write a CHANGELOG body fragment (without the version header) for the
  // release workflow to consume.
  final changes = computeChanges(previousTlds, data);
  File(_changesFilePath).writeAsStringSync(
    '${renderChangelogBody(added: changes.added, removed: changes.removed)}\n',
  );
}

bool isPunycode(String domain) {
  return domain.startsWith('xn--');
}

/// Extracts the quoted TLD entries from a generated `tlds.g.dart` file.
List<String> parseExistingTlds(String fileContent) {
  final entry = RegExp(r"^\s*'([^']*)',", multiLine: true);
  return entry.allMatches(fileContent).map((m) => m.group(1)!).toList();
}

/// Computes which TLDs were added and removed, each sorted alphabetically.
({List<String> added, List<String> removed}) computeChanges(
  List<String> oldTlds,
  List<String> newTlds,
) {
  final oldSet = oldTlds.toSet();
  final newSet = newTlds.toSet();

  final added = newSet.difference(oldSet).toList()..sort();
  final removed = oldSet.difference(newSet).toList()..sort();

  return (added: added, removed: removed);
}

/// Renders the CHANGELOG body for a set of changes.
///
/// Empty sections are omitted. When nothing changed, a generic line is
/// returned as a fallback.
String renderChangelogBody({
  required List<String> added,
  required List<String> removed,
}) {
  final sections = <String>[
    if (added.isNotEmpty) _renderSection('Added', added),
    if (removed.isNotEmpty) _renderSection('Removed', removed),
  ];

  if (sections.isEmpty) {
    return '- Updated TLDs list from ICANN';
  }

  return sections.join('\n\n');
}

String _renderSection(String title, List<String> tlds) {
  final buffer = StringBuffer('### $title');
  for (final tld in tlds) {
    buffer.write('\n- `$tld`');
  }
  return buffer.toString();
}

String _getTldElements(List<String> tlds) {
  final buffer = StringBuffer();

  for (final tld in tlds) {
    buffer.writeln("  '$tld',");
  }

  return buffer.toString();
}
