# ICANN TLDs

[![pub package](https://img.shields.io/pub/v/icann_tlds.svg)](https://pub.dev/packages/icann_tlds)
[![Auto Update](https://github.com/myConsciousness/icann-tlds/actions/workflows/auto-update.yml/badge.svg)](https://github.com/myConsciousness/icann-tlds/actions/workflows/auto-update.yml)

A List of **TLDs from [ICANN](https://data.iana.org/TLD/tlds-alpha-by-domain.txt)** that is **automatically updated daily**.

## Features

- 🔄 **Auto-updated daily** - TLDs list is automatically synchronized with ICANN's official data
- 📦 **Zero dependencies** - Pure Dart implementation with no external dependencies
- 🌐 **Complete coverage** - Includes all official TLDs including internationalized domain names (IDNs)
- ⚡ **Lightweight** - Minimal package size with efficient data structure

## Install

**With Dart:**

```bash
dart pub add icann_tlds
```

**With Flutter:**

```bash
flutter pub add icann_tlds
```

## Usage

### Basic Usage

```dart
import 'package:icann_tlds/icann_tlds.dart';

void main() {
  // Get all TLDs
  print(tlds);
  //=> ['aaa', 'aarp', 'abarth', 'abb', 'abbott', 'abbvie', 'abc', ...]
  
  // Check if a TLD exists
  print(tlds.contains('com')); //=> true
  print(tlds.contains('invalid')); //=> false
  
  // Get total count
  print('Total TLDs: ${tlds.length}');
}
```

### Domain Validation

```dart
import 'package:icann_tlds/icann_tlds.dart';

void main() {
  // Use the built-in domain validation function
  print(isValidDomain('example.com')); //=> true
  print(isValidDomain('test.xyz')); //=> true
  print(isValidDomain('invalid.notexist')); //=> false
  print(isValidDomain('no-tld')); //=> false
  print(isValidDomain('.com')); //=> false (invalid format)
}
```

### Email Validation Helper

```dart
import 'package:icann_tlds/icann_tlds.dart';

void main() {
  // Use the built-in email TLD validation function
  print(hasValidTLD('user@example.com')); //=> true
  print(hasValidTLD('user@test.org')); //=> true
  print(hasValidTLD('user@invalid.notexist')); //=> false
  print(hasValidTLD('invalid-email')); //=> false (invalid format)
}
```

### TLD Utilities

```dart
import 'package:icann_tlds/icann_tlds.dart';

void main() {
  // Use built-in utility functions
  
  // Get all country code TLDs (2 characters)
  final ccTLDs = getCountryCodeTLDs();
  print('Country code TLDs: ${ccTLDs.length}');
  print('Examples: ${ccTLDs.take(5).toList()}'); // [us, uk, jp, ...]
  
  // Get TLDs starting with 'a'
  final aTLDs = getTLDsStartingWith('a');
  print('TLDs starting with "a": ${aTLDs.length}');
  print('Examples: ${aTLDs.take(5).toList()}'); // [aaa, aarp, ...]
  
  // Get the longest TLD
  final longestTLD = getLongestTLD();
  print('Longest TLD: $longestTLD (${longestTLD.length} characters)');
  
  // You can still use the raw tlds list for custom filtering
  final shortTLDs = tlds.where((tld) => tld.length <= 3).toList();
  print('Short TLDs (≤3 chars): ${shortTLDs.length}');
}
```

## Automatic Updates

This package is automatically updated daily at 02:00 UTC using GitHub Actions. When ICANN releases new TLDs or removes existing ones, the package will be automatically updated and published to pub.dev within 24 hours.

### Update Process

1. **Daily Check** - GitHub Actions runs daily to fetch the latest TLD list from ICANN
2. **Change Detection** - Compares with the current list to detect any changes
3. **Auto Publish** - If changes are detected, automatically:
   - Updates the TLD list
   - Increments the patch version
   - Runs tests to ensure data integrity
   - Publishes to pub.dev
   - Creates a GitHub release

### Manual Updates

You can also trigger updates manually by running the GitHub Action workflow or by running the update script locally:

```bash
dart run scripts/update.dart
```
