import 'package:matrix/matrix.dart';

class CreateRoomDraft {
  const CreateRoomDraft({
    required this.name,
    required this.topic,
    required this.enableEncryption,
    required this.createRoomPreset,
    required this.visibility,
    required this.historyVisibility,
    required this.profiles,
    required this.avatar,
    required this.groupCall,
  });

  CreateRoomDraft.empty()
    : name = '',
      topic = '',
      enableEncryption = true,
      createRoomPreset = CreateRoomPreset.publicChat,
      visibility = Visibility.public,
      historyVisibility = HistoryVisibility.shared,
      profiles = const {},
      avatar = null,
      groupCall = false;

  final String name;
  final String topic;
  final bool enableEncryption;
  final CreateRoomPreset createRoomPreset;
  final Visibility visibility;
  final HistoryVisibility historyVisibility;
  final Set<Profile> profiles;
  final MatrixImageFile? avatar;
  final bool groupCall;

  CreateRoomDraft copyWith({
    String? name,
    String? topic,
    bool? enableEncryption,
    CreateRoomPreset? createRoomPreset,
    Visibility? visibility,
    HistoryVisibility? historyVisibility,
    Set<Profile>? profiles,
    MatrixImageFile? avatar,
    bool? groupCall,
  }) {
    return CreateRoomDraft(
      name: name ?? this.name,
      topic: topic ?? this.topic,
      enableEncryption: enableEncryption ?? this.enableEncryption,
      createRoomPreset: createRoomPreset ?? this.createRoomPreset,
      visibility: visibility ?? this.visibility,
      historyVisibility: historyVisibility ?? this.historyVisibility,
      profiles: profiles ?? this.profiles,
      avatar: avatar ?? this.avatar,
      groupCall: groupCall ?? this.groupCall,
    );
  }

  @override
  String toString() {
    return 'CreateRoomDraft(name: $name, topic: $topic, enableEncryption: $enableEncryption, createRoomPreset: $createRoomPreset, visibility: $visibility, historyVisibility: $historyVisibility, profiles: $profiles, avatar: $avatar, groupCall: $groupCall)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateRoomDraft &&
        other.name == name &&
        other.topic == topic &&
        other.enableEncryption == enableEncryption &&
        other.createRoomPreset == createRoomPreset &&
        other.visibility == visibility &&
        other.historyVisibility == historyVisibility &&
        other.profiles == profiles &&
        other.avatar == avatar &&
        other.groupCall == groupCall;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        topic.hashCode ^
        enableEncryption.hashCode ^
        createRoomPreset.hashCode ^
        visibility.hashCode ^
        historyVisibility.hashCode ^
        profiles.hashCode ^
        avatar.hashCode ^
        groupCall.hashCode;
  }
}
