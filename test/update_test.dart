import 'package:test/test.dart';

import '../scripts/update.dart';

void main() {
  group('parseExistingTlds', () {
    test('extracts quoted TLD entries from a generated file', () {
      const content = '''// GENERATED CODE - DO NOT MODIFY BY HAND

/// A constant list of TLDs from ICANN.
const tlds = <String>[
  'aaa',
  'aarp',
  'zone',
];
''';

      expect(parseExistingTlds(content), ['aaa', 'aarp', 'zone']);
    });

    test('returns an empty list when there are no entries', () {
      const content = '''const tlds = <String>[
];
''';

      expect(parseExistingTlds(content), isEmpty);
    });
  });

  group('computeChanges', () {
    test('reports added and removed TLDs, sorted', () {
      final changes = computeChanges(
        ['abc', 'app', 'zzz'],
        ['app', 'dev', 'new'],
      );

      expect(changes.added, ['dev', 'new']);
      expect(changes.removed, ['abc', 'zzz']);
    });

    test('reports no changes for identical lists', () {
      final changes = computeChanges(['app', 'dev'], ['dev', 'app']);

      expect(changes.added, isEmpty);
      expect(changes.removed, isEmpty);
    });
  });

  group('renderChangelogBody', () {
    test('renders both Added and Removed sections', () {
      final body = renderChangelogBody(
        added: ['app', 'dev'],
        removed: ['xyz'],
      );

      expect(body, '''### Added
- `app`
- `dev`

### Removed
- `xyz`''');
    });

    test('renders only the Added section when nothing was removed', () {
      final body = renderChangelogBody(added: ['app'], removed: []);

      expect(body, '''### Added
- `app`''');
    });

    test('renders only the Removed section when nothing was added', () {
      final body = renderChangelogBody(added: [], removed: ['xyz']);

      expect(body, '''### Removed
- `xyz`''');
    });

    test('falls back to a generic line when there are no changes', () {
      final body = renderChangelogBody(added: [], removed: []);

      expect(body, '- Updated TLDs list from ICANN');
    });
  });
}
