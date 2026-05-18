import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:mockito/annotations.dart';
import 'package:prontoapp/data/services/perfil_usuario_admin_service.dart';
import 'package:prontoapp/generated/prontoapp_dataconnect/prontoapp.dart';

@GenerateMocks(
  [
    ProntoappConnector,
    PerfilUsuarioAdminService,
    ObtenerNegocioVariablesBuilder,
    ActualizarNegocioVariablesBuilder,
    ObtenerIntegracionesMensajeriaAdminVariablesBuilder,
    CrearIntegracionMensajeriaVariablesBuilder,
    DesactivarIntegracionMensajeriaVariablesBuilder,
    ObtenerPlantillasIaAdminVariablesBuilder,
    ActualizarPlantillaIaVariablesBuilder,
    DesactivarPlantillaIaVariablesBuilder,
  ],
  customMocks: [
    MockSpec<QueryResult<ObtenerNegocioData, ObtenerNegocioVariables>>(
      as: #MockObtenerNegocioQueryResult,
    ),
    MockSpec<OperationResult<ActualizarNegocioData, ActualizarNegocioVariables>>(
      as: #MockActualizarNegocioOperationResult,
    ),
    MockSpec<
        QueryResult<ObtenerIntegracionesMensajeriaAdminData,
            ObtenerIntegracionesMensajeriaAdminVariables>>(
      as: #MockObtenerIntegracionesMensajeriaAdminQueryResult,
    ),
    MockSpec<
        OperationResult<CrearIntegracionMensajeriaData,
            CrearIntegracionMensajeriaVariables>>(
      as: #MockCrearIntegracionMensajeriaOperationResult,
    ),
    MockSpec<
        OperationResult<DesactivarIntegracionMensajeriaData,
            DesactivarIntegracionMensajeriaVariables>>(
      as: #MockDesactivarIntegracionMensajeriaOperationResult,
    ),
    MockSpec<
        QueryResult<ObtenerPlantillasIaAdminData,
            ObtenerPlantillasIaAdminVariables>>(
      as: #MockObtenerPlantillasIaAdminQueryResult,
    ),
    MockSpec<OperationResult<ActualizarPlantillaIaData, ActualizarPlantillaIaVariables>>(
      as: #MockActualizarPlantillaIaOperationResult,
    ),
    MockSpec<OperationResult<DesactivarPlantillaIaData, DesactivarPlantillaIaVariables>>(
      as: #MockDesactivarPlantillaIaOperationResult,
    ),
  ],
)
void main() {}
