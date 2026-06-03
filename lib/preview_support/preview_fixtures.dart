import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:prontoapp/data/models/category_model.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/models/product_model.dart';
import 'package:prontoapp/data/models/user_model.dart';

/// Sample data determinista usado únicamente por las widget previews.

List<Category> sampleCategories() => [
      Category(id: 'cat-pizzas', name: 'Pizzas', emoji: '🍕'),
      Category(id: 'cat-bebidas', name: 'Bebidas', emoji: '🥤'),
    ];

List<Product> sampleProducts() => [
      Product(
        id: 'PR-1', name: 'Pizza Margarita', categoryId: 'cat-pizzas',
        price: 18000, stock: 24, minStock: 5, prepTimeMinutes: 15,
        isAvailable: true, description: 'Tomate, mozzarella y albahaca.',
        aiContext: '', aiActive: true, emoji: '🍕',
      ),
      Product(
        id: 'PR-2', name: 'Limonada', categoryId: 'cat-bebidas',
        price: 6000, stock: 3, minStock: 5, prepTimeMinutes: 3,
        isAvailable: true, description: 'Limonada natural 500ml.',
        aiContext: '', aiActive: true, emoji: '🥤',
      ),
    ];

Product sampleProduct() => sampleProducts().first;

OrderModel _order({
  required String id,
  required String cliente,
  required EstadoPedido estado,
  required TipoPedido tipo,
  int minutosAtras = 10,
}) =>
    OrderModel(
      id: id,
      cliente: cliente,
      telefono: 'tg:0001',
      items: const [
        ItemPedido(nombre: 'Pizza Margarita', cantidad: 2, precio: 18000),
        ItemPedido(nombre: 'Limonada', cantidad: 1, precio: 6000),
      ],
      total: 42000,
      estado: estado,
      tipo: tipo,
      direccion: tipo == TipoPedido.domicilio ? 'Calle 123 #45-67' : null,
      creadoEn: DateTime.now().subtract(Duration(minutes: minutosAtras)),
    );

List<OrderModel> sampleOrders() => [
      _order(id: 'P-A1', cliente: 'Ana Gómez', estado: EstadoPedido.recibido, tipo: TipoPedido.domicilio, minutosAtras: 5),
      _order(id: 'P-B2', cliente: 'Luis Pérez', estado: EstadoPedido.enPreparacion, tipo: TipoPedido.recoger, minutosAtras: 20),
      _order(id: 'P-C3', cliente: 'Sara Díaz', estado: EstadoPedido.listo, tipo: TipoPedido.domicilio, minutosAtras: 35),
      _order(id: 'P-D4', cliente: 'Juan Ruiz', estado: EstadoPedido.entregado, tipo: TipoPedido.recoger, minutosAtras: 90),
    ];

OrderModel sampleOrder() => sampleOrders().first;

UserModel sampleUser() => UserModel(
      id: 'U-PREVIEW',
      email: 'ana@pronto.co',
      name: 'Ana Gómez',
      role: RoleType.repartidor,
    );

/// `meta` que consume `perfil_empleado_screen.dart` (todas las claves que lee).
Map<String, dynamic> sampleMeta() => {
      'role': 'Repartidora',
      'initial': 'A',
      'initialColor': const Color(0xFFB45309),
      'gradientColors': const [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
      'roleBg': const Color(0xFFFEF3C7),
      'roleIcon': FontAwesomeIcons.motorcycle,
      'roleColor': const Color(0xFFB45309),
      'statusDotColor': const Color(0xFF25D366),
      'statusText': 'Activa',
    };
