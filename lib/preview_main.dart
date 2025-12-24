import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/jobs/domain/models/repair_job.dart';
import 'features/dashboard/presentation/providers/stats_provider.dart';

// MOCK DATA PARA VISUALIZACIÓN
final mockJobs = [
  RepairJob(
    id: '1',
    technicianId: 'demo',
    customerName: 'Juan Pérez',
    serviceDate: DateTime.now(),
    totalPrice: 250,
    partsCost: 50,
    diagnosticFee: 70,
  ),
  RepairJob(
    id: '2',
    technicianId: 'demo',
    customerName: 'María García',
    serviceDate: DateTime.now().subtract(const Duration(days: 1)),
    totalPrice: 180,
    partsCost: 30,
    diagnosticFee: 70,
  ),
  RepairJob(
    id: '3',
    technicianId: 'demo',
    customerName: 'Talleres Central',
    serviceDate: DateTime.now().subtract(const Duration(days: 3)),
    totalPrice: 400,
    partsCost: 120,
    diagnosticFee: 70,
  ),
];

// Creamos un provider simple para los datos mockeados
final mockedStats = DashboardStats(
  dailyProfit: 200,
  weeklyProfit: 830,
  totalJobs: 3,
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ProviderScope(
      overrides: [
        dashboardStatsProvider.overrideWith((ref) => Stream.value(mockedStats)),
        recentJobsProvider.overrideWith((ref) => Stream.value(mockJobs)),
      ],
      child: const TechTrackApp(),
    ),
  );
}

class TechTrackApp extends StatelessWidget {
  const TechTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechTrack Preview',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const DashboardScreen(),
    );
  }
}
