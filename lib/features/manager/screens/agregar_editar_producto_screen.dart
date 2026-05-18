import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/models/product_model.dart';
import 'package:prontoapp/data/providers/inventory_provider.dart';
import 'package:prontoapp/ui/components/manager/product_form_components.dart';

class AgregarEditarProductoScreen extends StatefulWidget {
  final Product? productToEdit;

  const AgregarEditarProductoScreen({super.key, this.productToEdit});

  @override
  State<AgregarEditarProductoScreen> createState() =>
      _AgregarEditarProductoScreenState();
}

class _AgregarEditarProductoScreenState
    extends State<AgregarEditarProductoScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _minStockController;
  late final TextEditingController _prepTimeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _aiContextController;

  bool _isAvailable = true;
  bool _aiActive = true;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    final product = widget.productToEdit;
    _nameController = TextEditingController(text: product?.name ?? '');
    _priceController = TextEditingController(
      text: product?.price.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: product?.stock.toString() ?? '',
    );
    _minStockController = TextEditingController(
      text: product?.minStock.toString() ?? '',
    );
    _prepTimeController = TextEditingController(
      text: product?.prepTimeMinutes.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    _aiContextController = TextEditingController(
      text: product?.aiContext ?? '',
    );

    _isAvailable = product?.isAvailable ?? true;
    _aiActive = product?.aiActive ?? true;
    _selectedCategoryId = product?.categoryId;
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
        child: Consumer<InventoryProvider>(
          builder: (context, provider, _) {
            if (_selectedCategoryId == null && provider.categories.isNotEmpty) {
              _selectedCategoryId = provider.categories.first.id;
            }

            return Stack(
              children: [
                Column(
                  children: [
                    ProductFormHeader(
                      isEditing: widget.productToEdit != null,
                      onBack: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: ProductFormFields(
                        nameController: _nameController,
                        priceController: _priceController,
                        stockController: _stockController,
                        minStockController: _minStockController,
                        prepTimeController: _prepTimeController,
                        descriptionController: _descriptionController,
                        aiContextController: _aiContextController,
                        categories: provider.categories,
                        selectedCategoryId: _selectedCategoryId,
                        onCategoryChanged: (value) =>
                            setState(() => _selectedCategoryId = value),
                        onAddCategory: () =>
                            _showAddCategoryModal(context, provider),
                        isAvailable: _isAvailable,
                        onAvailableChanged: (value) =>
                            setState(() => _isAvailable = value),
                        aiActive: _aiActive,
                        onAiActiveChanged: (value) =>
                            setState(() => _aiActive = value),
                      ),
                    ),
                  ],
                ),
                ProductSaveBar(onSave: () => _saveProduct(context, provider)),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showAddCategoryModal(
    BuildContext context,
    InventoryProvider provider,
  ) {
    return showProductCategoryDialog(
      context: context,
      onSave: (name, emoji) async {
        await provider.addCategory(name, emoji);
        if (!mounted || provider.categories.isEmpty) return;
        setState(() => _selectedCategoryId = provider.categories.last.id);
      },
    );
  }

  Future<void> _saveProduct(
    BuildContext context,
    InventoryProvider provider,
  ) async {
    if (_nameController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre y el precio son obligatorios')),
      );
      return;
    }

    final catId =
        _selectedCategoryId ??
        (provider.categories.isNotEmpty
            ? provider.categories.first.id
            : 'unknown');

    final product = Product(
      id:
          widget.productToEdit?.id ??
          'prod_${DateTime.now().millisecondsSinceEpoch}',
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
      emoji: widget.productToEdit?.emoji ?? '📦',
    );

    if (widget.productToEdit == null) {
      await provider.addProduct(product);
    } else {
      await provider.updateProduct(product);
    }

    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
