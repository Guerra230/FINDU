import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';

class ChatMessage {
  const ChatMessage({required this.text, required this.mine});

  final String text;
  final bool mine;
}

class ChatInfo {
  const ChatInfo({required this.post, required this.person, required this.iFoundIt});

  final DemoPost post;
  final String person;
  final bool iFoundIt;

  String get firstName => person.split(' ').first;

  String get context => iFoundIt
      ? 'Encontraste ${post.isPet ? 'a ${post.title}' : (post.feminine ? 'la ${post.title.toLowerCase()}' : 'el ${post.title.toLowerCase()}')} · fotos enviadas'
      : 'Verificaste que es ${post.feminine ? 'tuya' : 'tuyo'} · 3 de 3';

  static ChatInfo of(String? postId) {
    final post = DemoData.post(postId);
    final chat = DemoData.chats.where((c) => c.postId == post.id).firstOrNull;
    return ChatInfo(
      post: post,
      person: chat?.person ?? post.author,
      iFoundIt: post.intent == PostIntent.lost,
    );
  }

  String _g(String stem) => '$stem${post.feminine ? 'a' : 'o'}';

  List<ChatMessage> get messages {
    if (iFoundIt) {
      return [
        ChatMessage(
          text: post.isPet
              ? '¡Es ${post.title}! Muchas gracias. ¿Está bien?'
              : '¡Sí, es ${post.feminine ? 'mía' : 'mío'}! Muchas gracias.',
          mine: false,
        ),
        ChatMessage(
          text: post.isPet
              ? 'Sí, está un poco ${_g('asustad')} pero ${_g('tranquil')}. Ya le di agua.'
              : 'Está en buen estado, ${post.feminine ? 'la' : 'lo'} tengo guardad${post.feminine ? 'a' : 'o'}.',
          mine: true,
        ),
        ChatMessage(
          text: post.id == 'luna' ? '¿Podemos vernos en el CAI del Valle del Lili?' : '¿Podemos vernos cerca de ${post.place}?',
          mine: false,
        ),
      ];
    }
    return [
      ChatMessage(text: '¡Hola! Sí, yo ${post.feminine ? 'la' : 'lo'} tengo guardad${post.feminine ? 'a' : 'o'}.', mine: false),
      const ChatMessage(text: '¡Gracias! ¿Dónde nos vemos?', mine: true),
      ChatMessage(
        text: post.id == 'mochila' ? '¿Te sirve en la entrada de la biblioteca a las 3 p. m.?' : '¿Te sirve en ${post.place} a las 3 p. m.?',
        mine: false,
      ),
    ];
  }
}
