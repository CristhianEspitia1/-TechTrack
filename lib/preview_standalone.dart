import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  runApp(const TechTrackApp());
}

// ========== THEME ==========
class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;
  void toggle() { _isDark = !_isDark; notifyListeners(); }
}

final themeNotifier = ThemeNotifier();

class AppTheme {
  // Light Theme - Clean & Soft
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightText = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);
  
  // Dark Theme - Premium & Vibrant (REDISEÑADO)
  static const Color darkBg = Color(0xFF0F0F1A);           // Azul oscuro profundo
  static const Color darkCard = Color(0xFF1A1A2E);          // Azul-violeta oscuro
  static const Color darkCardHover = Color(0xFF252542);     // Más claro al hover
  static const Color darkBorder = Color(0xFF2D2D4A);        // Borde violeta sutil
  static const Color darkText = Color(0xFFF8F8FF);          // Blanco fantasma
  static const Color darkTextSecondary = Color(0xFFB8B8D1); // Lavanda suave
  static const Color darkTextMuted = Color(0xFF6B6B8D);     // Gris azulado
  
  // Accents - Más Vibrantes
  static const Color primary = Color(0xFF7C3AED);           // Violeta vibrante
  static const Color primaryLight = Color(0xFFA78BFA);      // Violeta claro
  static const Color primaryBright = Color(0xFF8B5CF6);     // Violeta brillante
  static const Color success = Color(0xFF22D3EE);           // Cyan brillante (en lugar de verde)
  static const Color successAlt = Color(0xFF10B981);        // Esmeralda para dinero
  static const Color warning = Color(0xFFFBBF24);           // Amarillo más brillante
  static const Color danger = Color(0xFFF43F5E);            // Rosa-rojo vibrante
  static const Color accent = Color(0xFFE879F9);            // Fucsia/Magenta
  
  // Gradients - Premium
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), Color(0xFFA855F7), Color(0xFFE879F9)],
  );
  
  static const successGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF22D3EE)],
  );
  
  static const darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1E38), Color(0xFF1A1A2E)],
  );
  
  static const darkAccentGradient = LinearGradient(
    colors: [Color(0xFF2D2D4A), Color(0xFF1A1A2E)],
  );
}

// ========== MODELS ==========
class RepairJob {
  String id;
  String customerName;
  DateTime serviceDate;
  double totalPrice;
  double diagnosticFee;
  List<Part> parts;

  RepairJob({required this.id, required this.customerName, required this.serviceDate, required this.totalPrice, this.diagnosticFee = 70.0, List<Part>? parts}) : parts = parts ?? [];

  double get partsCost => parts.fold(0, (sum, p) => sum + p.price);
  double get netProfit => totalPrice - partsCost;
  
  // Garantía de 3 meses (90 días)
  static const int warrantyDays = 90;
  
  int get daysSinceService => DateTime.now().difference(serviceDate).inDays;
  bool get hasWarranty => daysSinceService < warrantyDays;
  int get warrantyDaysLeft => warrantyDays - daysSinceService;
  bool get warrantyExpired => !hasWarranty;
}

class Part {
  final String partNumber;
  final double price;
  Part({required this.partNumber, required this.price});
}

// ========== DATA ==========
List<RepairJob> jobs = [
  RepairJob(id: '1', customerName: 'Juan Pérez', serviceDate: DateTime.now(), totalPrice: 250, parts: [Part(partNumber: 'WR55X10942', price: 45)]),
  RepairJob(id: '2', customerName: 'María García', serviceDate: DateTime.now().subtract(const Duration(days: 1)), totalPrice: 180, parts: [Part(partNumber: 'W10130913', price: 35)]),
  RepairJob(id: '3', customerName: 'Talleres Central', serviceDate: DateTime.now().subtract(const Duration(days: 2)), totalPrice: 400, parts: [Part(partNumber: 'WPW10321304', price: 120)]),
  RepairJob(id: '4', customerName: 'Carlos Mendez', serviceDate: DateTime.now().subtract(const Duration(days: 4)), totalPrice: 320, parts: [Part(partNumber: '5304509706', price: 85)]),
  RepairJob(id: '5', customerName: 'Ana López', serviceDate: DateTime.now().subtract(const Duration(days: 6)), totalPrice: 150, parts: []),
  // Trabajos de meses anteriores para demo
  RepairJob(id: '6', customerName: 'Roberto Díaz', serviceDate: DateTime(2024, 11, 15), totalPrice: 275, parts: [Part(partNumber: 'WR51X10055', price: 55)]),
  RepairJob(id: '7', customerName: 'Laura Sánchez', serviceDate: DateTime(2024, 11, 20), totalPrice: 190, parts: []),
  RepairJob(id: '8', customerName: 'Pedro Ruiz', serviceDate: DateTime(2024, 10, 10), totalPrice: 350, parts: [Part(partNumber: 'DA32-00006W', price: 80)]),
];

double monthlyGoal = 5000.0;

// ========== APP ==========
class TechTrackApp extends StatefulWidget {
  const TechTrackApp({super.key});
  @override
  State<TechTrackApp> createState() => _TechTrackAppState();
}

class _TechTrackAppState extends State<TechTrackApp> {
  @override
  void initState() {
    super.initState();
    themeNotifier.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.isDark;
    return MaterialApp(
      key: ValueKey(isDark), // Fuerza rebuild completo al cambiar tema
      title: 'TechTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
        fontFamily: GoogleFonts.inter().fontFamily,
        // Colores para modo oscuro
        cardColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        dialogBackgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        canvasColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        colorScheme: isDark 
          ? const ColorScheme.dark(
              primary: AppTheme.primary,
              secondary: AppTheme.accent,
              surface: AppTheme.darkCard,
              background: AppTheme.darkBg,
              error: AppTheme.danger,
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: AppTheme.darkText,
              onBackground: AppTheme.darkText,
              onError: Colors.white,
            )
          : const ColorScheme.light(
              primary: AppTheme.primary,
              secondary: AppTheme.primaryLight,
              surface: AppTheme.lightCard,
              background: AppTheme.lightBg,
              error: AppTheme.danger,
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: AppTheme.lightText,
              onBackground: AppTheme.lightText,
              onError: Colors.white,
            ),
        // Input decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          ),
        ),
        // Date Picker
        datePickerTheme: DatePickerThemeData(
          backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          surfaceTintColor: Colors.transparent,
          headerBackgroundColor: AppTheme.primary,
          headerForegroundColor: Colors.white,
          dayStyle: GoogleFonts.inter(),
          weekdayStyle: GoogleFonts.inter(),
        ),
        // Dialog
        dialogTheme: DialogTheme(
          backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        // Bottom Sheet
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          surfaceTintColor: Colors.transparent,
          modalBackgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

// ========== DASHBOARD ==========
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _filter = 'Semana';
  String _searchQuery = '';
  String? _selectedMonth; // Para filtrar mes específico

  // Obtener meses únicos con datos
  List<String> get availableMonths {
    final months = <String>{};
    for (var job in jobs) {
      months.add(DateFormat('yyyy-MM').format(job.serviceDate));
    }
    final sorted = months.toList()..sort((a, b) => b.compareTo(a));
    return sorted;
  }

  // Filtrar trabajos según el filtro actual
  List<RepairJob> get filteredJobs {
    final now = DateTime.now();
    List<RepairJob> result = jobs;
    
    // Si hay búsqueda activa, buscar en TODO el historial
    if (_searchQuery.isNotEmpty) {
      result = result.where((j) => j.customerName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
      result.sort((a, b) => b.serviceDate.compareTo(a.serviceDate));
      return result;
    }
    
    // Si no hay búsqueda, aplicar filtro de fecha
    if (_filter == 'Día') {
      result = result.where((j) => _isSameDay(j.serviceDate, now)).toList();
    } else if (_filter == 'Semana') {
      final weekAgo = now.subtract(const Duration(days: 7));
      result = result.where((j) => j.serviceDate.isAfter(weekAgo) || _isSameDay(j.serviceDate, weekAgo)).toList();
    } else if (_filter == 'Mes') {
      if (_selectedMonth != null) {
        result = result.where((j) => DateFormat('yyyy-MM').format(j.serviceDate) == _selectedMonth).toList();
      } else {
        result = result.where((j) => j.serviceDate.month == now.month && j.serviceDate.year == now.year).toList();
      }
    }
    
    result.sort((a, b) => b.serviceDate.compareTo(a.serviceDate));
    return result;
  }
  
  // Indica si hay búsqueda activa
  bool get isSearching => _searchQuery.isNotEmpty;

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  // Agrupar trabajos por día (para vista Semana)
  Map<String, List<RepairJob>> get jobsGroupedByDay {
    final grouped = <String, List<RepairJob>>{};
    for (var job in filteredJobs) {
      final key = DateFormat('yyyy-MM-dd').format(job.serviceDate);
      grouped.putIfAbsent(key, () => []).add(job);
    }
    return grouped;
  }

  // Obtener nombre del día
  String _getDayName(String dateKey) {
    final date = DateTime.parse(dateKey);
    final now = DateTime.now();
    if (_isSameDay(date, now)) return 'Hoy';
    if (_isSameDay(date, now.subtract(const Duration(days: 1)))) return 'Ayer';
    return DateFormat('EEEE d', 'es_ES').format(date);
  }

  // Obtener nombre del mes
  String _getMonthName(String monthKey) {
    final parts = monthKey.split('-');
    final date = DateTime(int.parse(parts[0]), int.parse(parts[1]));
    final now = DateTime.now();
    if (date.month == now.month && date.year == now.year) return 'Este mes';
    return DateFormat('MMMM yyyy', 'es_ES').format(date);
  }

  double get totalProfit => filteredJobs.fold(0, (sum, j) => sum + j.netProfit);
  double get monthlyTotal => jobs.where((j) => j.serviceDate.month == DateTime.now().month && j.serviceDate.year == DateTime.now().year).fold<double>(0, (sum, j) => sum + j.netProfit);
  double get monthlyProgress => (monthlyTotal / monthlyGoal).clamp(0.0, 1.0);

  void _deleteJob(RepairJob job) {
    setState(() => jobs.removeWhere((j) => j.id == job.id));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trabajo eliminado', style: GoogleFonts.inter()), backgroundColor: AppTheme.danger, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), margin: const EdgeInsets.all(16)));
  }

  void _editJob(RepairJob job) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => JobEntryScreen(editJob: job))).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.isDark;
    final textPrimary = isDark ? AppTheme.darkText : AppTheme.lightText;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
    final textMuted = isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
    final currency = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TechTrack', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w700, color: textPrimary, letterSpacing: -0.5)),
                        Text('Panel de Control', style: GoogleFonts.inter(fontSize: 13, color: textMuted)),
                      ],
                    ),
                    Row(
                      children: [
                        _IconBtn(icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, onTap: () => themeNotifier.toggle(), isDark: isDark),
                        const SizedBox(width: 10),
                        Container(
                          width: 42, height: 42,
                          decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Text('T', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Search
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor.withOpacity(0.6))),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: GoogleFonts.inter(color: textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Buscar cliente...',
                      hintStyle: GoogleFonts.inter(color: textMuted, fontSize: 14),
                      prefixIcon: Icon(Icons.search_rounded, color: textMuted, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty ? IconButton(icon: Icon(Icons.close_rounded, color: textMuted, size: 18), onPressed: () => setState(() => _searchQuery = '')) : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),
            ),

            // Filters
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Row(
                  children: ['Día', 'Semana', 'Mes'].map((f) {
                    final isSelected = _filter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() { _filter = f; _selectedMonth = null; }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                          decoration: BoxDecoration(
                            gradient: isSelected ? AppTheme.primaryGradient : null,
                            color: isSelected ? null : cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: isSelected ? null : Border.all(color: borderColor.withOpacity(0.6)),
                          ),
                          child: Text(f, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : textSecondary)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Month Selector (solo si filter == Mes)
            if (_filter == 'Mes' && availableMonths.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: availableMonths.map((monthKey) {
                        final isSelected = _selectedMonth == monthKey || (_selectedMonth == null && monthKey == availableMonths.first);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedMonth = monthKey),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.primary.withOpacity(0.15) : cardColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isSelected ? AppTheme.primary : borderColor.withOpacity(0.6)),
                              ),
                              child: Text(
                                _getMonthName(monthKey),
                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: isSelected ? AppTheme.primary : textSecondary),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

            // Stats Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  children: [
                    // Monthly Goal
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: isDark ? AppTheme.darkCardGradient : null,
                        color: isDark ? null : cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor.withOpacity(isDark ? 0.3 : 0.6)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: AppTheme.warning.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.flag_rounded, color: AppTheme.warning, size: 16)),
                                  const SizedBox(width: 8),
                                  Text('Meta Mensual', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: textPrimary)),
                                ],
                              ),
                              _IconBtn(icon: Icons.edit_rounded, onTap: () => _showGoalSheet(context), isDark: isDark, size: 32),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(currency.format(monthlyTotal), style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: textPrimary, letterSpacing: -1)),
                              const SizedBox(width: 6),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text('/ ${currency.format(monthlyGoal)}', style: GoogleFonts.inter(fontSize: 13, color: textMuted)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: LinearProgressIndicator(value: monthlyProgress, minHeight: 6, backgroundColor: borderColor.withOpacity(0.4), valueColor: AlwaysStoppedAnimation(monthlyProgress >= 1 ? AppTheme.success : AppTheme.primary)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Quick Stats
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(gradient: isDark ? AppTheme.darkCardGradient : null, color: isDark ? null : cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor.withOpacity(isDark ? 0.3 : 0.6))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: AppTheme.success.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.trending_up_rounded, color: AppTheme.success, size: 14)),
                                  const SizedBox(width: 6),
                                  Text('Ganancia', style: GoogleFonts.inter(fontSize: 11, color: textMuted)),
                                ]),
                                const SizedBox(height: 8),
                                Text(currency.format(totalProfit), style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.success)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(gradient: isDark ? AppTheme.darkCardGradient : null, color: isDark ? null : cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor.withOpacity(isDark ? 0.3 : 0.6))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.handyman_rounded, color: AppTheme.primary, size: 14)),
                                  const SizedBox(width: 6),
                                  Text('Trabajos', style: GoogleFonts.inter(fontSize: 11, color: textMuted)),
                                ]),
                                const SizedBox(height: 8),
                                Text(filteredJobs.length.toString(), style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Historial Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isSearching ? 'Resultados' : 'Historial',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
                    ),
                    if (isSearching)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                        child: Text('${filteredJobs.length} encontrados', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.primary)),
                      ),
                  ],
                ),
              ),
            ),

            // Jobs List - Grouped
            if (filteredJobs.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: borderColor.withOpacity(0.2), shape: BoxShape.circle), child: Icon(Icons.inbox_rounded, size: 32, color: textMuted)),
                      const SizedBox(height: 12),
                      Text('Sin trabajos', style: GoogleFonts.inter(fontSize: 14, color: textSecondary)),
                    ],
                  ),
                ),
              )
            else if (_filter == 'Semana' && !isSearching)
              // Vista Semana: Agrupado por día
              ...jobsGroupedByDay.entries.map((entry) {
                final dayJobs = entry.value;
                final dayTotal = dayJobs.fold<double>(0, (sum, j) => sum + j.netProfit);
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Day Header
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_getDayName(entry.key).toUpperCase(), style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary, letterSpacing: 0.5)),
                              Text(currency.format(dayTotal), style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.success)),
                            ],
                          ),
                        ),
                        // Day Jobs
                        ...dayJobs.map((job) => _buildJobCard(job, isDark, textPrimary, textSecondary, textMuted, cardColor, borderColor, currency)),
                      ],
                    ),
                  ),
                );
              }).toList()
            else
              // Vista Día o Mes: Lista simple
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final job = filteredJobs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildJobCard(job, isDark, textPrimary, textSecondary, textMuted, cardColor, borderColor, currency),
                    );
                  },
                  childCount: filteredJobs.length,
                ),
              ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 5))]),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JobEntryScreen())).then((_) => setState(() {})),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.add_rounded, color: Colors.white, size: 18), const SizedBox(width: 5), Text('Nuevo', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13))]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(RepairJob job, bool isDark, Color textPrimary, Color textSecondary, Color textMuted, Color cardColor, Color borderColor, NumberFormat currency) {
    // Colores de garantía
    final warrantyColor = job.hasWarranty ? AppTheme.success : AppTheme.danger;
    final warrantyBg = warrantyColor.withOpacity(0.12);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: Key(job.id),
        direction: DismissDirection.endToStart,
        background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 16), decoration: BoxDecoration(color: AppTheme.danger.withOpacity(0.15), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.delete_rounded, color: AppTheme.danger, size: 20)),
        confirmDismiss: (_) async => await showDialog(context: context, builder: (ctx) => AlertDialog(backgroundColor: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), title: Text('¿Eliminar?', style: GoogleFonts.inter(color: textPrimary, fontSize: 16)), content: Text('Este trabajo será eliminado', style: GoogleFonts.inter(color: textSecondary, fontSize: 13)), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('No', style: GoogleFonts.inter(color: textMuted))), TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Sí', style: GoogleFonts.inter(color: AppTheme.danger)))])),
        onDismissed: (_) => _deleteJob(job),
        child: GestureDetector(
          onTap: () => _editJob(job),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: isDark ? AppTheme.darkCardGradient : null, 
              color: isDark ? null : cardColor, 
              borderRadius: BorderRadius.circular(14), 
              border: Border.all(color: job.warrantyExpired ? AppTheme.danger.withOpacity(0.3) : borderColor.withOpacity(isDark ? 0.3 : 0.6)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar con indicador de garantía
                    Stack(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                          child: Center(child: Text(job.customerName[0].toUpperCase(), style: GoogleFonts.inter(color: AppTheme.primary, fontWeight: FontWeight.w600, fontSize: 14))),
                        ),
                        // Indicador pequeño de garantía en el avatar
                        if (job.warrantyExpired)
                          Positioned(
                            right: -2, top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(color: AppTheme.danger, shape: BoxShape.circle, border: Border.all(color: isDark ? AppTheme.darkCard : cardColor, width: 2)),
                              child: const Icon(Icons.warning_rounded, color: Colors.white, size: 8),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(job.customerName, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: textPrimary)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              // Badge de garantía
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: warrantyBg, borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      job.hasWarranty ? Icons.verified_rounded : Icons.warning_amber_rounded,
                                      size: 10,
                                      color: warrantyColor,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      job.hasWarranty 
                                        ? '${job.warrantyDaysLeft}d' 
                                        : 'Sin garantía',
                                      style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: warrantyColor),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              if (job.parts.isNotEmpty) ...[
                                Icon(Icons.memory_rounded, size: 10, color: AppTheme.warning),
                                const SizedBox(width: 2),
                                Text('${job.parts.length}', style: GoogleFonts.inter(fontSize: 10, color: AppTheme.warning)),
                                const SizedBox(width: 6),
                              ],
                              Text(DateFormat('dd MMM', 'es_ES').format(job.serviceDate), style: GoogleFonts.inter(color: textMuted, fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(currency.format(job.netProfit), style: GoogleFonts.inter(color: AppTheme.success, fontWeight: FontWeight.w700, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showGoalSheet(BuildContext context) {
    final isDark = themeNotifier.isDark;
    final controller = TextEditingController(text: monthlyGoal.toStringAsFixed(0));
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
        decoration: BoxDecoration(color: isDark ? AppTheme.darkCard : AppTheme.lightCard, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 32, height: 4, decoration: BoxDecoration(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 18),
            Text('Meta Mensual', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? AppTheme.darkText : AppTheme.lightText)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: isDark ? AppTheme.darkBg : AppTheme.lightBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder)),
              child: TextField(controller: controller, keyboardType: TextInputType.number, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: isDark ? AppTheme.darkText : AppTheme.lightText), decoration: InputDecoration(prefixText: '\$ ', prefixStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 12))),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () { setState(() => monthlyGoal = double.tryParse(controller.text) ?? 5000); Navigator.pop(ctx); },
              child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(10)), child: Center(child: Text('Guardar', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)))),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== CUSTOM DATE PICKER (Moderno y Elegante) ==========
class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({super.key, required this.initialDate, required this.onDateSelected});

  static Future<DateTime?> show(BuildContext context, DateTime initialDate) async {
    return await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CustomDatePicker(
        initialDate: initialDate,
        onDateSelected: (date) => Navigator.pop(ctx, date),
      ),
    );
  }

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  List<DateTime> get _daysInMonth {
    final first = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final last = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final days = <DateTime>[];
    
    // Días del mes anterior para llenar la primera semana
    final firstWeekday = first.weekday;
    for (int i = firstWeekday - 1; i > 0; i--) {
      days.add(first.subtract(Duration(days: i)));
    }
    
    // Días del mes actual
    for (int i = 0; i < last.day; i++) {
      days.add(DateTime(_currentMonth.year, _currentMonth.month, i + 1));
    }
    
    // Días del siguiente mes para completar la cuadrícula
    while (days.length % 7 != 0) {
      days.add(DateTime(_currentMonth.year, _currentMonth.month + 1, days.length - last.day - (firstWeekday - 1) + 1));
    }
    
    return days;
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
  bool _isToday(DateTime date) => _isSameDay(date, DateTime.now());
  bool _isCurrentMonth(DateTime date) => date.month == _currentMonth.month;

  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.isDark;
    final bgColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final textPrimary = isDark ? AppTheme.darkText : AppTheme.lightText;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
    final textMuted = isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;

    const weekDays = ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa', 'Do'];

    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(width: 36, height: 4, decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(2))),
          ),
          
          // Header con navegación
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1)),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: (isDark ? AppTheme.darkBg : AppTheme.lightBg), borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.chevron_left_rounded, color: textSecondary, size: 22),
                  ),
                ),
                Text(
                  DateFormat('MMMM yyyy', 'es_ES').format(_currentMonth),
                  style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w600, color: textPrimary),
                ),
                GestureDetector(
                  onTap: () => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1)),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: (isDark ? AppTheme.darkBg : AppTheme.lightBg), borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.chevron_right_rounded, color: textSecondary, size: 22),
                  ),
                ),
              ],
            ),
          ),
          
          // Días de la semana
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: weekDays.map((d) => Expanded(
                child: Center(child: Text(d, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: textMuted))),
              )).toList(),
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Días del mes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
              itemCount: _daysInMonth.length,
              itemBuilder: (ctx, i) {
                final day = _daysInMonth[i];
                final isSelected = _isSameDay(day, _selectedDate);
                final isToday = _isToday(day);
                final isCurrentMonth = _isCurrentMonth(day);
                
                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = day),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppTheme.primaryGradient : null,
                      color: isToday && !isSelected ? AppTheme.primary.withOpacity(0.12) : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected 
                            ? Colors.white 
                            : isCurrentMonth 
                              ? (isToday ? AppTheme.primary : textPrimary)
                              : textMuted.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Botones
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Row(
              children: [
                // Botón Hoy
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedDate = DateTime.now();
                      _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(color: (isDark ? AppTheme.darkBg : AppTheme.lightBg), borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text('Hoy', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: textSecondary))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Botón Confirmar
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => widget.onDateSelected(_selectedDate),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text('Confirmar', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final double size;
  const _IconBtn({required this.icon, required this.onTap, required this.isDark, this.size = 40});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(width: size, height: size, decoration: BoxDecoration(color: isDark ? AppTheme.darkCard : AppTheme.lightCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: isDark ? AppTheme.darkBorder.withOpacity(0.5) : AppTheme.lightBorder)), child: Icon(icon, color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary, size: size * 0.45)),
  );
}

// ========== JOB ENTRY ==========
class JobEntryScreen extends StatefulWidget {
  final RepairJob? editJob;
  const JobEntryScreen({super.key, this.editJob});
  @override
  State<JobEntryScreen> createState() => _JobEntryScreenState();
}

class _JobEntryScreenState extends State<JobEntryScreen> {
  late TextEditingController _customerController;
  late TextEditingController _totalController;
  late TextEditingController _diagnosticController;
  late DateTime _selectedDate;
  late List<Part> _parts;
  bool get isEditing => widget.editJob != null;

  @override
  void initState() {
    super.initState();
    _customerController = TextEditingController(text: widget.editJob?.customerName ?? '');
    _totalController = TextEditingController(text: widget.editJob?.totalPrice.toStringAsFixed(0) ?? '');
    _diagnosticController = TextEditingController(text: widget.editJob?.diagnosticFee.toStringAsFixed(0) ?? '70');
    _selectedDate = widget.editJob?.serviceDate ?? DateTime.now();
    _parts = widget.editJob?.parts.toList() ?? [];
  }

  double get totalParts => _parts.fold(0, (sum, p) => sum + p.price);

  void _save() {
    if (_customerController.text.isEmpty || _totalController.text.isEmpty) return;
    if (isEditing) {
      final idx = jobs.indexWhere((j) => j.id == widget.editJob!.id);
      if (idx != -1) { jobs[idx].customerName = _customerController.text; jobs[idx].totalPrice = double.tryParse(_totalController.text) ?? 0; jobs[idx].diagnosticFee = double.tryParse(_diagnosticController.text) ?? 70; jobs[idx].serviceDate = _selectedDate; jobs[idx].parts = _parts; }
    } else {
      jobs.insert(0, RepairJob(id: DateTime.now().millisecondsSinceEpoch.toString(), customerName: _customerController.text, serviceDate: _selectedDate, totalPrice: double.tryParse(_totalController.text) ?? 0, diagnosticFee: double.tryParse(_diagnosticController.text) ?? 70, parts: _parts));
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18), const SizedBox(width: 8), Text(isEditing ? 'Actualizado' : 'Guardado', style: GoogleFonts.inter(fontSize: 13))]), backgroundColor: AppTheme.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), margin: const EdgeInsets.all(16)));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.isDark;
    final textPrimary = isDark ? AppTheme.darkText : AppTheme.lightText;
    final textMuted = isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
    final bgColor = isDark ? AppTheme.darkBg : AppTheme.lightBg;
    final currency = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(backgroundColor: bgColor, elevation: 0, leading: Padding(padding: const EdgeInsets.only(left: 14), child: _IconBtn(icon: Icons.arrow_back_rounded, onTap: () => Navigator.pop(context), isDark: isDark, size: 36)), title: Text(isEditing ? 'Editar' : 'Nuevo Trabajo', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16, color: textPrimary)), centerTitle: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Cliente', textPrimary),
            const SizedBox(height: 6),
            _input(_customerController, 'Nombre', Icons.person_outline_rounded, cardColor, borderColor, textPrimary, textMuted),
            const SizedBox(height: 16),
            _label('Fecha', textPrimary),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                final picked = await CustomDatePicker.show(context, _selectedDate);
                if (picked != null) setState(() => _selectedDate = picked);
              },
              child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor.withOpacity(0.6))), child: Row(children: [Icon(Icons.calendar_today_rounded, color: textMuted, size: 16), const SizedBox(width: 8), Text(DateFormat('dd/MM/yyyy').format(_selectedDate), style: GoogleFonts.inter(color: textPrimary, fontSize: 13)), const Spacer(), Icon(Icons.unfold_more_rounded, color: textMuted, size: 16)])),
            ),
            const SizedBox(height: 16),
            _label('Precio Total', textPrimary),
            const SizedBox(height: 6),
            _input(_totalController, '0', Icons.attach_money_rounded, cardColor, borderColor, textPrimary, textMuted, isNumber: true),
            const SizedBox(height: 16),
            _label('Diagnóstico', textPrimary),
            const SizedBox(height: 6),
            _input(_diagnosticController, '70', Icons.search_rounded, cardColor, borderColor, textPrimary, textMuted, isNumber: true),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_label('Partes', textPrimary), GestureDetector(onTap: () => _showAddPart(context), child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(6)), child: Row(children: [const Icon(Icons.add_rounded, color: AppTheme.primary, size: 14), const SizedBox(width: 3), Text('Agregar', style: GoogleFonts.inter(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.w500))])))]),
            const SizedBox(height: 8),
            if (_parts.isEmpty) Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor.withOpacity(0.6))), child: Center(child: Text('Sin partes', style: GoogleFonts.inter(color: textMuted, fontSize: 12))))
            else ...List.generate(_parts.length, (i) { final p = _parts[i]; return Padding(padding: const EdgeInsets.only(bottom: 5), child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor.withOpacity(0.6))), child: Row(children: [Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: AppTheme.warning.withOpacity(0.12), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.memory_rounded, color: AppTheme.warning, size: 14)), const SizedBox(width: 8), Expanded(child: Text(p.partNumber, style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: textPrimary, fontSize: 12))), Text(currency.format(p.price), style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.warning, fontSize: 12)), const SizedBox(width: 6), GestureDetector(onTap: () => setState(() => _parts.removeAt(i)), child: Icon(Icons.close_rounded, color: textMuted, size: 16))]))); }),
            if (_parts.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text('Total: ', style: GoogleFonts.inter(color: textMuted, fontSize: 11)), Text(currency.format(totalParts), style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppTheme.warning, fontSize: 12))])),
            const SizedBox(height: 28),
            GestureDetector(onTap: _save, child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 13), decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12)), child: Center(child: Text(isEditing ? 'Actualizar' : 'Guardar', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14))))),
          ],
        ),
      ),
    );
  }

  Widget _label(String text, Color color) => Text(text, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: color));
  Widget _input(TextEditingController controller, String hint, IconData icon, Color cardColor, Color borderColor, Color textColor, Color hintColor, {bool isNumber = false}) => Container(decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor.withOpacity(0.6))), child: TextField(controller: controller, keyboardType: isNumber ? TextInputType.number : TextInputType.text, style: GoogleFonts.inter(color: textColor, fontSize: 13), decoration: InputDecoration(hintText: hint, hintStyle: GoogleFonts.inter(color: hintColor, fontSize: 13), prefixIcon: Icon(icon, color: hintColor, size: 16), prefixText: isNumber ? '\$ ' : null, prefixStyle: GoogleFonts.inter(color: textColor, fontSize: 13), border: InputBorder.none, contentPadding: const EdgeInsets.all(12))));

  void _showAddPart(BuildContext context) {
    final isDark = themeNotifier.isDark;
    final numCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(18, 18, 18, MediaQuery.of(ctx).viewInsets.bottom + 20),
        decoration: BoxDecoration(color: isDark ? AppTheme.darkCard : AppTheme.lightCard, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 32, height: 4, decoration: BoxDecoration(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Text('Agregar Parte', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppTheme.darkText : AppTheme.lightText)),
          const SizedBox(height: 14),
          _input(numCtrl, 'Número de parte', Icons.tag_rounded, isDark ? AppTheme.darkBg : AppTheme.lightBg, isDark ? AppTheme.darkBorder : AppTheme.lightBorder, isDark ? AppTheme.darkText : AppTheme.lightText, isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted),
          const SizedBox(height: 8),
          _input(priceCtrl, '0', Icons.attach_money_rounded, isDark ? AppTheme.darkBg : AppTheme.lightBg, isDark ? AppTheme.darkBorder : AppTheme.lightBorder, isDark ? AppTheme.darkText : AppTheme.lightText, isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted, isNumber: true),
          const SizedBox(height: 14),
          GestureDetector(onTap: () { if (numCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) { setState(() => _parts.add(Part(partNumber: numCtrl.text, price: double.tryParse(priceCtrl.text) ?? 0))); Navigator.pop(ctx); } }, child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(10)), child: Center(child: Text('Agregar', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13))))),
        ]),
      ),
    );
  }
}
