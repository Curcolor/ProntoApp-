import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/providers/inventory_provider.dart';
import 'package:prontoapp/data/models/category_model.dart';
import 'package:prontoapp/data/models/product_model.dart';

class AgregarEditarProductoScreen extends StatefulWidget {
  final Product? productToEdit;

  const AgregarEditarProductoScreen({super.key, this.productToEdit});

  @override
  State<AgregarEditarProductoScreen> createState() => _AgregarEditarProductoScreenState();
}

class _AgregarEditarProductoScreenState extends State<AgregarEditarProductoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _minStockController;
  late TextEditingController _prepTimeController;
  late TextEditingController _descriptionController;
  late TextEditingController _aiContextController;

  bool _isAvailable = true;
  bool _aiActive = true;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productToEdit?.name ?? '');
    _priceController = TextEditingController(text: widget.productToEdit?.price.toString() ?? '');
    _stockController = TextEditingController(text: widget.productToEdit?.stock.toString() ?? '');
    _minStockController = TextEditingController(text: widget.productToEdit?.minStock.toString() ?? '');
    _prepTimeController = TextEditingController(text: widget.productToEdit?.prepTimeMinutes.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.productToEdit?.description ?? '');
    _aiContextController = TextEditingController(text: widget.productToEdit?.aiContext ?? '');
    
    _isAvailable = widget.productToEdit?.isAvailable ?? true;
    _aiActive = widget.productToEdit?.aiActive ?? true;
    _selectedCategoryId = widget.productToEdit?.categoryId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _prepTimeController.dispose();
    _descriptionController.dispose();
    _aiContextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    children: [
                      _buildImageUpload(),
                      const SizedBox(height: 24),
                      _buildInputField(
                        label: 'Nombre del producto *',
                        hintText: 'Ej: Croissant de jamón y queso',
                        icon: FontAwesomeIcons.tag,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCategoryDropdown(),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildPriceField(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Stock inicial',
                              hintText: '0',
                              icon: FontAwesomeIcons.boxesStacked,
                              controller: _stockController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildInputField(
                              label: 'Alerta mínima',
                              hintText: 'Ej: 5',
                              icon: FontAwesomeIcons.triangleExclamation,
                              iconColor: AppColors.warningIcon,
                              controller: _minStockController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Tiempo preparación (min)',
                              hintText: 'Ej: 10',
                              icon: FontAwesomeIcons.clock,
                              controller: _prepTimeController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildSwitchField(
                              label: 'Disponibilidad',
                              text: _isAvailable ? 'Activo' : 'Inactivo',
                              value: _isAvailable,
                              onChanged: (val) => setState(() => _isAvailable = val),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextAreaField(
                        label: 'Descripción del producto',
                        hintText: 'Ej: Delicioso croissant hecho de hojaldre...',
                        controller: _descriptionController,
                      ),
                      const SizedBox(height: 24),
                      _buildAiContextSection(),
                      const SizedBox(height: 16),
                      _buildAiActiveToggle(),
                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                ),
              ],
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
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
            widget.productToEdit == null ? 'Nuevo producto' : 'Editar producto',
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

  Widget _buildImageUpload() {
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
            border: Border.all(
              color: AppColors.border,
              width: 2,
            ),
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
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'JPG, PNG · Máx. 5 MB',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required FaIconData icon,
    Color iconColor = AppColors.textMuted,
    TextEditingController? controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textTertiary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              FaIcon(icon, color: iconColor, size: 16),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.textMuted,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
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

  Widget _buildCategoryDropdown() {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        if (_selectedCategoryId == null && provider.categories.isNotEmpty) {
          _selectedCategoryId = provider.categories.first.id;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categoría *',
              style: GoogleFonts.inter(
                color: AppColors.textTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.layerGroup, color: AppColors.textMuted, size: 16),
                  const SizedBox(width: 14),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategoryId,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                        onChanged: (String? newValue) {
                          if (newValue == 'ADD_NEW') {
                            _showAddCategoryModal(context, provider);
                          } else if (newValue != null) {
                            setState(() {
                              _selectedCategoryId = newValue;
                            });
                          }
                        },
                        items: [
                          ...provider.categories.map<DropdownMenuItem<String>>((Category category) {
                            return DropdownMenuItem<String>(
                              value: category.id,
                              child: Text(category.displayTitle),
                            );
                          }),
                          const DropdownMenuItem<String>(
                            value: 'ADD_NEW',
                            child: Row(
                              children: [
                                FaIcon(FontAwesomeIcons.plus, size: 12, color: AppColors.primary),
                                SizedBox(width: 8),
                                Text(
                                  'Crear nueva',
                                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
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
      },
    );
  }

  void _showAddCategoryModal(BuildContext context, InventoryProvider provider) {
    final nameController = TextEditingController();
    final emojiController = TextEditingController(text: '📦');

    showDialog(
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emojiController,
                maxLength: 2,
                decoration: InputDecoration(
                  labelText: 'Emoji (Ej: 🍞)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await provider.addCategory(nameController.text, emojiController.text);
                  // The provider updates listeners, so we just pop and wait for rebuild
                  if (context.mounted) {
                    Navigator.pop(context);
                    // Select the newly added one
                    setState(() {
                      _selectedCategoryId = provider.categories.last.id;
                    });
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Precio *',
          style: GoogleFonts.inter(
            color: AppColors.textTertiary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
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
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.textMuted,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
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

  Widget _buildSwitchField({
    required String label,
    required String text,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textTertiary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.only(left: 15, right: 4),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
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
                activeTrackColor: AppColors.successIcon, // #25D366
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

  Widget _buildTextAreaField({
    required String label,
    required String hintText,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textTertiary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          constraints: const BoxConstraints(minHeight: 90),
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
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

  Widget _buildAiContextSection() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F0FF), Color(0xFFEDE9FE)], // aiGradientStart.withValues(alpha: 0.1), surface
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC4B5FD)), // AppColors.aiGradientStart.withValues(alpha: 0.3)
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
                  child: FaIcon(FontAwesomeIcons.robot, color: AppColors.surface, size: 14),
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
                        color: const Color(0xFF5B21B6), // AppColors.aiGradientEnd
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Ayuda al agente a responder mejor sobre este\nproducto',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF7C3AED), // AppColors.aiGradientStart
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
              controller: _aiContextController,
              maxLines: null,
              decoration: InputDecoration.collapsed(
                hintText: 'Ej: Producto estrella de la tienda. Es apto para personas con intolerancia leve a la lactosa si se pide sin queso...',
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
          _buildAiTip('Menciona alergenos, ingredientes alternativos o restricciones dietéticas.'),
          const SizedBox(height: 6),
          _buildAiTip('Indica horarios especiales o promociones frecuentes.'),
          const SizedBox(height: 6),
          _buildAiTip('Agrega maridajes o productos recomendados junto a este.'),
        ],
      ),
    );
  }

  Widget _buildAiTip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: FaIcon(FontAwesomeIcons.lightbulb, color: AppColors.aiGradientEnd, size: 11),
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

  Widget _buildAiActiveToggle() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          const FaIcon(FontAwesomeIcons.robot, color: AppColors.aiGradientEnd, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IA menciona este producto',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1E293B), // AppColors.textPrimary
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
            value: _aiActive,
            onChanged: (val) => setState(() => _aiActive = val),
            activeColor: AppColors.surface,
            activeTrackColor: AppColors.successIcon, // #25D366
            inactiveThumbColor: AppColors.surface,
            inactiveTrackColor: AppColors.borderLight,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
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
            onTap: () async {
              if (_nameController.text.trim().isEmpty || _priceController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('El nombre y el precio son obligatorios')),
                );
                return;
              }

              final provider = Provider.of<InventoryProvider>(context, listen: false);

              // Evitar fallo si aún no cargaron categorías
              final catId = _selectedCategoryId ?? (provider.categories.isNotEmpty ? provider.categories.first.id : 'unknown');

              final product = Product(
                id: widget.productToEdit?.id ?? 'prod_${DateTime.now().millisecondsSinceEpoch}',
                name: _nameController.text.trim(),
                categoryId: catId,
                price: double.tryParse(_priceController.text) ?? 0.0,
                stock: int.tryParse(_stockController.text) ?? 0,
                minStock: int.tryParse(_minStockController.text) ?? 0,
                prepTimeMinutes: int.tryParse(_prepTimeController.text) ?? 0,
                isAvailable: _isAvailable,
                description: _descriptionController.text.trim(),
                aiContext: _aiContextController.text.trim(),
                aiActive: _aiActive,
                emoji: widget.productToEdit?.emoji ?? '📦', // Se puede expandir luego
              );

              if (widget.productToEdit == null) {
                await provider.addProduct(product);
              } else {
                await provider.updateProduct(product);
              }

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.successIcon, AppColors.primaryDark], // 25D366 -> 128C7E
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
                  const FaIcon(FontAwesomeIcons.floppyDisk, color: AppColors.surface, size: 16),
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

@Preview(name: 'Agregar producto', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget agregarEditarProductoScreenPreview() => const AgregarEditarProductoScreen();

