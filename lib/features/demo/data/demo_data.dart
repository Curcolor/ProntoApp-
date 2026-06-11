import 'package:prontoapp/data/models/category_model.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/models/product_model.dart';

/// Categorías de ejemplo para el demo (sin red, datos fijos).
final demoCategorias = <Category>[
  Category(id: 'cat-panaderia', name: 'Panadería', emoji: '🥖'),
  Category(id: 'cat-bebidas', name: 'Bebidas', emoji: '🥤'),
  Category(id: 'cat-reposteria', name: 'Repostería', emoji: '🥐'),
];

/// Productos de ejemplo: mezcla de stock disponible / bajo / agotado.
final demoProductos = <Product>[
  Product(
    id: 'prod-pan-bono',
    name: 'Pan de bono',
    categoryId: 'cat-panaderia',
    price: 3000,
    stock: 40,
    minStock: 10,
    prepTimeMinutes: 5,
    isAvailable: true,
    description: 'Pan de bono recién horneado',
    aiContext: 'Producto estrella de la panadería',
    aiActive: true,
    emoji: '🥖',
  ),
  Product(
    id: 'prod-almojabana',
    name: 'Almojábana',
    categoryId: 'cat-panaderia',
    price: 2500,
    stock: 8,
    minStock: 10,
    prepTimeMinutes: 5,
    isAvailable: true,
    description: 'Almojábana suave de queso',
    aiContext: 'Stock bajo, reabastecer pronto',
    aiActive: true,
    emoji: '🧀',
  ),
  Product(
    id: 'prod-croissant',
    name: 'Croissant',
    categoryId: 'cat-reposteria',
    price: 4500,
    stock: 0,
    minStock: 5,
    prepTimeMinutes: 8,
    isAvailable: false,
    description: 'Croissant de mantequilla',
    aiContext: 'Agotado, no ofrecer hasta reposición',
    aiActive: false,
    emoji: '🥐',
  ),
  Product(
    id: 'prod-jugo-naranja',
    name: 'Jugo de naranja',
    categoryId: 'cat-bebidas',
    price: 5000,
    stock: 25,
    minStock: 5,
    prepTimeMinutes: 3,
    isAvailable: true,
    description: 'Jugo natural de naranja',
    aiContext: 'Bebida popular en las mañanas',
    aiActive: true,
    emoji: '🍊',
  ),
  Product(
    id: 'prod-cafe-tinto',
    name: 'Café tinto',
    categoryId: 'cat-bebidas',
    price: 2000,
    stock: 3,
    minStock: 5,
    prepTimeMinutes: 2,
    isAvailable: true,
    description: 'Café negro tradicional',
    aiContext: 'Stock bajo de granos de café',
    aiActive: true,
    emoji: '☕',
  ),
  Product(
    id: 'prod-torta-chocolate',
    name: 'Torta de chocolate',
    categoryId: 'cat-reposteria',
    price: 8000,
    stock: 12,
    minStock: 3,
    prepTimeMinutes: 10,
    isAvailable: true,
    description: 'Porción de torta de chocolate',
    aiContext: 'Postre destacado de la repostería',
    aiActive: true,
    emoji: '🍫',
  ),
];

final _hoy = DateTime.now();
final _ayer = DateTime.now().subtract(const Duration(days: 1));

/// Pedidos de ejemplo: mezcla de estados, tipos y días (hoy/ayer).
final demoPedidos = <OrderModel>[
  // ─── Hoy ────────────────────────────────────────────────────────────
  OrderModel(
    id: 'P-D01',
    cliente: 'María García',
    telefono: 'tg:demo',
    items: const [
      ItemPedido(nombre: 'Pan de bono', cantidad: 2, precio: 3000),
      ItemPedido(nombre: 'Café tinto', cantidad: 1, precio: 2000),
    ],
    total: 8000,
    estado: EstadoPedido.recibido,
    tipo: TipoPedido.domicilio,
    direccion: 'Cll 72 #45-12, El Prado',
    creadoEn: _hoy,
  ),
  OrderModel(
    id: 'P-D02',
    cliente: 'Carlos Rodríguez',
    telefono: '+57 300 000 0001',
    items: const [
      ItemPedido(nombre: 'Almojábana', cantidad: 3, precio: 2500),
      ItemPedido(nombre: 'Jugo de naranja', cantidad: 1, precio: 5000),
    ],
    total: 12500,
    estado: EstadoPedido.enPreparacion,
    tipo: TipoPedido.recoger,
    creadoEn: _hoy,
  ),
  OrderModel(
    id: 'P-D03',
    cliente: 'Laura Pérez',
    telefono: 'tg:demo',
    items: const [
      ItemPedido(nombre: 'Torta de chocolate', cantidad: 1, precio: 8000),
    ],
    total: 8000,
    estado: EstadoPedido.listo,
    tipo: TipoPedido.domicilio,
    direccion: 'Carrera 50 #80-20, Riomar',
    creadoEn: _hoy,
  ),
  // ─── Ayer ───────────────────────────────────────────────────────────
  OrderModel(
    id: 'P-A01',
    cliente: 'Andrés Torres',
    telefono: '+57 300 000 0002',
    items: const [
      ItemPedido(nombre: 'Pan de bono', cantidad: 4, precio: 3000),
      ItemPedido(nombre: 'Jugo de naranja', cantidad: 2, precio: 5000),
    ],
    total: 22000,
    estado: EstadoPedido.enCamino,
    tipo: TipoPedido.domicilio,
    direccion: 'Calle 84 #51-30, Alto Prado',
    creadoEn: _ayer,
  ),
  OrderModel(
    id: 'P-A02',
    cliente: 'Sofía Martínez',
    telefono: 'tg:demo',
    items: const [
      ItemPedido(nombre: 'Café tinto', cantidad: 2, precio: 2000),
      ItemPedido(nombre: 'Almojábana', cantidad: 2, precio: 2500),
    ],
    total: 9000,
    estado: EstadoPedido.entregado,
    tipo: TipoPedido.recoger,
    creadoEn: _ayer,
  ),
  OrderModel(
    id: 'P-A03',
    cliente: 'Jorge Ramírez',
    telefono: '+57 300 000 0003',
    items: const [
      ItemPedido(nombre: 'Torta de chocolate', cantidad: 2, precio: 8000),
      ItemPedido(nombre: 'Jugo de naranja', cantidad: 1, precio: 5000),
    ],
    total: 21000,
    estado: EstadoPedido.entregado,
    tipo: TipoPedido.domicilio,
    direccion: 'Cra 43 #65-08, Boston',
    creadoEn: _ayer,
  ),
];
