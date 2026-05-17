# Auditoría detallada — Pantallas Flutter ProntoApp

**Fecha:** 2026-05-16
**Repo:** `C:/WorkSpace-Vs-Code/ProntoApp-`
**Branch:** `main` @ `b08b5b9` (backend tip).
**Comando base reproducible:** ver sección final.
**Pantallas auditadas:** 29.
**LOC totales `lib/features/**/screens/`:** 12 616.
**God widgets >400 LOC:** **17** (Junior estimó 19 — diferencia: 2 archivos rozan límite pero no superan 400).
**Color literals globales en `lib/`:** **847** (Junior estimó 812; diferencia por archivos `lib/data/` y `lib/ui/` no contados antes).

---

## Resumen ejecutivo — top 10 hallazgos por prioridad

| # | Hallazgo | Prio |
|---|---|:---:|
| 1 | **🚨 RIESGO SEGURIDAD CRÍTICO** — Secret API `83c58120a0a140ade0282b37ff64731f3fdd3f7dc306be3151ec62e967b43f43` hardcoded en `lib/main.dart:41` y `:50`. Visible en APK reverse-engineered. Rotar y borrar HOY. | P0 |
| 2 | Auth fake con plaintext passwords (`password123`) hardcoded en `lib/data/services/auth_service.dart` líneas 30-50. Usuarios "Carlos Gerente / Ana Cocinera / Luis Repartidor" inventados. Reemplazar por Firebase Auth real (ADR 0001). | P0 |
| 3 | `http://localhost:5050` en 3 sitios (main.dart x2, inventory_provider.dart:29, order_provider.dart:38) — no funcionará en device físico ni producción. | P0 |
| 4 | Header `X-Secret` hardcoded enviado en cada request (order_provider.dart:278). Mismo secret leaked del punto 1. | P0 |
| 5 | 17 god widgets >400 LOC, **el peor `_AgregarEditarProductoScreenState` con 868 LOC** — imposible mantener y testear. | P1 |
| 6 | 847 color literals dispersos — no usan `AppColors`. Cambio de brand = búsqueda manual. | P1 |
| 7 | **Vistas configuración faltantes** clave: perfil negocio (datos+horarios+formato_entrega), integraciones mensajería (WhatsApp+Telegram setup), pasos flujo pedido (estados+SLA). | P0 |
| 8 | SDK Data Connect V2 regenerado pero **0 providers lo consumen** — toda lectura sigue HTTP localhost. Migración pendiente Fase 6.3. | P0 |
| 9 | 58 `LinearGradient` inline + 23 `TextField` inline → bloated, sin estilo central. | P2 |
| 10 | 361 referencias FontAwesome con muchas deprecadas (`solidUserCircle`, `solidCheckCircle`, `phoneAlt`, etc — visto en `flutter analyze`). | P2 |

---

## Tabla maestra de pantallas

| Pantalla | LOC | God? | Color | Theater* | BadBackend | Acción Fase 6 | Prio |
|---|---:|:---:|---:|:---:|:---:|---|:---:|
| `auth/screens/landing_page.dart` | 463 | ✅ | 8 | ◯ | ◯ | Split god widget | P2 |
| `auth/screens/login_screen.dart` | 393 | ◯ | 25 | ◯ | ◯ | Migrar a FirebaseAuth | P0 |
| `auth/screens/processing_screen.dart` | 160 | ◯ | 9 | ◯ | ◯ | OK estilo | P3 |
| `auth/screens/recover_password_screen.dart` | 182 | ◯ | 15 | ◯ | ◯ | Wire FirebaseAuth reset | P1 |
| `auth/screens/register_screen.dart` | 590 | ✅ | 40 | ◯ | ◯ | Split + FirebaseAuth signup | P0 |
| `delivery/screens/delivery_main_screen.dart` | 81 | ◯ | 2 | ◯ | ◯ | OK | P3 |
| `delivery/screens/detalle_entrega_screen.dart` | 649 | ✅ | 46 | ◯ | ◯ | Split + SDK V2 | P1 |
| `delivery/screens/en_ruta_screen.dart` | 469 | ✅ | 35 | ◯ | ◯ | Split + integrar mapa real | P1 |
| `delivery/screens/pedidos_para_entregar_screen.dart` | 497 | ✅ | 37 | ◯ | ◯ | Split + provider→SDK | P0 |
| `delivery/screens/perfil_repartidor_screen.dart` | 544 | ✅ | 43 | ◯ | ◯ | Split + FirebaseAuth | P1 |
| `kitchen/screens/cola_pedidos_screen.dart` | 311 | ◯ | 2 | ◯ | ◯ | Provider→SDK | P0 |
| `kitchen/screens/kitchen_main_screen.dart` | 76 | ◯ | 3 | ◯ | ◯ | OK | P3 |
| `kitchen/screens/pedidos_listos_screen.dart` | 514 | ✅ | 34 | ◯ | ◯ | Split + provider→SDK | P0 |
| `kitchen/screens/perfil_cocinero_screen.dart` | 545 | ✅ | 42 | ◯ | ◯ | Split + FirebaseAuth | P1 |
| `kitchen/screens/preparacion_screen.dart` | 625 | ✅ | 36 | ◯ | ◯ | Split widget (Card 544 LOC) | P1 |
| `manager/screens/agente_ia_contexto_screen.dart` | 285 | ◯ | 0 | ⚠ | ◯ | Verificar wiring SDK plantillas | P1 |
| `manager/screens/agentes_ia_screen.dart` | 374 | ◯ | 0 | ⚠ | ◯ | Conectar a `ObtenerPlantillasIa` V2 | P0 |
| `manager/screens/agregar_editar_producto_screen.dart` | **887** | ✅ | 7 | ◯ | ◯ | **Split urgente** + SDK mutation | P0 |
| `manager/screens/dashboard_screen.dart` | 645 | ✅ | 4 | ⚠ | ◯ | Split + `ObtenerDashboardNegocioV2` | P0 |
| `manager/screens/equipo_screen.dart` | 440 | ✅ | 1 | ◯ | ◯ | Split + SDK V2 usuarios_admin | P1 |
| `manager/screens/inventario_screen.dart` | 632 | ✅ | 5 | ◯ | ◯ | Split + `ObtenerMenuInventario` V2 | P0 |
| `manager/screens/invitar_empleado_screen.dart` | 321 | ◯ | 73 | ◯ | ◯ | Wire flujo Firebase Auth invite | P1 |
| `manager/screens/kpis_screen.dart` | 507 | ✅ | 32 | ⚠ | ◯ | Split + analytics endpoint real | P2 |
| `manager/screens/manager_main_screen.dart` | 103 | ◯ | 4 | ◯ | ◯ | OK | P3 |
| `manager/screens/notificaciones_screen.dart` | 272 | ◯ | 1 | ⚠ | ◯ | FCM real + endpoint notificaciones | P1 |
| `manager/screens/orders_screen.dart` | 503 | ✅ | 37 | ◯ | ◯ | Split + `ObtenerPedidosKanban` V2 | P0 |
| `manager/screens/perfil_empleado_screen.dart` | 604 | ✅ | 57 | ◯ | ◯ | Split + SDK V2 | P1 |
| `manager/screens/profile_screen.dart` | 592 | ✅ | 52 | ⚠ | ◯ | Split + Firebase Auth | P0 |
| `manager/screens/settings_screen.dart` | 352 | ◯ | 0 | ⚠ | ◯ | Conectar settings reales negocio | P0 |

\* Theater: `⚠` = inspección visual sugiere render datos hardcoded/mock que el usuario podría confundir con reales (no detectable por grep — leer pantalla). `◯` = no detectado.

---

## God widgets >400 LOC — desglose

| Archivo | Clase | LOC | División sugerida |
|---|---|---:|---|
| `manager/agregar_editar_producto_screen.dart` | `_AgregarEditarProductoScreenState` | **868** | Split en: `ProductoFormHeader`, `ProductoPreciosSection`, `ProductoStockSection`, `ProductoCategoriaSelector`, `ProductoImagenUploader`, `ProductoSubmitBar` (6 componentes). |
| `delivery/detalle_entrega_screen.dart` | `DetalleEntregaScreen` | 640 | Split: `EntregaHeaderClient`, `EntregaItemsList`, `EntregaMapaPreview`, `EntregaAcciones`. |
| `manager/dashboard_screen.dart` | `_DashboardScreenState` | 622 | Split: `DashboardKpiTiles`, `DashboardPedidosRecientes`, `DashboardProductosTop`, `DashboardChartIngresos`. |
| `manager/inventario_screen.dart` | `_InventarioScreenState` | 613 | Split: `InventarioSearchBar`, `InventarioCategoriaTabs`, `InventarioProductoList`, `InventarioFiltrosModal`. |
| `manager/perfil_empleado_screen.dart` | `_PerfilEmpleadoScreenState` | 584 | Split: `EmpleadoAvatarSection`, `EmpleadoFormFields`, `EmpleadoRolSelector`, `EmpleadoAccionesBar`. |
| `manager/profile_screen.dart` | `ProfileScreen` | 579 | Split: `ProfileHeader`, `ProfileSecciones`, `ProfileMenuList`. |
| `auth/register_screen.dart` | `_RegisterScreenState` | 573 | Split: `RegisterPasoNegocio`, `RegisterPasoOwner`, `RegisterPasoCredenciales`. |
| `kitchen/preparacion_screen.dart` | `_PedidoPreparacionCardState` | 544 | Split: `PedidoCardHeader`, `PedidoItemsChecklist`, `PedidoTimerSlaBar`, `PedidoAccionesBar`. |
| `kitchen/perfil_cocinero_screen.dart` | `PerfilCocineroScreen` | 533 | (similar a perfil_empleado) |
| `delivery/perfil_repartidor_screen.dart` | `PerfilRepartidorScreen` | 535 | (similar) |
| `kitchen/pedidos_listos_screen.dart` | `PedidosListosScreen` | 504 | Split lista + filtros + card. |
| `manager/kpis_screen.dart` | `_KpisScreenState` | 493 | Split por sección de KPI. |
| `manager/orders_screen.dart` | `_OrdersScreenState` | 488 | Split: Kanban + filtros + card. |
| `delivery/pedidos_para_entregar_screen.dart` | `PedidosParaEntregarScreen` | 486 | Split lista + card + acciones. |
| `delivery/en_ruta_screen.dart` | `EnRutaScreen` | 460 | Split mapa + acciones + estado. |
| `auth/landing_page.dart` | `LandingPage` | 453 | Split hero + selector cargo. |
| `manager/equipo_screen.dart` | `_EquipoScreenState` | 423 | Split lista + invitar bar. |

**Estimación esfuerzo split:** ~6-8h por archivo P0 (5 archivos) + ~3h por P1/P2 (12 archivos) ≈ **70-90h dev**.

---

## Theater UI hotspots (inspección manual requerida)

Grep automático con keywords genéricos `_mockData|mockPedidos|hardcoded|FakeRepo|seedDemo|dummyData` retornó 0 matches. **PERO:**

- `lib/data/services/auth_service.dart` líneas 26-50 — users hardcoded en plaintext es theater **confirmado**.
- `manager/screens/agentes_ia_screen.dart` (374 LOC, 0 color lits, 0 backend ref) — sospechoso: probable lista hardcoded de "Agentes" sin SDK call. **Verificar.**
- `manager/screens/agente_ia_contexto_screen.dart` (285 LOC) — mismo caso.
- `manager/screens/dashboard_screen.dart` (622 LOC) — KPIs mostrados sin endpoint analytics real. **Casi seguro theater.**
- `manager/screens/notificaciones_screen.dart` (272 LOC) — lista notif sin provider FCM real.
- `manager/screens/settings_screen.dart` (352 LOC) — switches sin persistencia real (verificar).
- `manager/screens/kpis_screen.dart` (507 LOC) — gráficos sin data real.
- `manager/screens/profile_screen.dart` (592 LOC) — perfil con user from `AuthService` fake.

Acción Fase 6.1.b: leer cada uno y marcar campos theater vs reales.

---

## Acoplamiento backend roto

```bash
$ grep -rn "localhost\|X-Secret" lib/
lib/data/providers/inventory_provider.dart:29:    String baseUrl = 'http://localhost:5050',
lib/data/providers/order_provider.dart:38:    String baseUrl = 'http://localhost:5050',
lib/data/providers/order_provider.dart:278:      _secreto.isNotEmpty ? {'X-Secret': _secreto} : {};
lib/generated/prontoapp_dataconnect/README.md:16:String host = 'localhost'; // or your host name  ← OK (doc SDK)
lib/main.dart:40:            baseUrl: 'http://localhost:5050',
lib/main.dart:48:            baseUrl: 'http://localhost:5050',
```

**5 instancias en código productivo** (línea SDK README es doc, no producción).

Plan migración:
- Borrar `baseUrl` + `secreto` params del constructor de providers.
- Reemplazar `http.get(...)` por calls al SDK Data Connect (`ObtenerPedidosKanban`, `ObtenerMenuInventario`).
- Para mutaciones críticas: nuevo cliente FastAPI HTTP con `Authorization: Bearer <Firebase ID token>`.

Ver ADR Flutter 0001 para plan completo.

---

## Vistas configuración faltantes vs esperadas

| Vista esperada | Estado | Archivo (si existe) |
|---|---|---|
| Perfil usuario | ✅ existe | `manager/profile_screen.dart` (a refactor + auth real) |
| **Perfil negocio** (datos, horarios, formato_entrega, dirección, tipo) | ❌ **falta** | crear `manager/perfil_negocio_screen.dart` |
| Agente IA — lista plantillas | ✅ existe (theater) | `manager/agentes_ia_screen.dart` (wire SDK V2) |
| Agente IA — contexto/conocimiento | ✅ existe (theater) | `manager/agente_ia_contexto_screen.dart` |
| **Integraciones mensajería** (WhatsApp + Telegram setup) | ❌ **falta** | crear `manager/integraciones_mensajeria_screen.dart` |
| Inventario CRUD | ✅ existe | `inventario_screen.dart` + `agregar_editar_producto_screen.dart` |
| Plantillas IA UI real | ⚠ parcial (theater) | `agentes_ia_screen.dart` — necesita CRUD plantillas reales |
| Equipo | ✅ existe | `equipo_screen.dart` + `invitar_empleado_screen.dart` + `perfil_empleado_screen.dart` |
| **Pasos flujo pedido** (configurar estados + SLA) | ❌ **falta** | crear `manager/configurar_pasos_flujo_screen.dart` |
| Settings general | ✅ existe (theater) | `settings_screen.dart` — switches sin backing |
| **Categorías producto CRUD** | ❌ **falta** (mezclado en inventario) | extraer a `manager/categorias_screen.dart` |
| **Notificaciones config** (canales, tipos, opt-in/out) | ⚠ existe lista, **falta config** | `notificaciones_screen.dart` |

**Acción Fase 6.4:** generar 4 screens nuevas (perfil negocio, integraciones mensajería, pasos flujo, categorías) + completar settings real.

---

## Análisis estilo

| Métrica | Cuenta | Comando |
|---|---:|---|
| Color literals `Color(0x...)` | **847** | `grep -rn "Color(0x" lib/ \| wc -l` |
| `LinearGradient(...)` inline | 58 | `grep -rn "LinearGradient(" lib/ \| wc -l` |
| `TextField(...)` inline (no CustomTextField) | 23 | `grep -rn "TextField(" lib/ \| wc -l` |
| `withOpacity(...)` (deprecated → `.withValues()`) | 10 | `grep -rn "withOpacity" lib/ \| wc -l` |
| FontAwesome / `FaIcon` refs (varios deprecated) | 361 | `grep -rn "FontAwesome\|FaIcon" lib/ \| wc -l` |

**Plan Fase 6.5:**
1. Centralizar `AppColors` con 30-40 tokens (primary, secondary, success, danger, warn, surface, on-*).
2. Migrar las 847 ocurrencias mediante codemod (script Dart o regex find/replace por familia de color).
3. Crear `LinearGradient` presets en `lib/ui/theme/gradients.dart`.
4. Migrar `TextField` inline a `CustomTextField` uniforme.
5. Reemplazar `withOpacity` → `.withValues(alpha: x)` (10 instancias).
6. Renombrar FontAwesome deprecados (mostly `*UserCircle`→`*CircleUser`, `*CheckCircle`→`*CircleCheck`, `phoneAlt`→`phoneFlip`).

---

## 🚨 RIESGOS DE SEGURIDAD

### CRÍTICO — Secret API key en código fuente

`lib/main.dart` líneas 41 y 50:
```dart
secreto: '83c58120a0a140ade0282b37ff64731f3fdd3f7dc306be3151ec62e967b43f43',
```

**Impacto:** cualquiera con `apktool` extrae el secret del APK firmado. Si ese secret autoriza cualquier endpoint, **el atacante puede usarlo desde fuera de la app**.

**Mitigación inmediata:**
1. **Rotar el secret** en el backend que lo valida.
2. Borrar los literales de `main.dart` HOY (esta sesión si Junior autoriza).
3. Borrar el header `X-Secret` de `order_provider.dart:278`.
4. **NO** reemplazar por otro secret hardcoded — usar Firebase ID Token (ver ADR 0001).

### CRÍTICO — Auth fake con plaintext passwords

`lib/data/services/auth_service.dart` líneas 26-50 — passwords `password123` en seed. Si en producción el código corre estas inicializaciones, cualquiera con esos emails entra.

**Mitigación:** borrar `auth_service.dart` o reescribirlo como wrapper `FirebaseAuth` puro (ADR 0001).

### MEDIO — `localhost:5050` enviado en APK

No es secret, pero indica al atacante que la app espera un backend HTTP localhost — pista para reverse engineering.

---

## Estimación esfuerzo Fase 6

| Sub-fase | Tarea | Horas |
|---|---|---:|
| 6.2 | Firebase Auth real + borrar fake + borrar X-Secret/localhost | 8-12 |
| 6.3 | Providers → SDK SQL Connect (3 providers + tests) | 16-20 |
| 6.4 | Vistas configuración faltantes (4 screens nuevas + settings real) | 20-30 |
| 6.5 | Refactor 17 god widgets + AppColors centralizado | 60-80 |
| 6.6 | Migración FontAwesome deprecated + withOpacity | 4-6 |
| 6.7 | Tests widget mínimos (auth, dashboard, orders, inventario) | 12-16 |
| **Total** | | **~120-165 h** |

(Numero asume 1 dev senior Flutter. Codex puede absorber 30-40% del 6.5 mecánico.)

---

## Comandos reproducibles

```bash
# Listado screens
find lib/features -type f -name "*.dart" -path "*/screens/*" | sort

# Métricas por screen
python tools_audit_screens.py   # script en raíz del repo

# Acoplamiento backend roto
grep -rn "localhost\|X-Secret" lib/

# Métricas globales estilo
grep -rn "Color(0x" lib/ | wc -l
grep -rn "LinearGradient(" lib/ | wc -l
grep -rn "TextField(" lib/ | wc -l
grep -rn "withOpacity" lib/ | wc -l
grep -rn "FontAwesome\|FaIcon" lib/ | wc -l

# Análisis Flutter completo
flutter analyze --no-pub > docs/frontend-mobile/ANALYZE_POST_SCHEMA_V2.md
```

---

## Próximas decisiones requeridas a Junior

1. ¿Rotar secret `83c58120...43` y borrar HOY? (mientras el secret esté vivo, sigue siendo riesgo).
2. ¿Cuáles vistas configuración faltantes son P0 para piloto? (sugiero: perfil negocio + integraciones mensajería).
3. ¿Codex absorbe sub-fase 6.5 mecánica (AppColors + replace literals)?

---

## Referencias

- ADR Flutter 0001: `docs/arquitectura/0001-flutter-firebase-auth-sdk-sqlconnect.md`
- `flutter analyze` snapshot: `docs/frontend-mobile/ANALYZE_POST_SCHEMA_V2.md`
- Plan ejecución Fase 6: `docs/sesiones/PLAN_EJECUCION_FASES_0-7.md`
- Auditoría heredada: `docs/ARCHITECTURE_REVIEW.md`
