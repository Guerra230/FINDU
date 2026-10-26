abstract final class AppRoutes {
  static const login = '/';
  static const registerStudent = '/registro/universitario';
  static const chooseUniversity = '/registro/universidad';
  static const registerCitizen = '/registro/ciudadano';
  static const forgotPassword = '/recuperar';
  static const recoveryCode = '/recuperar/codigo';
  static const newPassword = '/recuperar/nueva';

  static const main = '/app';

  static const map = '/mapa';
  static const notifications = '/notificaciones';
  static const alertSettings = '/notificaciones/ajustes';

  static const publishObject = '/publicar/objeto';
  static const publishPet = '/publicar/mascota';
  static const published = '/publicar/listo';
  static const shareReport = '/publicar/compartir';
  static const boost = '/impulsar';
  static const boostActive = '/impulsar/activo';

  static const postDetail = '/publicacion';

  static const verificationIntro = '/verificacion';
  static const verificationQuestion = '/verificacion/pregunta';
  static const verificationApproved = '/verificacion/aprobada';
  static const verificationFailed = '/verificacion/fallida';
  static const foundReport = '/hallazgo';

  static const chat = '/chat';
  static const deliveryProblem = '/entrega/problema';
  static const problemSent = '/entrega/problema/enviado';
  static const deliveryVerified = '/entrega/verificada';

  static const communities = '/comunidades';
  static const joinCommunity = '/comunidades/unirse';
  static const joinPending = '/comunidades/unirse/pendiente';
  static const createCommunity = '/comunidades/crear';
  static const createSent = '/comunidades/crear/enviada';
  static const adminPanel = '/comunidades/admin';

  static const paymentMethods = '/perfil/pagos';

  static const devMenu = '/dev';
  static const designSystem = '/dev/design-system';
}

abstract final class AppTabs {
  static const home = 0;
  static const explore = 1;
  static const chats = 2;
  static const profile = 3;
}
