# `flutter analyze` snapshot — Post Schema V2

**Fecha:** 2026-05-16
**Flutter:** 3.41.7 stable · Dart 3.11.5
**Comando:** `flutter pub get && flutter analyze --no-pub`
**Resultado:** 137 issues — **0 errors · 7 warnings · 130 info**

---

## Resumen por severidad

| Severidad | Cuenta | Diagnóstico |
|---|---:|---|
| `error` | 0 | App compila — providers actuales aún usan HTTP localhost, no consumen el SDK Data Connect regenerado, por eso no aparece breakage. El daño emerge cuando se migre Fase 6. |
| `warning` | 7 | Imports muertos + duplicate import en SDK + local var sin uso. Limpieza trivial. |
| `info` | 130 | Estilo. Ver desglose abajo. |

---

## Warnings (7)

| Archivo | Línea | Mensaje |
|---|---:|---|
| `lib/features/auth/screens/landing_page.dart` | 5 | Unused import `dart:math` |
| `lib/features/auth/screens/landing_page.dart` | 17 | Local var `size` sin uso |
| `lib/features/auth/screens/processing_screen.dart` | 4 | Unused import `package:prontoapp/main.dart` |
| `lib/features/kitchen/screens/perfil_cocinero_screen.dart` | 6 | Unused import `login_screen.dart` |
| `lib/features/manager/widgets/editar_perfil_modals.dart` | 143 | Param opcional `obscureText` nunca usado |
| `lib/generated/prontoapp_dataconnect/prontoapp.dart` | 5 | **Duplicate import** (regen Data Connect) |
| `test/widget_test.dart` | 8 | Unused import `flutter/material.dart` |

---

## Info — top categorías (130)

| Categoría | Cuenta | Decisión |
|---|---:|---|
| `constant_identifier_names` (enums SCREAMING_CASE en SDK gen) | 51 | **Ignorar** — generado, mantener fidelidad nomenclatura GraphQL enums. Configurar `analysis_options.yaml` excludes para `lib/generated/**`. |
| `prefer_const_constructors_in_immutables` (SDK gen) | 22 | **Ignorar** — generado. Excluir analizador. |
| `deprecated_member_use` (`withOpacity`, `activeColor`, FontAwesome v8 renames) | 21 | **Backlog F7** — migración a `withValues()` y nombres nuevos. |
| `non_constant_identifier_names` (`detallePedidos_on_pedido` SDK gen) | 3 | **Ignorar** — generado, refleja join names del SDK. |
| `prefer_final_fields` | 3 | Limpieza Fase 7. |
| `unnecessary_underscores` | 4 | Limpieza Fase 7. |
| `unnecessary_import` (dart:ui redundante) | 1 | Limpieza Fase 7. |
| `use_build_context_synchronously` | 1 | **Revisar Fase 6/7** — bug potencial async gap. |
| `unnecessary_library_name` | 1 | Limpieza Fase 7. |

---

## Acciones inmediatas Fase 1 (no se hicieron, dejadas para Fase 6/7)

1. Añadir `analysis_options.yaml` exclude para `lib/generated/**` → silenciar 76 info de SDK gen.
2. Limpiar 6 warnings de imports muertos.
3. Investigar `use_build_context_synchronously` en `agregar_editar_producto_screen.dart:846` — posible bug real.

## Riesgos identificados (no detectados por `analyze`, requieren migración Fase 6)

El analizador **no detecta** los siguientes problemas porque providers aún no tocan el SDK regenerado:

- `lib/data/providers/order_provider.dart`: campos esperados del schema V2 (ej. `estadoOperacion`, `direccionSnapshot`) no resueltos cuando se migre.
- `auth_service.dart`: usuarios hardcoded + sin Firebase Auth real.
- `lib/main.dart`: `X-Secret` y `localhost:5050` hardcoded.
- 19 god widgets >400 LOC sin tests.
- 812 color literals fuera de `AppColors`.

Estos gaps están cubiertos por el plan Fase 6.

## Comando reproducible

```powershell
cd C:\WorkSpace-Vs-Code\ProntoApp-
flutter pub get
flutter analyze --no-pub
```

## Hashes y entorno

- Flutter framework: `cc0734ac71` (2026-04-15).
- Schema fuente: `ProntoApp--Back/dataconnect/schema/schema.gql` @ commit `8c2d31c`.
- SDK Dart regen committed: `748cb63`.
