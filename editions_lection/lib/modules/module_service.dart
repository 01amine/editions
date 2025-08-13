import 'dart:convert';
import 'package:flutter/services.dart';

class CurriculumService {
  static const String _assetPath = 'assets/data/curriculum_modules.json';
  static Map<String, dynamic>? _curriculumData;

  
  static Future<Map<String, dynamic>> _loadCurriculumData() async {
    if (_curriculumData != null) {
      return _curriculumData!;
    }

    try {
      final String jsonString = await rootBundle.loadString(_assetPath);
      _curriculumData = json.decode(jsonString);
      return _curriculumData!;
    } catch (e) {
      throw Exception('Failed to load curriculum data: $e');
    }
  }

  
  static Future<List<String>> getModulesForUser(
    String specialty, 
    String studyYear
  ) async {
    try {
      final curriculumData = await _loadCurriculumData();
      
      
      final normalizedSpecialty = _normalizeSpecialtyName(specialty);
      
      if (curriculumData.containsKey(normalizedSpecialty)) {
        final specialtyData = curriculumData[normalizedSpecialty] as Map<String, dynamic>;
        
        if (specialtyData.containsKey(studyYear)) {
          final modules = specialtyData[studyYear] as List<dynamic>;
          return modules.cast<String>();
        }
      }
      
      return [];
    } catch (e) {
      print('Error getting modules for user: $e');
      return [];
    }
  }

  
  static Future<List<String>> getAvailableYearsForSpecialty(String specialty) async {
    try {
      final curriculumData = await _loadCurriculumData();
      final normalizedSpecialty = _normalizeSpecialtyName(specialty);
      
      if (curriculumData.containsKey(normalizedSpecialty)) {
        final specialtyData = curriculumData[normalizedSpecialty] as Map<String, dynamic>;
        return specialtyData.keys.toList();
      }
      
      return [];
    } catch (e) {
      print('Error getting available years: $e');
      return [];
    }
  }

  
  static Future<List<String>> getAllModulesForSpecialty(String specialty) async {
    try {
      final curriculumData = await _loadCurriculumData();
      final normalizedSpecialty = _normalizeSpecialtyName(specialty);
      
      if (curriculumData.containsKey(normalizedSpecialty)) {
        final specialtyData = curriculumData[normalizedSpecialty] as Map<String, dynamic>;
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
    return userModules.any((m) => m.toLowerCase().contains(module.toLowerCase()));
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