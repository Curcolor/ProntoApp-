import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/models/category_model.dart';
import 'package:prontoapp/data/models/product_model.dart';
import 'package:prontoapp/data/providers/inventory_provider.dart';
import 'package:prontoapp/data/services/perfil_usuario_admin_service.dart';
import 'package:prontoapp/features/manager/screens/agregar_editar_producto_screen.dart';
import 'package:prontoapp/features/manager/widgets/ajustar_stock_modal.dart';
import 'package:prontoapp/ui/components/manager/inventory_components.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<InventoryProvider>(
          builder: (context, provider, child) {
            final categories = [
              Category(id: 'all', name: 'Todos', emoji: ''),
              ...provider.categories,
            ];
            final displayedProducts =
                _filterProducts(provider, categories);
            final lowStockCount = provider.products
                .where((p) => p.stock > 0 && p.stock <= p.minStock)
                .length;
            final outOfStockCount =
                provider.products.where((p) => p.stock == 0).length;
            final businessName =
                context.watch<PerfilUsuarioAdminService>().perfil?.negocioNombre ??
                    'Mi negocio';

            return Column(
              children: [
                InventoryHeader(
                  businessName: businessName,
                  onBack: () => Navigator.pop(context),
                  onAdd: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AgregarEditarProductoScreen(),
                      ),
                    );
                  },
                ),
                InventoryStats(
                  total: provider.products.length,
                  lowStock: lowStockCount,
                  outOfStock: outOfStockCount,
                ),
                const InventorySearchBar(),
                InventoryCategoryTabs(
                  categories: categories,
                  selectedIndex: _selectedCategoryIndex,
                  onSelected: (index) =>
                      setState(() => _selectedCategoryIndex = index),
                ),
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: displayedProducts.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: lowStockCount > 0
                              ? InventoryStockAlert(count: lowStockCount)
                              : const SizedBox.shrink(),
                        );
                      }

                      final product = displayedProducts[index - 1];
                      final category = provider.categories.firstWhere(
                        (c) => c.id == product.categoryId,
                        orElse: () => Category(
                          id: '',
                          name: 'Desconocido',
                          emoji: '',
                        ),
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InventoryProductCard(
                          product: product,
                          categoryName: category.displayTitle,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AgregarEditarProductoScreen(
                                  productToEdit: product,
                                ),
                              ),
                            );
                          },
                          onAdjustStock: () {
                            AjustarStockModal.show(context, product);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Product> _filterProducts(
    InventoryProvider provider,
    List<Category> categories,
  ) {
    if (_selectedCategoryIndex > 0 &&
        _selectedCategoryIndex < categories.length) {
      final selectedCat = categories[_selectedCategoryIndex];
      return provider.products
          .where((p) => p.categoryId == selectedCat.id)
          .toList();
    }
    return provider.products;
  }
}
