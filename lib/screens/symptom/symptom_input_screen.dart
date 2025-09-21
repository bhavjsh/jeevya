import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/health_provider.dart';
import '../../utils/app_theme.dart';

class SymptomInputScreen extends StatefulWidget {
  const SymptomInputScreen({super.key});

  @override
  State<SymptomInputScreen> createState() => _SymptomInputScreenState();
}

class _SymptomInputScreenState extends State<SymptomInputScreen> {
  final TextEditingController _symptomController = TextEditingController();
  bool _isListening = false;
  
  final List<String> _commonSymptoms = [
    'Fever',
    'Cough',
    'Headache',
    'Body ache',
    'Sore throat',
    'Nausea',
    'Stomach pain',
    'Chest pain',
    'Breathing difficulty',
    'Dizziness',
    'Cold',
    'Runny nose',
  ];

  @override
  void dispose() {
    _symptomController.dispose();
    super.dispose();
  }

  void _addSymptom(String symptom) {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    healthProvider.addSymptom(symptom);
    _symptomController.clear();
  }

  void _removeSymptom(String symptom) {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    healthProvider.removeSymptom(symptom);
  }

  void _startListening() {
    setState(() {
      _isListening = true;
    });
    
    // Simulate voice input
    Future.delayed(const Duration(seconds: 3), () {
      if (_isListening) {
        setState(() {
          _isListening = false;
        });
        _symptomController.text = 'Fever and headache';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice input received: "Fever and headache"'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    });
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
  }

  void _analyzeSymptoms() async {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    await healthProvider.analyzeSymptoms();
    
    if (healthProvider.symptomAnalysis.isNotEmpty) {
      _showAnalysisDialog(healthProvider);
    }
  }

  void _showAnalysisDialog(HealthProvider healthProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.psychology, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              const Text('AI Analysis'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Analysis Result:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(healthProvider.symptomAnalysis),
                const SizedBox(height: 16),
                const Text(
                  'Recommendation:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  healthProvider.recommendation,
                  style: TextStyle(
                    color: healthProvider.recommendation.contains('URGENT')
                        ? AppTheme.errorColor
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/doctors');
              },
              child: const Text('Find Doctors'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Checker'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Consumer<HealthProvider>(
        builder: (context, healthProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.1),
                        AppTheme.secondaryColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.health_and_safety,
                        size: 48,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'AI-Powered Symptom Analysis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Describe your symptoms to get AI-based health recommendations',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Input Section
                const Text(
                  'Tell us your symptoms',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Voice/Text Input
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _symptomController,
                        decoration: InputDecoration(
                          hintText: 'Type your symptoms here...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.edit),
                        ),
                        maxLines: 3,
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            _addSymptom(value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        // Voice Input Button
                        GestureDetector(
                          onTapDown: (_) => _startListening(),
                          onTapUp: (_) => _stopListening(),
                          onTapCancel: () => _stopListening(),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: _isListening 
                                  ? AppTheme.errorColor 
                                  : AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              _isListening ? Icons.mic : Icons.mic_none,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Add Button
                        InkWell(
                          onTap: () {
                            if (_symptomController.text.isNotEmpty) {
                              _addSymptom(_symptomController.text);
                            }
                          },
                          child: Container(
                            width: 56,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                if (_isListening) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.errorColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.mic,
                          color: AppTheme.errorColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Listening... Speak your symptoms in Hindi, Punjabi, or English',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.errorColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 24),
                
                // Added Symptoms
                if (healthProvider.symptoms.isNotEmpty) ...[
                  const Text(
                    'Your Symptoms:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: healthProvider.symptoms.map((symptom) {
                      return Chip(
                        label: Text(symptom),
                        onDeleted: () => _removeSymptom(symptom),
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        deleteIconColor: AppTheme.primaryColor,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Common Symptoms
                const Text(
                  'Common Symptoms:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _commonSymptoms.map((symptom) {
                    final isSelected = healthProvider.symptoms.contains(symptom.toLowerCase());
                    return FilterChip(
                      label: Text(symptom),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          _addSymptom(symptom);
                        } else {
                          _removeSymptom(symptom);
                        }
                      },
                      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                      checkmarkColor: AppTheme.primaryColor,
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 32),
                
                // Analyze Button
                if (healthProvider.symptoms.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: healthProvider.isLoading ? null : _analyzeSymptoms,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: healthProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.psychology),
                                const SizedBox(width: 8),
                                const Text(
                                  'Analyze Symptoms with AI',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Clear Button
                if (healthProvider.symptoms.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        healthProvider.clearSymptoms();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Clear All Symptoms',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 32),
                
                // Disclaimer
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.warningColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.warningColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Medical Disclaimer',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'This AI analysis is for informational purposes only and should not replace professional medical advice. Always consult with a qualified healthcare provider for proper diagnosis and treatment.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}