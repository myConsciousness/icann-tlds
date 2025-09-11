import 'package:icann_tlds/icann_tlds.dart';
import 'package:test/test.dart';

void main() {
  group('Domain Validation', () {
    test('isValidDomain should return true for valid domains', () {
      expect(isValidDomain('example.com'), isTrue);
      expect(isValidDomain('test.org'), isTrue);
      expect(isValidDomain('google.co.uk'), isTrue);
      expect(isValidDomain('subdomain.example.net'), isTrue);
    });

    test('isValidDomain should return false for invalid domains', () {
      expect(isValidDomain('invalid.notexist'), isFalse);
      expect(isValidDomain('no-tld'), isFalse);
      expect(isValidDomain(''), isFalse);
      expect(isValidDomain('.com'), isFalse);
      expect(isValidDomain('example.'), isFalse);
    });

    test('isValidDomain should be case insensitive', () {
      expect(isValidDomain('EXAMPLE.COM'), isTrue);
      expect(isValidDomain('Test.ORG'), isTrue);
    });
  });

  group('Email Validation', () {
    test('hasValidTLD should return true for valid email TLDs', () {
      expect(hasValidTLD('user@example.com'), isTrue);
      expect(hasValidTLD('test@domain.org'), isTrue);
      expect(hasValidTLD('admin@site.net'), isTrue);
    });

    test('hasValidTLD should return false for invalid email TLDs', () {
      expect(hasValidTLD('user@invalid.notexist'), isFalse);
      expect(hasValidTLD('invalid-email'), isFalse);
      expect(hasValidTLD('user@'), isFalse);
      expect(hasValidTLD('@domain.com'), isFalse);
    });

    test('hasValidTLD should be case insensitive', () {
      expect(hasValidTLD('USER@EXAMPLE.COM'), isTrue);
      expect(hasValidTLD('test@DOMAIN.ORG'), isTrue);
    });
  });

  group('TLD Utilities', () {
    test('getCountryCodeTLDs should return 2-character TLDs', () {
      final ccTLDs = getCountryCodeTLDs();
      expect(ccTLDs.isNotEmpty, isTrue);
      expect(ccTLDs.every((tld) => tld.length == 2), isTrue);
      expect(ccTLDs.contains('us'), isTrue);
      expect(ccTLDs.contains('uk'), isTrue);
      expect(ccTLDs.contains('jp'), isTrue);
    });

    test('getTLDsStartingWith should return correct TLDs', () {
      final aTLDs = getTLDsStartingWith('a');
      expect(aTLDs.isNotEmpty, isTrue);
      expect(aTLDs.every((tld) => tld.startsWith('a')), isTrue);

      final comTLDs = getTLDsStartingWith('com');
      expect(comTLDs.contains('com'), isTrue);
    });

    test('getTLDsStartingWith should be case insensitive', () {
      final aTLDs = getTLDsStartingWith('A');
      final lowerATLDs = getTLDsStartingWith('a');
      expect(aTLDs, equals(lowerATLDs));
    });

    test('getLongestTLD should return a valid TLD', () {
      final longest = getLongestTLD();
      expect(longest.isNotEmpty, isTrue);
      expect(tlds.contains(longest), isTrue);
      expect(longest.length >= 2, isTrue);
    });
  });
}
