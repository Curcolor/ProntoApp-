import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/ui/components/manager/editar_perfil_components.dart';

class EditarPerfilModals {
  static void showEditarCorreo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EditarPerfilForm(
        title: 'Editar correo electrónico',
        subtitle: 'El correo es tu identificador de acceso a Prontoa.',
        currentLabel: 'Correo actual',
        currentValue: 'carlos.mendoza@correo.com',
        currentIcon: FontAwesomeIcons.solidEnvelope,
        inputLabel1: 'Nuevo correo electrónico',
        inputHint1: 'nuevo@correo.com',
        inputIcon1: FontAwesomeIcons.solidEnvelope,
        inputLabel2: 'Confirmar nuevo correo',
        inputHint2: 'nuevo@correo.com',
        inputIcon2: FontAwesomeIcons.solidCircleCheck,
        infoText:
            'Te enviaremos un enlace de verificación al nuevo correo antes de aplicar el cambio.',
        submitText: 'Enviar verificación',
        submitIcon: FontAwesomeIcons.paperPlane,
      ),
    );
  }

  static void showEditarTelefono(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EditarPerfilForm(
        title: 'Editar teléfono',
        subtitle: 'Tu número es usado para contactarte y para iniciar sesión.',
        currentLabel: 'Teléfono actual',
        currentValue: '+57 315 888 4422',
        currentIcon: FontAwesomeIcons.phoneFlip,
        inputLabel1: 'Nuevo número de teléfono',
        inputHint1: '+57 300 000 0000',
        inputIcon1: FontAwesomeIcons.phoneFlip,
        inputLabel2: 'Confirmar nuevo número',
        inputHint2: '+57 300 000 0000',
        inputIcon2: FontAwesomeIcons.solidCircleCheck,
        infoText: 'Se requerirá confirmación vía SMS.',
        submitText: 'Guardar cambios',
        submitIcon: FontAwesomeIcons.solidFloppyDisk,
      ),
    );
  }

  static void showCambiarContrasena(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CambioPasswordSection(),
    );
  }

  static void showEditarUbicacion(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EditarPerfilForm(
        title: 'Ubicación del negocio',
        subtitle: 'Dirección donde operas y recibes domicilios.',
        currentLabel: 'Dirección actual',
        currentValue: 'Barrio El Prado, Barranquilla',
        currentIcon: FontAwesomeIcons.locationDot,
        inputLabel1: 'Dirección',
        inputHint1: 'Cll 72 #45-12',
        inputIcon1: FontAwesomeIcons.locationDot,
        inputLabel2: 'Punto de referencia',
        inputHint2: 'Ej: Frente al Parque Bolívar',
        inputIcon2: FontAwesomeIcons.circleInfo,
        infoText: 'Esta dirección será visible para tus repartidores.',
        submitText: 'Guardar ubicación',
        submitIcon: FontAwesomeIcons.locationDot,
      ),
    );
  }

  static void showEditarNegocio(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EditarNegocioSection(),
    );
  }

  static void showWhatsappBusiness(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const WhatsappBusinessSection(),
    );
  }
}
