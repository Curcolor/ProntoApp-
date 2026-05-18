import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/models/category_model.dart';

class ProductFormHeader extends StatelessWidget {
  final bool isEditing;
  final VoidCallback? onBack;

  const ProductFormHeader({super.key, required this.isEditing, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            isEditing ? 'Editar producto' : 'Nuevo producto',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController stockController;
  final TextEditingController minStockController;
  final TextEditingController prepTimeController;
  final TextEditingController descriptionController;
  final TextEditingController aiContextController;
  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onAddCategory;
  final bool isAvailable;
  final ValueChanged<bool> onAvailableChanged;
  final bool aiActive;
  final ValueChanged<bool> onAiActiveChanged;

  const ProductFormFields({
    super.key,
    required this.nameController,
    required this.priceController,
    required this.stockController,
    required this.minStockController,
    required this.prepTimeController,
    required this.descriptionController,
    required this.aiContextController,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
    required this.onAddCategory,
    required this.isAvailable,
    required this.onAvailableChanged,
    required this.aiActive,
    required this.onAiActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      children: [
        const _ProductImageUpload(),
        const SizedBox(height: 24),
        _ProductInputField(
          label: 'Nombre del producto *',
          hintText: 'Ej: Croissant de jamón y queso',
          icon: FontAwesomeIcons.tag,
          controller: nameController,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _ProductCategoryDropdown(
                categories: categories,
                selectedCategoryId: selectedCategoryId,
                onChanged: onCategoryChanged,
                onAddCategory: onAddCategory,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: _ProductPriceField(controller: priceController)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _ProductInputField(
                label: 'Stock inicial',
                hintText: '0',
                icon: FontAwesomeIcons.boxesStacked,
                controller: stockController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ProductInputField(
                label: 'Alerta mínima',
                hintText: 'Ej: 5',
                icon: FontAwesomeIcons.triangleExclamation,
                iconColor: AppColors.warningIcon,
                controller: minStockController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _ProductInputField(
                label: 'Tiempo preparación (min)',
                hintText: 'Ej: 10',
                icon: FontAwesomeIcons.clock,
                controller: prepTimeController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ProductSwitchField(
                label: 'Disponibilidad',
                text: isAvailable ? 'Activo' : 'Inactivo',
                value: isAvailable,
                onChanged: onAvailableChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _ProductTextAreaField(
          label: 'Descripción del producto',
          hintText: 'Ej: Delicioso croissant hecho de hojaldre...',
          controller: descriptionController,
        ),
        const SizedBox(height: 24),
        _ProductAiContextSection(controller: aiContextController),
        const SizedBox(height: 16),
        _ProductAiActiveToggle(value: aiActive, onChanged: onAiActiveChanged),
        const SizedBox(height: 100),
      ],
    );
  }
}

class ProductSaveBar extends StatelessWidget {
  final VoidCallback? onSave;

  const ProductSaveBar({super.key, this.onSave});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.surface,
              AppColors.surface.withValues(alpha: 0.8),
              AppColors.surface.withValues(alpha: 0.0),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: onSave,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.successIcon, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.successIcon.withValues(alpha: 0.35),
                    offset: const Offset(0, 4),
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.floppyDisk,
                    color: AppColors.surface,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Guardar producto',
                    style: GoogleFonts.inter(
                      color: AppColors.surface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showProductCategoryDialog({
  required BuildContext context,
  required Future<void> Function(String name, String emoji) onSave,
}) {
  final nameController = TextEditingController();
  final emojiController = TextEditingController(text: '📦');

  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Nueva categoría',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emojiController,
              maxLength: 2,
              decoration: InputDecoration(
                labelText: 'Emoji (Ej: 🍞)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              if (nameController.text.isEmpty) return;
              await onSave(nameController.text, emojiController.text);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    },
  );
}

class _ProductImageUpload extends StatelessWidget {
  const _ProductImageUpload();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto del producto',
          style: GoogleFonts.inter(
            color: AppColors.textTertiary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 138,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.camera,
                color: AppColors.textMuted,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                'Agregar foto',
                style: GoogleFonts.inter(
                  color: AppColors.textTertiary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'JPG, PNG · Máx. 5 MB',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final FaIconData icon;
  final Color iconColor;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const _ProductInputField({
    required this.label,
    required this.hintText,
    required this.icon,
    this.iconColor = AppColors.textMuted,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProductFieldLabel(label),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: _fieldDecoration(),
          child: Row(
            children: [
              FaIcon(icon, color: iconColor, size: 16),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: _inputDecoration(hintText),
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductCategoryDropdown extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onChanged;
  final VoidCallback onAddCategory;

  const _ProductCategoryDropdown({
    required this.categories,
    required this.selectedCategoryId,
    required this.onChanged,
    required this.onAddCategory,
  });

  @override
  Widget build(BuildContext context) {
    final value = categories.any((c) => c.id == selectedCategoryId)
        ? selectedCategoryId
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ProductFieldLabel('Categoría *'),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: _fieldDecoration(),
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.layerGroup,
                color: AppColors.textMuted,
                size: 16,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textMuted,
                    ),
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                    onChanged: (newValue) {
                      if (newValue == 'ADD_NEW') {
                        onAddCategory();
                      } else {
                        onChanged(newValue);
                      }
                    },
                    items: [
                      ...categories.map(
                        (category) => DropdownMenuItem<String>(
                          value: category.id,
                          child: Text(category.displayTitle),
                        ),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'ADD_NEW',
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.plus,
                              size: 12,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Crear nueva',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductPriceField extends StatelessWidget {
  final TextEditingController controller;

  const _ProductPriceField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ProductFieldLabel('Precio *'),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: _fieldDecoration(),
          child: Row(
            children: [
              Text(
                '\$',
                style: GoogleFonts.inter(
                  color: AppColors.textTertiary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('0'),
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductSwitchField extends StatelessWidget {
  final String label;
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ProductSwitchField({
    required this.label,
    required this.text,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProductFieldLabel(label),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.only(left: 15, right: 4),
          decoration: _fieldDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.surface,
                activeTrackColor: AppColors.successIcon,
                inactiveThumbColor: AppColors.surface,
                inactiveTrackColor: AppColors.borderLight,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductTextAreaField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;

  const _ProductTextAreaField({
    required this.label,
    required this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProductFieldLabel(label),
        const SizedBox(height: 6),
        Container(
          constraints: const BoxConstraints(minHeight: 90),
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
          decoration: _fieldDecoration(),
          child: TextField(
            controller: controller,
            maxLines: null,
            decoration: InputDecoration.collapsed(
              hintText: hintText,
              hintStyle: GoogleFonts.inter(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductAiContextSection extends StatelessWidget {
  final TextEditingController controller;

  const _ProductAiContextSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F0FF), Color(0xFFEDE9FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC4B5FD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.aiGradientEnd,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.robot,
                    color: AppColors.surface,
                    size: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contexto para la IA',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF5B21B6),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Ayuda al agente a responder mejor sobre este\nproducto',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF7C3AED),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 100,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC4B5FD)),
            ),
            child: TextField(
              controller: controller,
              maxLines: null,
              decoration: InputDecoration.collapsed(
                hintText:
                    'Ej: Producto estrella de la tienda. Es apto para personas con intolerancia leve a la lactosa si se pide sin queso...',
                hintStyle: GoogleFonts.inter(
                  color: AppColors.textTertiary,
                  fontSize: 13,
                ),
              ),
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const _ProductAiTip(
            'Menciona alergenos, ingredientes alternativos o restricciones dietéticas.',
          ),
          const SizedBox(height: 6),
          const _ProductAiTip(
            'Indica horarios especiales o promociones frecuentes.',
          ),
          const SizedBox(height: 6),
          const _ProductAiTip(
            'Agrega maridajes o productos recomendados junto a este.',
          ),
        ],
      ),
    );
  }
}

class _ProductAiTip extends StatelessWidget {
  final String text;

  const _ProductAiTip(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: FaIcon(
            FontAwesomeIcons.lightbulb,
            color: AppColors.aiGradientEnd,
            size: 11,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: AppColors.aiGradientStart,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductAiActiveToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ProductAiActiveToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          const FaIcon(
            FontAwesomeIcons.robot,
            color: AppColors.aiGradientEnd,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IA menciona este producto',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'La IA puede recomendarlo activamente en\nconversaciones',
                  style: GoogleFonts.inter(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.surface,
            activeTrackColor: AppColors.successIcon,
            inactiveThumbColor: AppColors.surface,
            inactiveTrackColor: AppColors.borderLight,
          ),
        ],
      ),
    );
  }
}

class _ProductFieldLabel extends StatelessWidget {
  final String text;

  const _ProductFieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: AppColors.textTertiary,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

BoxDecoration _fieldDecoration() {
  return BoxDecoration(
    color: AppColors.background,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.borderLight),
  );
}

InputDecoration _inputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: GoogleFonts.inter(
      color: AppColors.textMuted,
      fontSize: 15,
      fontWeight: FontWeight.w400,
    ),
    border: InputBorder.none,
    contentPadding: EdgeInsets.zero,
    isDense: true,
  );
}
