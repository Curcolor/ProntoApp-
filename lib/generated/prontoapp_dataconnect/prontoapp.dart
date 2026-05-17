library prontoapp_dataconnect;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

part 'crear_cliente.dart';

part 'obtener_dashboard_negocio_v2.dart';

part 'obtener_pedidos_kanban.dart';

part 'obtener_menu_inventario.dart';

part 'obtener_plantillas_ia.dart';

part 'obtener_integraciones_mensajeria.dart';



  enum ActorOperacion {
    
      USUARIO,
    
      IA,
    
      SISTEMA,
    
      CLIENTE,
    
  }
  
  String actorOperacionSerializer(EnumValue<ActorOperacion> e) {
    return e.stringValue;
  }
  EnumValue<ActorOperacion> actorOperacionDeserializer(dynamic data) {
    switch (data) {
      
      case 'USUARIO':
        return const Known(ActorOperacion.USUARIO);
      
      case 'IA':
        return const Known(ActorOperacion.IA);
      
      case 'SISTEMA':
        return const Known(ActorOperacion.SISTEMA);
      
      case 'CLIENTE':
        return const Known(ActorOperacion.CLIENTE);
      
      default:
        return Unknown(data);
    }
  }
  

  enum CanalMensajeria {
    
      WHATSAPP_CLOUD,
    
      WHATSAPP_BUSINESS,
    
      TELEGRAM_BOT,
    
      WEBCHAT,
    
  }
  
  String canalMensajeriaSerializer(EnumValue<CanalMensajeria> e) {
    return e.stringValue;
  }
  EnumValue<CanalMensajeria> canalMensajeriaDeserializer(dynamic data) {
    switch (data) {
      
      case 'WHATSAPP_CLOUD':
        return const Known(CanalMensajeria.WHATSAPP_CLOUD);
      
      case 'WHATSAPP_BUSINESS':
        return const Known(CanalMensajeria.WHATSAPP_BUSINESS);
      
      case 'TELEGRAM_BOT':
        return const Known(CanalMensajeria.TELEGRAM_BOT);
      
      case 'WEBCHAT':
        return const Known(CanalMensajeria.WEBCHAT);
      
      default:
        return Unknown(data);
    }
  }
  

  enum CanalOperacion {
    
      APP,
    
      WHATSAPP,
    
      TELEGRAM,
    
      WEB,
    
      SISTEMA,
    
  }
  
  String canalOperacionSerializer(EnumValue<CanalOperacion> e) {
    return e.stringValue;
  }
  EnumValue<CanalOperacion> canalOperacionDeserializer(dynamic data) {
    switch (data) {
      
      case 'APP':
        return const Known(CanalOperacion.APP);
      
      case 'WHATSAPP':
        return const Known(CanalOperacion.WHATSAPP);
      
      case 'TELEGRAM':
        return const Known(CanalOperacion.TELEGRAM);
      
      case 'WEB':
        return const Known(CanalOperacion.WEB);
      
      case 'SISTEMA':
        return const Known(CanalOperacion.SISTEMA);
      
      default:
        return Unknown(data);
    }
  }
  

  enum CanalPedido {
    
      WHATSAPP,
    
      MANUAL,
    
      WEB,
    
      TELEGRAM,
    
  }
  
  String canalPedidoSerializer(EnumValue<CanalPedido> e) {
    return e.stringValue;
  }
  EnumValue<CanalPedido> canalPedidoDeserializer(dynamic data) {
    switch (data) {
      
      case 'WHATSAPP':
        return const Known(CanalPedido.WHATSAPP);
      
      case 'MANUAL':
        return const Known(CanalPedido.MANUAL);
      
      case 'WEB':
        return const Known(CanalPedido.WEB);
      
      case 'TELEGRAM':
        return const Known(CanalPedido.TELEGRAM);
      
      default:
        return Unknown(data);
    }
  }
  

  enum CasoUsoPlantilla {
    
      INGESTA_PEDIDO,
    
      ESTADO_PEDIDO,
    
      NOTIFICACION,
    
      REVISION_MULTIMODAL,
    
      ESCALAMIENTO,
    
      ATENCION_CLIENTE,
    
      RECOMENDACION_PRODUCTO,
    
      RESUMEN_CONVERSACION,
    
  }
  
  String casoUsoPlantillaSerializer(EnumValue<CasoUsoPlantilla> e) {
    return e.stringValue;
  }
  EnumValue<CasoUsoPlantilla> casoUsoPlantillaDeserializer(dynamic data) {
    switch (data) {
      
      case 'INGESTA_PEDIDO':
        return const Known(CasoUsoPlantilla.INGESTA_PEDIDO);
      
      case 'ESTADO_PEDIDO':
        return const Known(CasoUsoPlantilla.ESTADO_PEDIDO);
      
      case 'NOTIFICACION':
        return const Known(CasoUsoPlantilla.NOTIFICACION);
      
      case 'REVISION_MULTIMODAL':
        return const Known(CasoUsoPlantilla.REVISION_MULTIMODAL);
      
      case 'ESCALAMIENTO':
        return const Known(CasoUsoPlantilla.ESCALAMIENTO);
      
      case 'ATENCION_CLIENTE':
        return const Known(CasoUsoPlantilla.ATENCION_CLIENTE);
      
      case 'RECOMENDACION_PRODUCTO':
        return const Known(CasoUsoPlantilla.RECOMENDACION_PRODUCTO);
      
      case 'RESUMEN_CONVERSACION':
        return const Known(CasoUsoPlantilla.RESUMEN_CONVERSACION);
      
      default:
        return Unknown(data);
    }
  }
  

  enum EstadoPago {
    
      PENDIENTE,
    
      PARCIAL,
    
      PAGADO,
    
      REEMBOLSADO,
    
      FALLIDO,
    
  }
  
  String estadoPagoSerializer(EnumValue<EstadoPago> e) {
    return e.stringValue;
  }
  EnumValue<EstadoPago> estadoPagoDeserializer(dynamic data) {
    switch (data) {
      
      case 'PENDIENTE':
        return const Known(EstadoPago.PENDIENTE);
      
      case 'PARCIAL':
        return const Known(EstadoPago.PARCIAL);
      
      case 'PAGADO':
        return const Known(EstadoPago.PAGADO);
      
      case 'REEMBOLSADO':
        return const Known(EstadoPago.REEMBOLSADO);
      
      case 'FALLIDO':
        return const Known(EstadoPago.FALLIDO);
      
      default:
        return Unknown(data);
    }
  }
  

  enum EstadoPedido {
    
      RECIBIDO,
    
      EN_PREPARACION,
    
      LISTO_DESPACHO,
    
      ENVIADO,
    
      ENTREGADO,
    
      CERRADO,
    
      CANCELADO,
    
      REQUIERE_REVISION,
    
      LISTO,
    
      EN_CAMINO,
    
      PAGADO,
    
  }
  
  String estadoPedidoSerializer(EnumValue<EstadoPedido> e) {
    return e.stringValue;
  }
  EnumValue<EstadoPedido> estadoPedidoDeserializer(dynamic data) {
    switch (data) {
      
      case 'RECIBIDO':
        return const Known(EstadoPedido.RECIBIDO);
      
      case 'EN_PREPARACION':
        return const Known(EstadoPedido.EN_PREPARACION);
      
      case 'LISTO_DESPACHO':
        return const Known(EstadoPedido.LISTO_DESPACHO);
      
      case 'ENVIADO':
        return const Known(EstadoPedido.ENVIADO);
      
      case 'ENTREGADO':
        return const Known(EstadoPedido.ENTREGADO);
      
      case 'CERRADO':
        return const Known(EstadoPedido.CERRADO);
      
      case 'CANCELADO':
        return const Known(EstadoPedido.CANCELADO);
      
      case 'REQUIERE_REVISION':
        return const Known(EstadoPedido.REQUIERE_REVISION);
      
      case 'LISTO':
        return const Known(EstadoPedido.LISTO);
      
      case 'EN_CAMINO':
        return const Known(EstadoPedido.EN_CAMINO);
      
      case 'PAGADO':
        return const Known(EstadoPedido.PAGADO);
      
      default:
        return Unknown(data);
    }
  }
  

  enum FormatoEntrega {
    
      RECOGER,
    
      DOMICILIO,
    
      MESA,
    
      MIXTO,
    
  }
  
  String formatoEntregaSerializer(EnumValue<FormatoEntrega> e) {
    return e.stringValue;
  }
  EnumValue<FormatoEntrega> formatoEntregaDeserializer(dynamic data) {
    switch (data) {
      
      case 'RECOGER':
        return const Known(FormatoEntrega.RECOGER);
      
      case 'DOMICILIO':
        return const Known(FormatoEntrega.DOMICILIO);
      
      case 'MESA':
        return const Known(FormatoEntrega.MESA);
      
      case 'MIXTO':
        return const Known(FormatoEntrega.MIXTO);
      
      default:
        return Unknown(data);
    }
  }
  

  enum ProveedorLlm {
    
      ANTHROPIC,
    
      OPENAI,
    
      GOOGLE,
    
      DEEPSEEK,
    
      GROQ,
    
      MISTRAL,
    
      AZURE_OPENAI,
    
  }
  
  String proveedorLlmSerializer(EnumValue<ProveedorLlm> e) {
    return e.stringValue;
  }
  EnumValue<ProveedorLlm> proveedorLlmDeserializer(dynamic data) {
    switch (data) {
      
      case 'ANTHROPIC':
        return const Known(ProveedorLlm.ANTHROPIC);
      
      case 'OPENAI':
        return const Known(ProveedorLlm.OPENAI);
      
      case 'GOOGLE':
        return const Known(ProveedorLlm.GOOGLE);
      
      case 'DEEPSEEK':
        return const Known(ProveedorLlm.DEEPSEEK);
      
      case 'GROQ':
        return const Known(ProveedorLlm.GROQ);
      
      case 'MISTRAL':
        return const Known(ProveedorLlm.MISTRAL);
      
      case 'AZURE_OPENAI':
        return const Known(ProveedorLlm.AZURE_OPENAI);
      
      default:
        return Unknown(data);
    }
  }
  

  enum RolAdmin {
    
      PROPIETARIO,
    
      GERENTE,
    
      COCINERO,
    
      REPARTIDOR,
    
      SUPERVISOR,
    
  }
  
  String rolAdminSerializer(EnumValue<RolAdmin> e) {
    return e.stringValue;
  }
  EnumValue<RolAdmin> rolAdminDeserializer(dynamic data) {
    switch (data) {
      
      case 'PROPIETARIO':
        return const Known(RolAdmin.PROPIETARIO);
      
      case 'GERENTE':
        return const Known(RolAdmin.GERENTE);
      
      case 'COCINERO':
        return const Known(RolAdmin.COCINERO);
      
      case 'REPARTIDOR':
        return const Known(RolAdmin.REPARTIDOR);
      
      case 'SUPERVISOR':
        return const Known(RolAdmin.SUPERVISOR);
      
      default:
        return Unknown(data);
    }
  }
  

  enum TipoNegocio {
    
      RESTAURANTE,
    
      CAFE,
    
      COMIDA_RAPIDA,
    
      PANADERIA,
    
      FARMACIA,
    
      TIENDA,
    
      COMERCIO,
    
      OTRO,
    
  }
  
  String tipoNegocioSerializer(EnumValue<TipoNegocio> e) {
    return e.stringValue;
  }
  EnumValue<TipoNegocio> tipoNegocioDeserializer(dynamic data) {
    switch (data) {
      
      case 'RESTAURANTE':
        return const Known(TipoNegocio.RESTAURANTE);
      
      case 'CAFE':
        return const Known(TipoNegocio.CAFE);
      
      case 'COMIDA_RAPIDA':
        return const Known(TipoNegocio.COMIDA_RAPIDA);
      
      case 'PANADERIA':
        return const Known(TipoNegocio.PANADERIA);
      
      case 'FARMACIA':
        return const Known(TipoNegocio.FARMACIA);
      
      case 'TIENDA':
        return const Known(TipoNegocio.TIENDA);
      
      case 'COMERCIO':
        return const Known(TipoNegocio.COMERCIO);
      
      case 'OTRO':
        return const Known(TipoNegocio.OTRO);
      
      default:
        return Unknown(data);
    }
  }
  



String enumSerializer(Enum e) {
  return e.name;
}



/// A sealed class representing either a known enum value or an unknown string value.
@immutable
sealed class EnumValue<T extends Enum> {
  const EnumValue();

  

  /// The string representation of the value.
  String get stringValue;
  @override
  String toString() {
    return "EnumValue($stringValue)";
  }
}

/// Represents a known, valid enum value.
class Known<T extends Enum> extends EnumValue<T> {
  /// The actual enum value.
  final T value;

  const Known(this.value);

  @override
  String get stringValue => value.name;

  @override
  String toString() {
    return "Known($stringValue)";
  }
}
/// Represents an unknown or unrecognized enum value.
class Unknown extends EnumValue<Never> {
  /// The raw string value that couldn't be mapped to a known enum.
  @override
  final String stringValue;

  const Unknown(this.stringValue);
  @override
  String toString() {
    return "Unknown($stringValue)";
  }
}

class ProntoappConnector {
  
  
  CrearClienteVariablesBuilder crearCliente ({required String negocioId, required String nombre, required String numeroWhatsapp, }) {
    return CrearClienteVariablesBuilder(dataConnect, negocioId: negocioId,nombre: nombre,numeroWhatsapp: numeroWhatsapp,);
  }
  
  
  ObtenerDashboardNegocioV2VariablesBuilder obtenerDashboardNegocioV2 ({required String negocioId, required Timestamp pedidosDesde, }) {
    return ObtenerDashboardNegocioV2VariablesBuilder(dataConnect, negocioId: negocioId,pedidosDesde: pedidosDesde,);
  }
  
  
  ObtenerPedidosKanbanVariablesBuilder obtenerPedidosKanban ({required String negocioId, required EstadoPedido estado, }) {
    return ObtenerPedidosKanbanVariablesBuilder(dataConnect, negocioId: negocioId,estado: estado,);
  }
  
  
  ObtenerMenuInventarioVariablesBuilder obtenerMenuInventario ({required String negocioId, }) {
    return ObtenerMenuInventarioVariablesBuilder(dataConnect, negocioId: negocioId,);
  }
  
  
  ObtenerPlantillasIaVariablesBuilder obtenerPlantillasIa ({required String negocioId, required CasoUsoPlantilla casoUso, }) {
    return ObtenerPlantillasIaVariablesBuilder(dataConnect, negocioId: negocioId,casoUso: casoUso,);
  }
  
  
  ObtenerIntegracionesMensajeriaVariablesBuilder obtenerIntegracionesMensajeria ({required String negocioId, }) {
    return ObtenerIntegracionesMensajeriaVariablesBuilder(dataConnect, negocioId: negocioId,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'prontoapp',
    'test-firestore-c77ab-2-service',
  );

  ProntoappConnector({required this.dataConnect});
  static ProntoappConnector get instance {
    
    CacheSettings cacheSettings = CacheSettings(
      maxAge: Duration(milliseconds:30000),
      storage: CacheStorage.persistent,
    );
    
    return ProntoappConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            cacheSettings: cacheSettings,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
