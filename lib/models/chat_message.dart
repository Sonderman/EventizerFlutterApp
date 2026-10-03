/// Sohbet mesaj modelleri.
///
/// JSON şeması, Firestore'da kayıtlı mevcut mesajlarla uyumludur
/// (eski `dash_chat_2` paketinin ürettiği format: `user`, `createdAt`
/// ISO8601 UTC, `text`, `medias[].url/type/fileName`). Eski kayıtlardan
/// okuma ve yeni kayıt yazma aynı model ile yapılır.
library;

/// Sohbet mesajı.
class ChatMessage {
  ChatMessage({
    required this.user,
    required this.createdAt,
    this.text = '',
    this.medias,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> jsonData) {
    return ChatMessage(
      user: ChatUser.fromJson(jsonData['user'] as Map<String, dynamic>),
      createdAt: DateTime.parse(jsonData['createdAt'].toString()).toLocal(),
      text: jsonData['text']?.toString() ?? '',
      medias: jsonData['medias'] != null
          ? (jsonData['medias'] as List<dynamic>)
              .map((dynamic media) =>
                  ChatMedia.fromJson(media as Map<String, dynamic>))
              .toList()
          : <ChatMedia>[],
    );
  }

  /// Mesaj metni (yalnızca görsel içeriyorsa boş olabilir).
  String text;

  /// Mesajı gönderen kişi.
  ChatUser user;

  /// Görsel/video ekleri.
  List<ChatMedia>? medias;

  /// Gönderim zamanı.
  DateTime createdAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user': user.toJson(),
      'createdAt': createdAt.toUtc().toIso8601String(),
      'text': text,
      'medias': medias?.map((ChatMedia media) => media.toJson()).toList(),
    };
  }
}

/// Mesaj gönderen kullanıcı bilgisi.
class ChatUser {
  ChatUser({
    required this.id,
    this.profileImage,
    this.firstName,
    this.lastName,
  });

  factory ChatUser.fromJson(Map<String, dynamic> jsonData) {
    return ChatUser(
      id: jsonData['id'].toString(),
      profileImage: jsonData['profileImage']?.toString(),
      firstName: jsonData['firstName']?.toString(),
      lastName: jsonData['lastName']?.toString(),
    );
  }

  String id;

  String? profileImage;

  String? firstName;

  String? lastName;

  /// Tam ad (firstName + lastName).
  String getFullName() {
    return (firstName ?? '') +
        (firstName != null && lastName != null
            ? ' ${lastName!}'
            : lastName ?? '');
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'profileImage': profileImage,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}

/// Mesaj içindeki görsel/video eki.
class ChatMedia {
  ChatMedia({
    required this.url,
    required this.fileName,
    required this.type,
  });

  factory ChatMedia.fromJson(Map<String, dynamic> jsonData) {
    return ChatMedia(
      url: jsonData['url'].toString(),
      fileName: jsonData['fileName']?.toString() ?? '',
      type: MediaType.parse(jsonData['type'].toString()),
    );
  }

  /// Dosyanın (genellikle Storage) URL'si.
  String url;

  String fileName;

  MediaType type;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'url': url,
      'type': type.toString(),
      'fileName': fileName,
    };
  }
}

/// Ek türü.
enum MediaType {
  image,
  video,
  file;

  static MediaType parse(String value) {
    switch (value) {
      case 'image':
        return MediaType.image;
      case 'video':
        return MediaType.video;
      case 'file':
        return MediaType.file;
      default:
        return MediaType.image;
    }
  }
}