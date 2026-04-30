import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/core/constants/app_colors.dart';

class AjustarStockModal extends StatefulWidget {
  const AjustarStockModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AjustarStockModal(),
    );
  }

  @override
  State<AjustarStockModal> createState() => _AjustarStockModalState();
}

class _AjustarStockModalState extends State<AjustarStockModal> {
  int _currentStock = 25;
  String _selectedReason = 'Nuevo lote';

  void _updateStock(int amount) {
    setState(() {
      if (amount == 0) {
        _currentStock = 0; // Agotar
      } else {
        _currentStock += amount;
      }
      if (_currentStock < 0) _currentStock = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 24),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Text('☕', style: GoogleFonts.inter(fontSize: 32)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Café latte especial',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.warningBg,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FaIcon(FontAwesomeIcons.triangleExclamation, size: 11, color: AppColors.warningDarker),
                                const SizedBox(width: 4),
                                Text(
                                  'Stock bajo · 5 uds',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.warningDarker,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Actualizar cantidad
                Text(
                  'Actualizar cantidad en inventario',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Counter
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.borderLight),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => _updateStock(-1),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                        child: Container(
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          child: Text(
                            '−',
                            style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '$_currentStock',
                            style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _updateStock(1),
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
                        child: Container(
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          child: Text(
                            '+',
                            style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Quick add buttons
                Row(
                  children: [
                    _buildQuickActionBtn('+10', () => _updateStock(10), isDanger: false),
                    const SizedBox(width: 8),
                    _buildQuickActionBtn('+25', () => _updateStock(25), isDanger: false),
                    const SizedBox(width: 8),
                    _buildQuickActionBtn('+50', () => _updateStock(50), isDanger: false),
                    const SizedBox(width: 8),
                    _buildQuickActionBtn('Agotar', () => _updateStock(0), isDanger: true),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Motivo
                Text(
                  'Motivo del ajuste',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildReasonChip('🚚 Nuevo lote', 'Nuevo lote'),
                    _buildReasonChip('🗑️ Merma', 'Merma'),
                    _buildReasonChip('✏️ Corrección', 'Corrección'),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Actions
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.borderLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            'Cancelar',
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [AppColors.successIcon, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: AppColors.successIcon.withValues(alpha: 0.35), offset: const Offset(0, 4), blurRadius: 7)],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(FontAwesomeIcons.check, size: 13, color: AppColors.surface),
                              const SizedBox(width: 8),
                              Text(
                                'Actualizar stock',
                                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.surface),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionBtn(String label, VoidCallback onTap, {required bool isDanger}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 34,
          decoration: BoxDecoration(
            color: isDanger ? AppColors.dangerBg : AppColors.borderLight,
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isDanger ? AppColors.dangerIcon : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReasonChip(String label, String reasonValue) {
    bool isSelected = _selectedReason == reasonValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReason = reasonValue;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.successBg : AppColors.borderLight,
          border: Border.all(color: isSelected ? const Color(0xFF86EFAC) : AppColors.border),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF166534) : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
