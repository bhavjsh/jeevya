import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/dashboard_screen.dart';
import 'screens/symptom/symptom_input_screen.dart';
import 'screens/doctor/doctor_list_screen.dart';
import 'screens/consultation/consultation_screen.dart';
import 'screens/pharmacy/pharmacy_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/health_provider.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HealthProvider()),
      ],
      child: MaterialApp(
        title: 'Rural Health Connect',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/symptom-input': (context) => const SymptomInputScreen(),
          '/doctors': (context) => const DoctorListScreen(),
          '/consultation': (context) => const ConsultationScreen(),
          '/pharmacy': (context) => const PharmacyScreen(),
        },
      ),
    );
  }
}
