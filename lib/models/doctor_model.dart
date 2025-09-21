import 'package:flutter/material.dart';

class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String qualification;
  final int experienceYears;
  final String hospitalName;
  final String hospitalAddress;
  final double rating;
  final int totalRatings;
  final String phone;
  final String email;
  final List<String> availableDays;
  final String availableTimeStart;
  final String availableTimeEnd;
  final double consultationFee;
  final bool isOnline;
  final String profileImageUrl;
  final List<String> languages;
  final String? description;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.qualification,
    required this.experienceYears,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.rating,
    required this.totalRatings,
    required this.phone,
    required this.email,
    required this.availableDays,
    required this.availableTimeStart,
    required this.availableTimeEnd,
    required this.consultationFee,
    required this.isOnline,
    this.profileImageUrl = '',
    this.languages = const ['Hindi', 'English'],
    this.description,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      qualification: json['qualification'] ?? '',
      experienceYears: json['experienceYears'] ?? 0,
      hospitalName: json['hospitalName'] ?? '',
      hospitalAddress: json['hospitalAddress'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalRatings: json['totalRatings'] ?? 0,
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      availableDays: List<String>.from(json['availableDays'] ?? []),
      availableTimeStart: json['availableTimeStart'] ?? '09:00',
      availableTimeEnd: json['availableTimeEnd'] ?? '17:00',
      consultationFee: (json['consultationFee'] ?? 0.0).toDouble(),
      isOnline: json['isOnline'] ?? false,
      profileImageUrl: json['profileImageUrl'] ?? '',
      languages: List<String>.from(json['languages'] ?? ['Hindi', 'English']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'qualification': qualification,
      'experienceYears': experienceYears,
      'hospitalName': hospitalName,
      'hospitalAddress': hospitalAddress,
      'rating': rating,
      'totalRatings': totalRatings,
      'phone': phone,
      'email': email,
      'availableDays': availableDays,
      'availableTimeStart': availableTimeStart,
      'availableTimeEnd': availableTimeEnd,
      'consultationFee': consultationFee,
      'isOnline': isOnline,
      'profileImageUrl': profileImageUrl,
      'languages': languages,
      'description': description,
    };
  }

  String get experienceText {
    return '$experienceYears ${experienceYears == 1 ? 'year' : 'years'} experience';
  }

  String get availabilityText {
    if (availableDays.isEmpty) return 'Not available';
    return '${availableDays.join(', ')} • $availableTimeStart - $availableTimeEnd';
  }

  bool get isAvailableNow {
    final now = DateTime.now();
    final currentDay = _getDayName(now.weekday);
    final currentTime = TimeOfDay.fromDateTime(now);
    
    if (!availableDays.contains(currentDay)) return false;
    
    final startTime = _parseTime(availableTimeStart);
    final endTime = _parseTime(availableTimeEnd);
    
    return _isTimeInRange(currentTime, startTime, endTime) && isOnline;
  }

  TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  bool _isTimeInRange(TimeOfDay current, TimeOfDay start, TimeOfDay end) {
    final currentMinutes = current.hour * 60 + current.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    
    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
      'Friday', 'Saturday', 'Sunday'
    ];
    return days[weekday - 1];
  }
}