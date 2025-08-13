import 'dart:convert';
import 'package:flutter/services.dart';

class CurriculumService {
  static const String _assetPath = 'assets/data/curriculum_modules.json';
  static Map<String, dynamic>? _curriculumData;

  static Future<Map<String, dynamic>> _loadCurriculumData() async {
    if (_curriculumData != null) {
      print('Using cached curriculum data');
      return _curriculumData!;
    }

    try {
      print('Loading curriculum data from $_assetPath');
      final String jsonString = await rootBundle.loadString(_assetPath);
      print('JSON loaded successfully, length: ${jsonString.length}');
      _curriculumData = json.decode(jsonString);
      print('JSON parsed successfully, keys: ${_curriculumData!.keys}');
      return _curriculumData!;
    } catch (e) {
      print('ERROR loading curriculum data: $e');
      throw Exception('Failed to load curriculum data: $e');
    }
  }

  static Future<List<String>> getModulesForUser(
      String specialty, String studyYear) async {
    try {
      print('Getting modules for specialty: "$specialty", year: "$studyYear"');
      final curriculumData = await _loadCurriculumData();

      final normalizedSpecialty = _normalizeSpecialtyName(specialty);
      print('Normalized specialty: "$normalizedSpecialty"');
      print('Available specialties in data: ${curriculumData.keys}');

      if (curriculumData.containsKey(normalizedSpecialty)) {
        final specialtyData =
            curriculumData[normalizedSpecialty] as Map<String, dynamic>;
        print('Available years for specialty: ${specialtyData.keys}');

        if (specialtyData.containsKey(studyYear)) {
          final modules = specialtyData[studyYear] as List<dynamic>;
          print('Found ${modules.length} modules: $modules');
          return modules.cast<String>();
        } else {
          print('Study year "$studyYear" not found in specialty data');
        }
      } else {
        print('Specialty "$normalizedSpecialty" not found in curriculum data');
      }

      return [];
    } catch (e) {
      print('Error getting modules for user: $e');
      return [];
    }
  }

  static Future<List<String>> getAvailableYearsForSpecialty(
      String specialty) async {
    try {
      final curriculumData = await _loadCurriculumData();
      final normalizedSpecialty = _normalizeSpecialtyName(specialty);

      if (curriculumData.containsKey(normalizedSpecialty)) {
        final specialtyData =
            curriculumData[normalizedSpecialty] as Map<String, dynamic>;
        return specialtyData.keys.toList();
      }

      return [];
    } catch (e) {
      print('Error getting available years: $e');
      return [];
    }
  }

  static Future<List<String>> getAllModulesForSpecialty(
      String specialty) async {
    try {
      final curriculumData = await _loadCurriculumData();
      final normalizedSpecialty = _normalizeSpecialtyName(specialty);

      if (curriculumData.containsKey(normalizedSpecialty)) {
        final specialtyData =
            curriculumData[normalizedSpecialty] as Map<String, dynamic>;
        final Set<String> allModules = {};

        for (final yearData in specialtyData.values) {
          final modules = (yearData as List<dynamic>).cast<String>();
          allModules.addAll(modules);
        }

        return allModules.toList()..sort();
      }

      return [];
    } catch (e) {
      print('Error getting all modules for specialty: $e');
      return [];
    }
  }

  static Future<bool> isModuleValidForUser(
    String module,
    String specialty,
    String studyYear,
  ) async {
    final userModules = await getModulesForUser(specialty, studyYear);
    return userModules
        .any((m) => m.toLowerCase().contains(module.toLowerCase()));
  }

  static String _normalizeSpecialtyName(String specialty) {
    final specialtyMap = {
      'medecine': 'medecine',
      'médecine': 'medecine',
      'medicine': 'medecine',
      'pharmacie': 'pharmacie',
      'pharmacy': 'pharmacie',
      'dentaire': 'dentaire',
      'dental': 'dentaire',
      'dentistry': 'dentaire',
      'pharmacie industrielle': 'pharmacieIndustrielle',
      'pharmacieindustrielle': 'pharmacieIndustrielle',
      'industrial pharmacy': 'pharmacieIndustrielle',
    };

    final normalized = specialty.toLowerCase().replaceAll(' ', '');
    return specialtyMap[normalized] ?? specialty.toLowerCase();
  }

  static String getSpecialtyDisplayName(String specialty) {
    final displayNames = {
      'medecine': 'Médecine',
      'pharmacie': 'Pharmacie',
      'dentaire': 'Dentaire',
      'pharmacieIndustrielle': 'Pharmacie Industrielle',
    };

    return displayNames[_normalizeSpecialtyName(specialty)] ?? specialty;
  }

  static String getYearDisplayName(String year) {
    final displayNames = {
      '1ere': '1ère année',
      '2eme': '2ème année',
      '3eme': '3ème année',
      '4eme': '4ème année',
      '5eme': '5ème année',
    };

    return displayNames[year] ?? year;
  }
}
