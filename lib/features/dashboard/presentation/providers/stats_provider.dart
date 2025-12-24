import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../jobs/data/job_service.dart';
import '../../../jobs/domain/models/repair_job.dart';

class DashboardStats {
  final double dailyProfit;
  final double weeklyProfit;
  final int totalJobs;

  DashboardStats({
    this.dailyProfit = 0.0,
    this.weeklyProfit = 0.0,
    this.totalJobs = 0,
  });
}

final dashboardStatsProvider = StreamProvider<DashboardStats>((ref) {
  final jobService = ref.watch(jobServiceProvider);
  
  return jobService.getDashboardJobs().map((jobs) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = today.subtract(const Duration(days: 7));

    double dailyProfit = 0;
    double weeklyProfit = 0;

    for (var job in jobs) {
      if (job.serviceDate.isAfter(today) || job.serviceDate.isAtSameMomentAs(today)) {
        dailyProfit += job.netProfit;
      }
      if (job.serviceDate.isAfter(weekAgo)) {
        weeklyProfit += job.netProfit;
      }
    }

    return DashboardStats(
      dailyProfit: dailyProfit,
      weeklyProfit: weeklyProfit,
      totalJobs: jobs.length,
    );
  });
});

final recentJobsProvider = StreamProvider<List<RepairJob>>((ref) {
  return ref.watch(jobServiceProvider).getRecentJobs();
});
