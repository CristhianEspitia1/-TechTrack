import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/stats_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../jobs/presentation/screens/job_entry_screen.dart';
import '../../../auth/data/auth_service.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final recentJobsAsync = ref.watch(recentJobsProvider);
    final currencyFormat = NumberFormat.currency(symbol: '$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('TECHTRACK'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: statsAsync.when(
        data: (stats) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumen Financiero',
                      style: TextStyle(fontSize: 16, color: Colors.white54, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Hoy',
                            value: currencyFormat.format(stats.dailyProfit),
                            icon: Icons.account_balance_wallet_outlined,
                            color: AppTheme.electricGreen,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'I Trabajos',
                            value: stats.totalJobs.toString(),
                            icon: Icons.build_circle_outlined,
                            color: AppTheme.neonCyan,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _StatCard(
                      title: 'Ganancia Semanal',
                      value: currencyFormat.format(stats.weeklyProfit),
                      icon: Icons.trending_up,
                      color: AppTheme.electricGreen,
                      isWide: true,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Últimos Trabajos',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            recentJobsAsync.when(
              data: (jobs) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final job = jobs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            job.customerName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Text(
                            DateFormat('dd MMM yyyy').format(job.serviceDate),
                            style: const TextStyle(color: Colors.white54),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currencyFormat.format(job.netProfit),
                                style: const TextStyle(
                                  color: AppTheme.electricGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const Text('Ganancia', style: TextStyle(fontSize: 10, color: Colors.white38)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: jobs.length,
                ),
              ),
              loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
              error: (e, s) => SliverToBoxAdapter(child: Text('Error: $e')),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const JobEntryScreen()),
          );
        },
        label: const Text('NUEVO TRABAJO', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isWide;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 28),
                if (isWide) Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white.withOpacity(0.2)),
              ],
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: isWide ? 32 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
