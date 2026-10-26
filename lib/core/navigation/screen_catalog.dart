import 'package:findu/core/navigation/app_routes.dart';

class ScreenInfo {
  const ScreenInfo({
    required this.figma,
    required this.title,
    required this.route,
    required this.group,
    this.tab,
  });

  final String figma;
  final String title;
  final String route;
  final String group;
  final int? tab;
}

abstract final class ScreenGroups {
  static const access = 'Acceso · feature/acceso';
  static const home = 'Inicio y explorar · feature/inicio-explorar';
  static const publish = 'Publicar · feature/publicar';
  static const verification = 'Verificación y chat · feature/verificacion-chat';
  static const communities = 'Comunidades y perfil · feature/comunidades-perfil';
}

const screenCatalog = <ScreenInfo>[
  ScreenInfo(figma: '01', title: 'Login', route: AppRoutes.login, group: ScreenGroups.access),
  ScreenInfo(figma: '02', title: 'Registro universitario', route: AppRoutes.registerStudent, group: ScreenGroups.access),
  ScreenInfo(figma: '03', title: 'Elige tu universidad', route: AppRoutes.chooseUniversity, group: ScreenGroups.access),
  ScreenInfo(figma: '04', title: 'Registro ciudadano', route: AppRoutes.registerCitizen, group: ScreenGroups.access),
  ScreenInfo(figma: '05', title: 'Recuperar contraseña', route: AppRoutes.forgotPassword, group: ScreenGroups.access),
  ScreenInfo(figma: '06', title: 'Código de recuperación', route: AppRoutes.recoveryCode, group: ScreenGroups.access),
  ScreenInfo(figma: '07', title: 'Nueva contraseña', route: AppRoutes.newPassword, group: ScreenGroups.access),
  ScreenInfo(figma: '08', title: 'Inicio', route: AppRoutes.main, group: ScreenGroups.home, tab: AppTabs.home),
  ScreenInfo(figma: '09', title: 'Explorar', route: AppRoutes.main, group: ScreenGroups.home, tab: AppTabs.explore),
  ScreenInfo(figma: '10', title: 'Mapa', route: AppRoutes.map, group: ScreenGroups.home),
  ScreenInfo(figma: '11', title: 'Notificaciones', route: AppRoutes.notifications, group: ScreenGroups.home),
  ScreenInfo(figma: '12', title: 'Configurar alertas', route: AppRoutes.alertSettings, group: ScreenGroups.home),
  ScreenInfo(figma: '13', title: 'Publicar objeto', route: AppRoutes.publishObject, group: ScreenGroups.publish),
  ScreenInfo(figma: '14', title: 'Reportar mascota', route: AppRoutes.publishPet, group: ScreenGroups.publish),
  ScreenInfo(figma: '15', title: 'Publicación lista', route: AppRoutes.published, group: ScreenGroups.publish),
  ScreenInfo(figma: '16', title: 'Compartir reporte', route: AppRoutes.shareReport, group: ScreenGroups.publish),
  ScreenInfo(figma: '17', title: 'Impulsar publicación', route: AppRoutes.boost, group: ScreenGroups.publish),
  ScreenInfo(figma: '18', title: 'Impulso activo', route: AppRoutes.boostActive, group: ScreenGroups.publish),
  ScreenInfo(figma: '19', title: 'Detalle de publicación', route: AppRoutes.postDetail, group: ScreenGroups.publish),
  ScreenInfo(figma: '20', title: 'Verificación', route: AppRoutes.verificationIntro, group: ScreenGroups.verification),
  ScreenInfo(figma: '21', title: 'Pregunta de verificación', route: AppRoutes.verificationQuestion, group: ScreenGroups.verification),
  ScreenInfo(figma: '22', title: 'Verificación aprobada', route: AppRoutes.verificationApproved, group: ScreenGroups.verification),
  ScreenInfo(figma: '23', title: 'Verificación fallida', route: AppRoutes.verificationFailed, group: ScreenGroups.verification),
  ScreenInfo(figma: '24', title: 'Encontré a… (reporte)', route: AppRoutes.foundReport, group: ScreenGroups.verification),
  ScreenInfo(figma: '25', title: 'Chats', route: AppRoutes.main, group: ScreenGroups.verification, tab: AppTabs.chats),
  ScreenInfo(figma: '26 · S1', title: 'Chat y confirmar entrega', route: AppRoutes.chat, group: ScreenGroups.verification),
  ScreenInfo(figma: '27', title: 'Hubo un problema', route: AppRoutes.deliveryProblem, group: ScreenGroups.verification),
  ScreenInfo(figma: '28', title: 'Reporte enviado', route: AppRoutes.problemSent, group: ScreenGroups.verification),
  ScreenInfo(figma: '29', title: 'Entrega verificada', route: AppRoutes.deliveryVerified, group: ScreenGroups.verification),
  ScreenInfo(figma: '30', title: 'Mis comunidades', route: AppRoutes.communities, group: ScreenGroups.communities),
  ScreenInfo(figma: '31', title: 'Unirse a comunidad', route: AppRoutes.joinCommunity, group: ScreenGroups.communities),
  ScreenInfo(figma: '32', title: 'Solicitud pendiente', route: AppRoutes.joinPending, group: ScreenGroups.communities),
  ScreenInfo(figma: '33', title: 'Crear comunidad', route: AppRoutes.createCommunity, group: ScreenGroups.communities),
  ScreenInfo(figma: '34', title: 'Solicitud enviada', route: AppRoutes.createSent, group: ScreenGroups.communities),
  ScreenInfo(figma: '35', title: 'Panel de administración', route: AppRoutes.adminPanel, group: ScreenGroups.communities),
  ScreenInfo(figma: '36', title: 'Perfil', route: AppRoutes.main, group: ScreenGroups.communities, tab: AppTabs.profile),
  ScreenInfo(figma: '37', title: 'Métodos de pago', route: AppRoutes.paymentMethods, group: ScreenGroups.communities),
];
