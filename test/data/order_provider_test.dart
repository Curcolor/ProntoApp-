import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/repositories/order_repository.dart';
import 'package:prontoapp/data/providers/order_provider.dart';

OrderModel _ped(String id, EstadoPedido estado) => OrderModel(
  id: id, cliente: 'Ana', telefono: '300', items: const [],
  total: 1000, estado: estado, tipo: TipoPedido.recoger, creadoEn: DateTime(2026, 6, 3));

class _FakeRepo implements OrderRepository {
  List<OrderModel> remoto = [];
  String? avanzado;
  @override
  Future<List<OrderModel>> fetchPedidos() async => remoto;
  @override
  List<OrderModel> readCache() => const [];
  @override
  Future<void> avanzarEstado(String id, String estado) async { avanzado = '$id:$estado'; }
  @override
  Future<void> eliminarPedido(String id) async {}
  @override
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  test('sincronizar trae pedidos y filtra por estado', () async {
    final repo = _FakeRepo()..remoto = [_ped('P-1', EstadoPedido.recibido), _ped('P-2', EstadoPedido.listo)];
    final p = OrderProvider(repositorio: repo);
    await p.sincronizar();
    expect(p.pedidos.length, 2);
    expect(p.recibidos.single.id, 'P-1');
    expect(p.listos.single.id, 'P-2');
  });

  test('avanzarEstado delega al repo', () async {
    final repo = _FakeRepo()..remoto = [_ped('P-1', EstadoPedido.recibido)];
    final p = OrderProvider(repositorio: repo);
    await p.sincronizar();
    await p.avanzarEstado('P-1');
    expect(repo.avanzado, 'P-1:en_preparacion');
  });

  test('preview no usa repo', () {
    final p = OrderProvider.preview(pedidos: [_ped('P-9', EstadoPedido.recibido)]);
    expect(p.pedidos.single.id, 'P-9');
  });
}
