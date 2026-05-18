import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/models/category_model.dart';
import 'package:prontoapp/data/models/product_model.dart';

class InventoryHeader extends StatelessWidget {
  final String businessName;
  final VoidCallback? onBack;
  final VoidCallback? onAdd;

  const InventoryHeader({
    super.key,
    this.businessName = 'Mi negocio',
    this.onBack,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Semantics(
            label: 'Volver',
            button: true,
            child: GestureDetector(
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
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                businessName,
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
          Semantics(
            label: 'Agregar producto',
            button: true,
            child: GestureDetector(
              onTap: onAdd,
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
          ),
        ],
      ),
    );
  }
}

class InventoryStats extends StatelessWidget {
  final int total;
  final int lowStock;
  final int outOfStock;

  const InventoryStats({
    super.key,
    this.total = 0,
    this.lowStock = 0,
    this.outOfStock = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _InventoryStatCard(
              value: total.toString(),
              label: 'Productos',
              valueColor: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _InventoryStatCard(
              value: lowStock.toString(),
              label: 'Stock bajo',
              valueColor: AppColors.warningIcon,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _InventoryStatCard(
              value: outOfStock.toString(),
              label: 'Agotado',
              valueColor: AppColors.dangerIcon,
            ),
          ),
        ],
      ),
    );
  }
}

class InventorySearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const InventorySearchBar({super.key, this.onChanged, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
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
              child: Semantics(
                label: 'Buscar producto',
                textField: true,
                child: TextField(
                  onChanged: onChanged,
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
            ),
            Semantics(
              label: 'Filtrar inventario',
              button: onFilterTap != null,
              child: GestureDetector(
                onTap: onFilterTap,
                child: Container(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InventoryCategoryTabs extends StatelessWidget {
  final List<Category>? categories;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  const InventoryCategoryTabs({
    super.key,
    this.categories,
    this.selectedIndex = 0,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = categories ?? [Category(id: 'all', name: 'Todos', emoji: '')];
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return Semantics(
            label: 'Categoría ${tabs[index].displayTitle}',
            button: true,
            selected: isSelected,
            child: GestureDetector(
              onTap: () => onSelected?.call(index),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    tabs[index].displayTitle,
                    style: GoogleFonts.inter(
                      color:
                          isSelected ? AppColors.surface : AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class InventoryStockAlert extends StatelessWidget {
  final int count;

  const InventoryStockAlert({super.key, this.count = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warningIcon.withValues(alpha: 0.35)),
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
                    text:
                        'con stock bajo. Revisa y actualiza tu inventario para que la IA no ofrezca productos agotados.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InventoryProductCard extends StatelessWidget {
  final Product? product;
  final String categoryName;
  final VoidCallback? onEdit;
  final VoidCallback? onAdjustStock;

  const InventoryProductCard({
    super.key,
    this.product,
    this.categoryName = 'General',
    this.onEdit,
    this.onAdjustStock,
  });

  @override
  Widget build(BuildContext context) {
    final item = product ?? _sampleProduct();
    final isOutOfStock = item.stock == 0;
    final isStockLow = item.stock > 0 && item.stock <= item.minStock;
    final borderColor = isOutOfStock
        ? AppColors.dangerIcon.withValues(alpha: 0.45)
        : isStockLow
            ? AppColors.warningIcon.withValues(alpha: 0.45)
            : AppColors.borderLight;
    final status = _InventoryStatus.fromProduct(item);
    final stockPercent = isOutOfStock ? 0.0 : (item.stock / 50.0).clamp(0.0, 1.0);
    final aiStatusText = item.aiActive ? 'IA activa' : 'IA pausada';

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isOutOfStock
            ? AppColors.surface.withValues(alpha: 0.7)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.08),
            offset: const Offset(0, 1),
            blurRadius: 1.5,
          ),
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
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
              color: AppColors.borderLight.withValues(
                alpha: isOutOfStock ? 0.5 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(item.emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
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
                      '\$${item.price.toInt()}',
                      style: GoogleFonts.inter(
                        color: AppColors.primaryDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: status.background,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          if (isStockLow) ...[
                            FaIcon(
                              FontAwesomeIcons.triangleExclamation,
                              color: status.foreground,
                              size: 11,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            status.label,
                            style: GoogleFonts.inter(
                              color: status.foreground,
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
                        color: status.stockFill,
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
                      'Stock: ${item.stock} uds',
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
                            FontAwesomeIcons.robot,
                            color: isOutOfStock
                                ? AppColors.textTertiary
                                : AppColors.aiText,
                            size: 9,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            aiStatusText,
                            style: GoogleFonts.inter(
                              color: isOutOfStock
                                  ? AppColors.textTertiary
                                  : AppColors.aiText,
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
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              _InventoryIconAction(
                label: 'Editar producto ${item.name}',
                icon: FontAwesomeIcons.pen,
                onTap: onEdit,
              ),
              const SizedBox(height: 6),
              _InventoryIconAction(
                label: 'Ajustar stock de ${item.name}',
                icon: FontAwesomeIcons.ellipsisVertical,
                onTap: onAdjustStock,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InventoryStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _InventoryStatCard({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.08),
            offset: const Offset(0, 1),
            blurRadius: 1.5,
          ),
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
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
}

class _InventoryIconAction extends StatelessWidget {
  final String label;
  final FaIconData icon;
  final VoidCallback? onTap;

  const _InventoryIconAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.borderLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: FaIcon(
              icon,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _InventoryStatus {
  final String label;
  final Color foreground;
  final Color background;
  final Color stockFill;

  const _InventoryStatus({
    required this.label,
    required this.foreground,
    required this.background,
    required this.stockFill,
  });

  factory _InventoryStatus.fromProduct(Product product) {
    if (product.stock == 0) {
      return const _InventoryStatus(
        label: 'Agotado',
        foreground: AppColors.dangerText,
        background: AppColors.dangerBg,
        stockFill: AppColors.border,
      );
    }
    if (product.stock <= product.minStock) {
      return const _InventoryStatus(
        label: 'Stock bajo',
        foreground: AppColors.warningText,
        background: AppColors.warningBg,
        stockFill: AppColors.warningIcon,
      );
    }
    return const _InventoryStatus(
      label: 'Disponible',
      foreground: AppColors.successText,
      background: AppColors.successBg,
      stockFill: AppColors.successIcon,
    );
  }
}

Product _sampleProduct() {
  return Product(
    id: 'demo',
    name: 'Producto demo',
    categoryId: 'all',
    price: 12000,
    stock: 12,
    minStock: 4,
    prepTimeMinutes: 10,
    isAvailable: true,
    description: '',
    aiContext: '',
    aiActive: true,
    emoji: '📦',
  );
}
