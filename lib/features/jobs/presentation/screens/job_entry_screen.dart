import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/models/repair_job.dart';
import '../../data/job_service.dart';
import '../../../auth/data/auth_service.dart';
import '../../../../core/theme/app_theme.dart';

class JobEntryScreen extends ConsumerStatefulWidget {
  const JobEntryScreen({super.key});

  @override
  ConsumerState<JobEntryScreen> createState() => _JobEntryScreenState();
}

class _JobEntryScreenState extends ConsumerState<JobEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerController = TextEditingController();
  final _totalPriceController = TextEditingController();
  final _partsCostController = TextEditingController();
  final _diagnosticFeeController = TextEditingController(text: '70.0');
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: AppTheme.darkTheme.copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.neonCyan,
              onPrimary: AppTheme.charcoal,
              surface: AppTheme.slate,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveJob() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final user = ref.read(authServiceProvider).currentUser;
      if (user == null) throw Exception('No session found');

      final job = RepairJob(
        technicianId: user.uid,
        customerName: _customerController.text,
        serviceDate: _selectedDate,
        totalPrice: double.parse(_totalPriceController.text),
        partsCost: double.parse(_partsCostController.text),
        diagnosticFee: double.parse(_diagnosticFeeController.text),
      );

      await ref.read(jobServiceProvider).addJob(job);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NUEVO TRABAJO')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Datos del Cliente',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.neonCyan),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _customerController,
                decoration: const InputDecoration(hintText: 'Nombre del Cliente'),
                validator: (v) => v?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              _DatePickerTile(
                label: 'Fecha del Servicio',
                value: DateFormat('dd/MM/yyyy').format(_selectedDate),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 32),
              const Text(
                'Finanzas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.neonCyan),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _totalPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Precio Total Cobrado', prefixText: '$ '),
                validator: (v) => v?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _partsCostController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Costo de Repuestos', prefixText: '$ '),
                validator: (v) => v?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diagnosticFeeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Diagnóstico (Editable)', prefixText: '$ '),
                validator: (v) => v?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.neonCyan,
                    foregroundColor: AppTheme.charcoal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isSaving 
                    ? const CircularProgressIndicator(color: AppTheme.charcoal)
                    : const Text('GUARDAR TRABAJO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DatePickerTile({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.slate,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white54)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.neonCyan)),
          ],
        ),
      ),
    );
  }
}
