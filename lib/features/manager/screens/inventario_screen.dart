import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/providers/inventory_provider.dart';
import 'package:prontoapp/data/models/product_model.dart';
import 'package:prontoapp/data/models/category_model.dart';
import '../widgets/ajustar_stock_modal.dart';
import 'agregar_editar_producto_screen.dart';

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
              ...provider.categories
            ];

            List<Product> displayedProducts = provider.products;
            if (_selectedCategoryIndex > 0 && _selectedCategoryIndex < categories.length) {
              final selectedCat = categories[_selectedCategoryIndex];
              displayedProducts = provider.products.where((p) => p.categoryId == selectedCat.id).toList();
            }

            int lowStockCount = provider.products.where((p) => p.stock > 0 && p.stock <= p.minStock).length;
            int outOfStockCount = provider.products.where((p) => p.stock == 0).length;

            return Column(
              children: [
                _buildHeader(context),
                _buildStats(provider.products.length, lowStockCount, outOfStockCount),
                _buildSearchBar(),
                _buildCategories(categories),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: displayedProducts.length + 1, // +1 for the stock alert
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: lowStockCount > 0 ? _buildStockAlert(lowStockCount) : const SizedBox.shrink(),
                        );
                      }
                      
                      final product = displayedProducts[index - 1];
                      final category = provider.categories.firstWhere(
                        (c) => c.id == product.categoryId, 
                        orElse: () => Category(id: '', name: 'Desconocido', emoji: ''),
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildProductCard(
                          context: context,
                          product: product,
                          categoryName: category.displayTitle,
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Panadería El Trigo Dorado',
                style: GoogleFonts.inter(
                  color: AppColors.textTertiary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Inventario',
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AgregarEditarProductoScreen(),
                ),
              );
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  color: AppColors.surface,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(int total, int lowStock, int outOfStock) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(total.toString(), 'Productos', AppColors.textPrimary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(lowStock.toString(), 'Stock bajo', const Color(0xFFF59E0B)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(outOfStock.toString(), 'Agotado', const Color(0xFFEF4444)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 1),
            blurRadius: 1.5,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              color: valueColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.textTertiary,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: AppColors.textMuted,
              size: 14,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar producto...',
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.textTertiary,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.sliders,
                  color: AppColors.surface,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(List<Category> categories) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategoryIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  categories[index].displayTitle,
                  style: GoogleFonts.inter(
                    color: isSelected
                        ? AppColors.surface
                        : AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStockAlert(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)), // FDE68A
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const FaIcon(
            FontAwesomeIcons.triangleExclamation,
            color: AppColors.warningIcon,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  color: AppColors.warningDarker,
                  fontSize: 11,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: '$count productos ',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: 'con stock bajo. Revisa y actualiza tu inventario para que la IA no ofrezca productos agotados.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required BuildContext context,
    required Product product,
    required String categoryName,
  }) {
    bool isOutOfStock = product.stock == 0;
    bool isStockLow = product.stock > 0 && product.stock <= product.minStock;
    
    Color borderColor = AppColors.borderLight;
    if (isStockLow) borderColor = const Color(0xFFFDE68A); // warning border
    if (isOutOfStock) borderColor = const Color(0xFFFCA5A5); // danger border

    String statusBadgeText = 'Disponible';
    Color statusBadgeColor = AppColors.successText;
    Color statusBadgeBg = AppColors.successBg;
    Color stockFillColor = AppColors.primary; // diseño: barra de stock disponible #25D366

    if (isOutOfStock) {
      statusBadgeText = 'Agotado';
      statusBadgeColor = AppColors.dangerText;
      statusBadgeBg = AppColors.dangerBg;
      stockFillColor = AppColors.border;
    } else if (isStockLow) {
      statusBadgeText = 'Stock bajo';
      statusBadgeColor = AppColors.warningText;
      statusBadgeBg = AppColors.warningBg;
      stockFillColor = AppColors.warningIcon;
    }

    double stockPercent = isOutOfStock ? 0.0 : (product.stock / 50.0).clamp(0.0, 1.0); // Arbitrary max for visualization
    String stockLabel = 'Stock: ${product.stock} uds';
    String aiStatusText = product.aiActive ? 'IA activa' : 'IA pausada';
    FaIconData aiStatusIcon = FontAwesomeIcons.robot;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isOutOfStock ? AppColors.surface.withValues(alpha: 0.7) : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 1),
            blurRadius: 1.5,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.borderLight.withValues(alpha: isOutOfStock ? 0.5 : 1.0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                product.emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  categoryName,
                  style: GoogleFonts.inter(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toInt()}',
                      style: GoogleFonts.inter(
                        color: AppColors.primaryDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusBadgeBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          if (isStockLow) ...[
                            FaIcon(
                              FontAwesomeIcons.triangleExclamation,
                              color: statusBadgeColor,
                              size: 11,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            statusBadgeText,
                            style: GoogleFonts.inter(
                              color: statusBadgeColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: stockPercent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: stockFillColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          stockLabel,
                          style: GoogleFonts.inter(
                            color: AppColors.textTertiary,
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isOutOfStock ? AppColors.borderLight : AppColors.aiBg,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              FaIcon(
                                aiStatusIcon,
                                color: isOutOfStock ? AppColors.textTertiary : AppColors.aiText,
                                size: 9,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                aiStatusText,
                                style: GoogleFonts.inter(
                                  color: isOutOfStock ? AppColors.textTertiary : AppColors.aiText,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgregarEditarProductoScreen(productToEdit: product),
                    ),
                  );
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.pen,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  AjustarStockModal.show(context, product);
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.ellipsisVertical,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

@Preview(name: 'Inventario', group: 'Manager', wrapper: previewWrapper, theme: previewTheme, size: kPreviewPhone)
Widget inventarioScreenPreview() => const InventarioScreen();

