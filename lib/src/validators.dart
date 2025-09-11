// coverage:ignore-file
// ignore_for_file: type=lint

import 'tlds.g.dart';

/// Validates if a domain has a valid TLD according to ICANN's official list.
///
/// Returns `true` if the domain has a valid TLD, `false` otherwise.
///
/// Example:
/// ```dart
/// print(isValidDomain('example.com')); // true
/// print(isValidDomain('test.xyz')); // true
/// print(isValidDomain('invalid.fake')); // false
/// print(isValidDomain('no-tld')); // false
/// ```
bool isValidDomain(String domain) {
  final parts = domain.toLowerCase().split('.');
  if (parts.length < 2) return false;

  // Check if any part is empty (handles cases like ".com" or "example.")
  if (parts.any((part) => part.isEmpty)) return false;

  final tld = parts.last;
  return tlds.contains(tld);
}

/// Validates if an email address has a valid TLD according to ICANN's official list.
///
/// Returns `true` if the email has a valid TLD, `false` otherwise.
///
/// Example:
/// ```dart
/// print(hasValidTLD('user@example.com')); // true
/// print(hasValidTLD('user@test.org')); // true
/// print(hasValidTLD('user@invalid.fake')); // false
/// ```
bool hasValidTLD(String email) {
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.([^@]+)$');
  final match = emailRegex.firstMatch(email.toLowerCase());

  if (match == null) return false;

  final tld = match.group(1)!;
  return tlds.contains(tld);
}

/// Gets all country code TLDs (2-character TLDs).
///
/// Returns a list of all 2-character TLDs from the ICANN list.
///
/// Example:
/// ```dart
/// final ccTLDs = getCountryCodeTLDs();
/// print('Total ccTLDs: ${ccTLDs.length}');
/// ```
List<String> getCountryCodeTLDs() {
  return tlds.where((tld) => tld.length == 2).toList();
}

/// Gets all TLDs that start with the specified prefix.
///
/// Returns a list of TLDs that start with the given prefix (case-insensitive).
///
/// Example:
/// ```dart
/// final aTLDs = getTLDsStartingWith('a');
/// print('TLDs starting with "a": $aTLDs');
/// ```
List<String> getTLDsStartingWith(String prefix) {
  final lowerPrefix = prefix.toLowerCase();
  return tlds.where((tld) => tld.startsWith(lowerPrefix)).toList();
}

/// Gets the longest TLD in the ICANN list.
///
/// Returns the TLD with the most characters.
///
/// Example:
/// ```dart
/// final longest = getLongestTLD();
/// print('Longest TLD: $longest (${longest.length} characters)');
/// ```
String getLongestTLD() {
  return tlds.reduce((a, b) => a.length > b.length ? a : b);
}
