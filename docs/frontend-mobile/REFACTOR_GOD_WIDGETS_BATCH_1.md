# Refactor god widgets batch 1

| archivo | LOC antes | LOC después | widgets extraídos |
|---|---:|---:|---|
| `lib/features/manager/widgets/editar_perfil_modals.dart` | 1066 | 105 | `EditarPerfilHeaderSheet`, `EditarPerfilForm`, `WhatsappBusinessSection`, `CambioPasswordSection`, `EditarNegocioSection` |
| `lib/features/auth/screens/login_screen.dart` | 393 | 147 | `LoginBackButton`, `LoginHeroHeader`, `LoginAuthForm`, `LoginSocialButtons`, `LoginRegisterLink` |
| `lib/features/manager/screens/dashboard_screen.dart` | 646 | 137 | `DashboardHeader`, `DashboardMetricsGrid`, `DashboardOrderTabs`, `DashboardEmptyState`, `DashboardOrderCard` |
| `lib/features/manager/screens/inventario_screen.dart` | 633 | 140 | `InventoryHeader`, `InventoryStats`, `InventorySearchBar`, `InventoryCategoryTabs`, `InventoryStockAlert`, `InventoryProductCard` |
| `lib/features/kitchen/screens/preparacion_screen.dart` | 625 | 36 | `PreparacionEmptyState`, `PedidoPreparacionCard` |
