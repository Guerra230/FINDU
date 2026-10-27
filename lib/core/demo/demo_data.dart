enum PostKind { object, pet }

enum PostIntent { lost, found }

class DemoUser {
  const DemoUser({required this.name, required this.university, required this.program});

  final String name;
  final String? university;
  final String program;
}

class DemoPost {
  const DemoPost({
    required this.id,
    required this.title,
    required this.kind,
    required this.intent,
    required this.category,
    required this.place,
    required this.ago,
    required this.author,
    this.reward,
    this.questions = const [],
  });

  final String id;
  final String title;
  final PostKind kind;
  final PostIntent intent;
  final String category;
  final String place;
  final String ago;
  final String author;
  final int? reward;
  final List<String> questions;
}

class DemoCommunity {
  const DemoCommunity({required this.name, required this.type, required this.members, required this.isAdmin});

  final String name;
  final String type;
  final int members;
  final bool isAdmin;
}

class DemoChat {
  const DemoChat({required this.postId, required this.person, required this.lastMessage, required this.time, this.unread = false});

  final String postId;
  final String person;
  final String lastMessage;
  final String time;
  final bool unread;
}

class DemoNotification {
  const DemoNotification({required this.title, required this.body, required this.time, this.postId, this.unread = false});

  final String title;
  final String body;
  final String time;
  final String? postId;
  final bool unread;
}

class DemoBoostPlan {
  const DemoBoostPlan({required this.name, required this.price, required this.radiusKm, required this.people, required this.hours});

  final String name;
  final int price;
  final int radiusKm;
  final int people;
  final int hours;
}

abstract final class DemoData {
  static const me = DemoUser(name: 'Daniela Melo', university: 'Universidad Icesi', program: 'Química farmacéutica');

  static const universities = [
    'Universidad Icesi',
    'Pontificia Universidad Javeriana',
    'Universidad del Valle',
    'Universidad Autónoma de Occidente',
    'Universidad San Buenaventura',
  ];

  static const posts = <DemoPost>[
    DemoPost(id: 'luna', title: 'Luna', kind: PostKind.pet, intent: PostIntent.lost, category: 'Gato', place: 'Ciudad Pacífica', ago: 'hace 1 h', author: 'Laura Gómez', reward: 500000),
    DemoPost(id: 'mateo', title: 'Mateo', kind: PostKind.pet, intent: PostIntent.lost, category: 'Perro', place: 'Bochalema', ago: 'hace 3 h', author: 'David Ricaurte', reward: 100000),
    DemoPost(id: 'mochila', title: 'Mochila Kipling rosa', kind: PostKind.object, intent: PostIntent.found, category: 'Mochila', place: 'Universidad Icesi', ago: 'hace 2 h', author: 'Laura Gómez', questions: ['¿Qué tiene la mochila adentro?', '¿Cuántos cuadernos hay?', '¿Qué llavero tiene?']),
    DemoPost(id: 'billetera', title: 'Billetera negra', kind: PostKind.object, intent: PostIntent.found, category: 'Billetera', place: 'Edificio M, Icesi', ago: 'hace 1 h', author: 'Laura Gómez', questions: ['¿Qué tarjetas tiene?', '¿Tiene cédula?', '¿Hay fotos adentro?']),
    DemoPost(id: 'termo', title: 'Termo', kind: PostKind.object, intent: PostIntent.found, category: 'Termo', place: 'Biblioteca Icesi', ago: 'hace 3 días', author: 'Andrés M.', questions: ['¿Qué dibujo tiene el termo?', '¿De qué color es la tapa?', '¿Tiene algún sticker o marca?']),
    DemoPost(id: 'cartuchera', title: 'Cartuchera', kind: PostKind.object, intent: PostIntent.found, category: 'Cartuchera', place: 'Salón 103D, Icesi', ago: 'hace 6 h', author: 'Sofía R.', questions: ['¿Qué hay dentro de la cartuchera?', '¿De qué color es la cremallera?', '¿Tiene algún llavero?']),
    DemoPost(id: 'xiaomi', title: 'Celular Xiaomi', kind: PostKind.object, intent: PostIntent.lost, category: 'Celular', place: 'Biblioteca, Icesi', ago: 'hace 3 h', author: 'Valentina P.'),
    DemoPost(id: 'parlante', title: 'Parlante', kind: PostKind.object, intent: PostIntent.lost, category: 'Parlante', place: 'Pance, Cali', ago: 'hace 1 h', author: 'Luis F.'),
    DemoPost(id: 'alaska', title: 'Alaska', kind: PostKind.pet, intent: PostIntent.found, category: 'Perro', place: 'Ciudad Pacífica', ago: 'hace 9 h', author: 'Camila V.', questions: ['¿Qué color tiene su collar?', '¿Qué dice su placa?', '¿Tiene alguna marca en el pelaje?']),
    DemoPost(id: 'titi', title: 'Titi', kind: PostKind.pet, intent: PostIntent.lost, category: 'Perro', place: 'Granada, Cali', ago: 'hace 30 min', author: 'Luis F.'),
    DemoPost(id: 'mochila-negra', title: 'Mochila negra', kind: PostKind.object, intent: PostIntent.lost, category: 'Mochila', place: 'Central, Icesi', ago: 'hace 2 h', author: 'Daniela Melo'),
    DemoPost(id: 'canelita', title: 'Canelita', kind: PostKind.pet, intent: PostIntent.found, category: 'Perro', place: 'Caney, Cali', ago: 'hace 1 h', author: 'Daniela Melo', questions: ['¿Qué color tiene su collar?', '¿Responde a algún apodo?', '¿Tiene alguna cicatriz o mancha?']),
  ];

  static DemoPost post(String? id) => posts.firstWhere((p) => p.id == id, orElse: () => posts.first);

  static const communities = <DemoCommunity>[
    DemoCommunity(name: 'Universidad Icesi', type: 'Educativa', members: 1500, isAdmin: false),
    DemoCommunity(name: 'Conjunto Bosques de Lili', type: 'Residencial', members: 124, isAdmin: true),
  ];

  static const accessCode = 'LILI-4821';

  static const chats = <DemoChat>[
    DemoChat(postId: 'luna', person: 'Laura Gómez', lastMessage: '¿Podemos vernos en el CAI del Valle del Lili?', time: '2 min', unread: true),
    DemoChat(postId: 'mateo', person: 'David Ricaurte', lastMessage: '¡Es Mateo! Muchas gracias.', time: '1 h'),
    DemoChat(postId: 'mochila', person: 'Laura Gómez', lastMessage: '¿Te sirve en la entrada de la biblioteca?', time: 'Ayer'),
  ];

  static const notifications = <DemoNotification>[
    DemoNotification(title: 'Nuevo avistamiento de Luna', body: 'Alguien la vio en Ciudad Pacífica, cerca al parque.', time: '1 h', postId: 'luna', unread: true),
    DemoNotification(title: '¡Verificación aprobada!', body: 'Laura G. confirmó que la mochila es tuya.', time: '3 h', postId: 'mochila', unread: true),
    DemoNotification(title: 'Objeto parecido al tuyo', body: 'Encontraron una billetera negra en el Edificio M.', time: '5 h', postId: 'billetera'),
    DemoNotification(title: 'Recompensa liberada', body: 'Se transfirieron \$500.000 a Juliana R. por encontrar a Luna.', time: 'Lun', postId: 'luna'),
  ];

  static const boostPlans = <DemoBoostPlan>[
    DemoBoostPlan(name: 'Básico', price: 5000, radiusKm: 3, people: 200, hours: 24),
    DemoBoostPlan(name: 'Destacado', price: 8000, radiusKm: 8, people: 1200, hours: 72),
  ];
}
