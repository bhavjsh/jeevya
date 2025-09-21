import 'package:flutter/material.dart';
import '../models/doctor_model.dart';

class HealthProvider extends ChangeNotifier {
  List<String> _symptoms = [];
  String _symptomAnalysis = '';
  String _recommendation = '';
  List<Doctor> _doctors = [];
  List<Doctor> _filteredDoctors = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedSpecialization = 'All';

  // Getters
  List<String> get symptoms => _symptoms;
  String get symptomAnalysis => _symptomAnalysis;
  String get recommendation => _recommendation;
  List<Doctor> get doctors => _filteredDoctors.isEmpty ? _doctors : _filteredDoctors;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedSpecialization => _selectedSpecialization;

  // Initialize with sample doctors
  HealthProvider() {
    _loadSampleDoctors();
  }

  void _loadSampleDoctors() {
    _doctors = [
      Doctor(
        id: '1',
        name: 'Dr. Rajesh Kumar',
        specialization: 'General Medicine',
        qualification: 'MBBS, MD',
        experienceYears: 15,
        hospitalName: 'Nabha Civil Hospital',
        hospitalAddress: 'Civil Lines, Nabha, Punjab',
        rating: 4.5,
        totalRatings: 127,
        phone: '+91 98765 43210',
        email: 'rajesh@hospital.com',
        availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Friday'],
        availableTimeStart: '09:00',
        availableTimeEnd: '17:00',
        consultationFee: 200.0,
        isOnline: true,
        languages: ['Hindi', 'Punjabi', 'English'],
        description: 'Experienced general physician specializing in rural healthcare.',
      ),
      Doctor(
        id: '2',
        name: 'Dr. Priya Sharma',
        specialization: 'Pediatrics',
        qualification: 'MBBS, DCH',
        experienceYears: 8,
        hospitalName: 'Nabha Civil Hospital',
        hospitalAddress: 'Civil Lines, Nabha, Punjab',
        rating: 4.7,
        totalRatings: 89,
        phone: '+91 98765 43211',
        email: 'priya@hospital.com',
        availableDays: ['Monday', 'Wednesday', 'Thursday', 'Saturday'],
        availableTimeStart: '10:00',
        availableTimeEnd: '16:00',
        consultationFee: 250.0,
        isOnline: true,
        languages: ['Hindi', 'Punjabi', 'English'],
        description: 'Child specialist with focus on preventive care and nutrition.',
      ),
      Doctor(
        id: '3',
        name: 'Dr. Amjad Singh',
        specialization: 'Cardiology',
        qualification: 'MBBS, DM Cardiology',
        experienceYears: 12,
        hospitalName: 'Max Hospital Patiala',
        hospitalAddress: 'Patiala, Punjab',
        rating: 4.8,
        totalRatings: 156,
        phone: '+91 98765 43212',
        email: 'amjad@maxhospital.com',
        availableDays: ['Tuesday', 'Thursday', 'Saturday'],
        availableTimeStart: '11:00',
        availableTimeEnd: '15:00',
        consultationFee: 500.0,
        isOnline: false,
        languages: ['Hindi', 'Punjabi', 'English'],
        description: 'Heart specialist with expertise in preventive cardiology.',
      ),
      Doctor(
        id: '4',
        name: 'Dr. Manpreet Kaur',
        specialization: 'Gynecology',
        qualification: 'MBBS, MS Gynecology',
        experienceYears: 10,
        hospitalName: 'Nabha Civil Hospital',
        hospitalAddress: 'Civil Lines, Nabha, Punjab',
        rating: 4.6,
        totalRatings: 98,
        phone: '+91 98765 43213',
        email: 'manpreet@hospital.com',
        availableDays: ['Monday', 'Tuesday', 'Thursday', 'Friday'],
        availableTimeStart: '09:00',
        availableTimeEnd: '14:00',
        consultationFee: 300.0,
        isOnline: true,
        languages: ['Hindi', 'Punjabi', 'English'],
        description: 'Women\'s health specialist focusing on maternal care.',
      ),
    ];
    _filteredDoctors = _doctors;
  }

  // Add symptom
  void addSymptom(String symptom) {
    if (symptom.isNotEmpty && !_symptoms.contains(symptom.toLowerCase())) {
      _symptoms.add(symptom.toLowerCase());
      notifyListeners();
    }
  }

  // Remove symptom
  void removeSymptom(String symptom) {
    _symptoms.remove(symptom.toLowerCase());
    notifyListeners();
  }

  // Clear all symptoms
  void clearSymptoms() {
    _symptoms.clear();
    _symptomAnalysis = '';
    _recommendation = '';
    notifyListeners();
  }

  // Analyze symptoms using AI (simulated)
  Future<void> analyzeSymptoms() async {
    if (_symptoms.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate AI analysis delay
      await Future.delayed(const Duration(seconds: 3));

      // Simple rule-based analysis for demo
      _analyzeWithRules();

    } catch (e) {
      _errorMessage = 'Failed to analyze symptoms';
    }

    _isLoading = false;
    notifyListeners();
  }

  void _analyzeWithRules() {
    // Fever-related conditions
    if (_symptoms.any((s) => s.contains('fever') || s.contains('temperature'))) {
      if (_symptoms.any((s) => s.contains('cough') || s.contains('throat'))) {
        _symptomAnalysis = 'Possible respiratory infection or flu';
        _recommendation = 'General Medicine specialist recommended. Stay hydrated and rest.';
      } else if (_symptoms.any((s) => s.contains('headache') || s.contains('body ache'))) {
        _symptomAnalysis = 'Possible viral infection';
        _recommendation = 'General Medicine consultation suggested. Monitor temperature.';
      } else {
        _symptomAnalysis = 'Fever detected';
        _recommendation = 'General Medicine consultation recommended.';
      }
    }
    // Heart-related symptoms
    else if (_symptoms.any((s) => s.contains('chest') || s.contains('heart') || s.contains('breathing'))) {
      _symptomAnalysis = 'Possible cardiac or respiratory concern';
      _recommendation = 'URGENT: Cardiology consultation recommended immediately.';
    }
    // Digestive issues
    else if (_symptoms.any((s) => s.contains('stomach') || s.contains('nausea') || s.contains('vomit'))) {
      _symptomAnalysis = 'Possible digestive issue';
      _recommendation = 'General Medicine consultation suggested. Avoid heavy meals.';
    }
    // Headache
    else if (_symptoms.any((s) => s.contains('headache') || s.contains('migraine'))) {
      _symptomAnalysis = 'Headache or migraine symptoms';
      _recommendation = 'General Medicine or Neurology consultation may help.';
    }
    // General symptoms
    else {
      _symptomAnalysis = 'General health concerns identified';
      _recommendation = 'General Medicine consultation recommended for proper diagnosis.';
    }
  }

  // Filter doctors by specialization
  void filterDoctorsBySpecialization(String specialization) {
    _selectedSpecialization = specialization;
    
    if (specialization == 'All') {
      _filteredDoctors = _doctors;
    } else {
      _filteredDoctors = _doctors.where((doctor) => 
        doctor.specialization.toLowerCase().contains(specialization.toLowerCase())
      ).toList();
    }
    
    notifyListeners();
  }

  // Get available specializations
  List<String> get availableSpecializations {
    final specializations = _doctors.map((d) => d.specialization).toSet().toList();
    specializations.insert(0, 'All');
    return specializations;
  }

  // Search doctors
  void searchDoctors(String query) {
    if (query.isEmpty) {
      _filteredDoctors = _selectedSpecialization == 'All' 
          ? _doctors 
          : _doctors.where((d) => d.specialization.toLowerCase()
              .contains(_selectedSpecialization.toLowerCase())).toList();
    } else {
      final baseList = _selectedSpecialization == 'All' 
          ? _doctors 
          : _doctors.where((d) => d.specialization.toLowerCase()
              .contains(_selectedSpecialization.toLowerCase())).toList();
              
      _filteredDoctors = baseList.where((doctor) =>
        doctor.name.toLowerCase().contains(query.toLowerCase()) ||
        doctor.specialization.toLowerCase().contains(query.toLowerCase()) ||
        doctor.hospitalName.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    
    notifyListeners();
  }

  // Get doctor by ID
  Doctor? getDoctorById(String id) {
    try {
      return _doctors.firstWhere((doctor) => doctor.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}