import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'logging.dart';
import 'rooms_filter.dart';

class ChatModel extends SafeChangeNotifier {
  ChatModel({
    required Client client,
  }) : _client = client;

  // The matrix dart SDK client
  final Client _client;
  String? get myUserId => _client.userID;

  String? get homeServerId => _client.homeserver?.host;
  bool isUserEvent(Event event) => myUserId == event.senderId;

  // Room management
  /// The list of all rooms the user is participating or invited.
  List<Room> get _rooms => _client.rooms;

  /// The list of the archived rooms, call loadArchive() before first call
  List<Room> get _archivedRooms => _client.archivedRooms
      .map((e) => e.room)
      .where(
        (e) =>
            _filteredRoomsQuery == null || _filteredRoomsQuery!.trim().isEmpty
                ? true
                : e
                    .getLocalizedDisplayname()
                    .toLowerCase()
                    .contains(_filteredRoomsQuery!.toLowerCase()),
      )
      .toList();

  String? _filteredRoomsQuery;
  String? get filteredRoomsQuery => _filteredRoomsQuery;
  void setFilteredRoomsQuery(String? value) {
    if (value == _filteredRoomsQuery) return;
    _filteredRoomsQuery = value;
    notifyListeners();
  }

  List<Room> get filteredRooms {
    final theRooms = (archiveActive ? _archivedRooms : _rooms)
        .where(roomsFilter?.filter ?? (e) => true)
        .toList();
    if (roomsFilter != RoomsFilter.spaces) {
      return theRooms.where((r) => !r.isSpace).toList();
    }

    if (activeSpace == null) {
      return [];
    }

    return Set<Room>.from(
      activeSpace!.spaceChildren
          .where((r) => r.roomId != null)
          .map((r) => _client.getRoomById(r.roomId!))
          .whereNot((r) => r == null)
          .where((r) => r!.isArchived == archiveActive),
    ).toList();
  }

  // Streams derived from the client onSync stream
  /// The unfiltered onSync stream of the [Client]
  Stream<SyncUpdate> get syncStream => _client.onSync.stream;

  Stream<List<Receipt>> getRoomsReceiptsStream(Event event) =>
      getJoinedRoomUpdate(event.room.id).map((_) => event.receipts);

  Stream<List<User>> getUsersStreamOfJoinedRoom(
    Room room, {
    List<Membership> membershipFilter = const [
      Membership.join,
      Membership.invite,
      Membership.knock,
    ],
  }) =>
      syncStream.asyncMap((_) => room.requestParticipants(membershipFilter));

  /// A stream of [LeftRoomUpdate]s for a specific `roomId`
  Stream<LeftRoomUpdate?> getLeftRoomStream(String roomId) =>
      _client.onSync.stream
          .where((e) => e.rooms?.leave?.isNotEmpty ?? false)
          .map((s) => s.rooms?.leave?[roomId]);

  Stream<SyncUpdate> get joinedUpdateStream =>
      _client.onSync.stream.where((e) => e.rooms?.join?.isNotEmpty ?? false);

  Stream<SyncUpdate> get inviteUpdateStream =>
      _client.onSync.stream.where((e) => e.rooms?.invite?.isNotEmpty ?? false);

  Stream<JoinedRoomUpdate?> getJoinedRoomUpdate(String? roomId) =>
      joinedUpdateStream.map((e) => e.rooms?.join?[roomId]);

  Stream<Uri?> getJoinedRoomAvatarStream(Room? room) =>
      getJoinedRoomUpdate(room?.id)
          .map(
            (e) => e?.ephemeral
                ?.firstWhereOrNull((e) => e.type == EventTypes.RoomAvatar),
          )
          .map((e) => room?.avatar);

  Stream<bool?> getJoinedRoomEncryptedStream(Room? room) =>
      getJoinedRoomUpdate(room?.id)
          .map(
            (e) => e?.ephemeral
                ?.firstWhereOrNull((e) => e.type == EventTypes.Encrypted),
          )
          .map((e) => room?.encrypted);

  Stream<List<User>> getTypingUsersStream(Room room) =>
      getJoinedRoomUpdate(room.id)
          .where(
            (u) => u?.ephemeral?.any((e) => e.type == 'm.typing') ?? false,
          )
          .map(
            (u) =>
                room.typingUsers.where((e) => e.senderId != myUserId).toList(),
          );

  Stream<Event> get notificationStream => _client.onNotification.stream;

  Stream<Event?> getLastEventStream(Room room) =>
      getJoinedRoomUpdate(room.id).map((update) => room.lastEvent);

  Stream<List<Room>> get spacesStream =>
      syncStream.map((e) => _rooms.where((e) => e.isSpace).toList());

  Stream<Map<String, Object?>> getPermissionsStream(Room room) => syncStream
      .where(
        (e) =>
            (e.rooms?.join?.containsKey(room.id) ?? false) &&
            (e.rooms!.join![room.id]?.timeline?.events
                    ?.any((s) => s.type == EventTypes.RoomPowerLevels) ??
                false),
      )
      .map(
        (event) => room.getState(EventTypes.RoomPowerLevels)?.content ?? {},
      );

  Stream<Event> getEventStream(Room room) =>
      _client.onTimelineEvent.stream.where((e) => e.room.id == room.id);

  Stream<Event> getHistoryStream(Room room) =>
      _client.onHistoryEvent.stream.where((e) => e.room.id == room.id);

  void editPowerLevel({
    required Room room,
    required String key,
    int? newLevel,
    String? category,
    required Function() onFail,
    required Future<int?> Function() onCustomPermissionsChosen,
  }) async {
    if (!room.canSendEvent(EventTypes.RoomPowerLevels)) {
      onFail();
      return;
    }
    newLevel ??= await onCustomPermissionsChosen();

    if (newLevel == null) return;
    final content = Map<String, dynamic>.from(
      room.getState(EventTypes.RoomPowerLevels)!.content,
    );
    if (category != null) {
      if (!content.containsKey(category)) {
        content[category] = <String, dynamic>{};
      }
      content[category][key] = newLevel;
    } else {
      content[key] = newLevel;
    }
    await room.client.setRoomStateWithKey(
      room.id,
      EventTypes.RoomPowerLevels,
      '',
      content,
    );
  }

  List<Room> get spaces => _rooms.where((e) => e.isSpace).toList();

  RoomsFilter? _roomsFilter;
  RoomsFilter? get roomsFilter => _roomsFilter;
  void setRoomsFilter(RoomsFilter? value) {
    if (_roomsFilter == value) {
      _roomsFilter = null;
    } else {
      _roomsFilter = value;
    }
    setSelectedRoom(null);
  }

  Room? _activeSpace;
  Room? get activeSpace => _activeSpace;
  void setActiveSpace(Room? roomId) {
    if (_activeSpace == roomId) {
      _activeSpace = null;
    } else {
      _activeSpace = roomId;
    }
    notifyListeners();
  }

  final Map<String, String> _roomIdsToEventContextIds = {};
  String? getEventContextId(String? roomId) =>
      roomId == null ? null : _roomIdsToEventContextIds[roomId];
  void setContextEventId({
    required String roomId,
    required String contextEventId,
  }) {
    _roomIdsToEventContextIds.update(
      roomId,
      (value) => contextEventId,
      ifAbsent: () => contextEventId,
    );
    notifyListeners();
  }

  bool _processingJoinOrLeave = false;
  bool get processingJoinOrLeave => _processingJoinOrLeave;
  void _setProcessingJoinOrLeave(bool value) {
    if (value == _processingJoinOrLeave) return;
    _processingJoinOrLeave = value;
    notifyListeners();
  }

  Room? _selectedRoom;
  Room? get selectedRoom => _selectedRoom;
  void setSelectedRoom(Room? value) {
    _selectedRoom = value;
    notifyListeners();
  }

  bool _loadingArchive = false;
  bool get loadingArchive => _loadingArchive;
  _setLoadingArchive(bool value) {
    if (value == _loadingArchive) return;
    _loadingArchive = value;
    notifyListeners();
  }

  bool _archiveActive = false;
  bool get archiveActive => _archiveActive;
  void toggleArchive() {
    setSelectedRoom(null);
    _archiveActive = !_archiveActive;
    if (_archiveActive) {
      _setLoadingArchive(true);
      _client.loadArchive().then((_) => _setLoadingArchive(false));
    } else {
      _setLoadingArchive(false);
    }
    notifyListeners();
  }

  Future<void> joinRoom(
    Room room, {
    required Function(String error) onFail,
    bool clear = false,
    bool select = true,
  }) async {
    if (clear) {
      setSelectedRoom(null);
    }
    if (room.membership != Membership.join) {
      try {
        _setProcessingJoinOrLeave(true);
        await room.join();
        if (room.isDirectChat && !room.encrypted) {
          await room.enableEncryption();
          printMessageInDebugMode('Room encrypted: ${room.encrypted}');
        }
        if (select) {
          setSelectedRoom(room);
        }
      } on Exception catch (e) {
        onFail(e.toString());
        setSelectedRoom(null);
      } finally {
        _setProcessingJoinOrLeave(false);
      }
    } else {
      if (select) {
        setSelectedRoom(room);
      }
    }
  }

  Future<void> createRoom({
    required Function(String error) onFail,
    required Function() onSuccess,
    String? groupName,
    bool enableEncryption = true,
    List<String>? invite,
    CreateRoomPreset preset = CreateRoomPreset.trustedPrivateChat,
    List<StateEvent>? initialState,
    Visibility? visibility,
    HistoryVisibility? historyVisibility,
    bool waitForSync = true,
    bool groupCall = false,
    bool federated = true,
    Map<String, dynamic>? powerLevelContentOverride,
    MatrixFile? avatarFile,
  }) async {
    setSelectedRoom(null);
    _setProcessingJoinOrLeave(true);
    String? roomId;

    try {
      roomId = await _client.createGroupChat(
        groupName: groupName,
        enableEncryption: enableEncryption,
        invite: invite,
        preset: preset,
        initialState: initialState,
        visibility: visibility,
        historyVisibility: historyVisibility,
        waitForSync: waitForSync,
        groupCall: groupCall,
        federated: federated,
        powerLevelContentOverride: powerLevelContentOverride,
      );
    } catch (e, s) {
      onFail(e.toString());
      printMessageInDebugMode(e, s);
    } finally {
      _setProcessingJoinOrLeave(false);
    }
    if (roomId != null) {
      await _client.waitForRoomInSync(roomId, join: true);
      final maybeRoom = _client.getRoomById(roomId);
      if (maybeRoom != null) {
        setSelectedRoom(maybeRoom);
        if (maybeRoom.canChangeStateEvent(EventTypes.RoomAvatar) &&
            avatarFile?.bytes != null) {
          await maybeRoom.setAvatar(avatarFile);
        }
        _archiveActive = false;

        onSuccess();
      }
    }
  }

  Future<String?> createSpace({
    required String name,
    Visibility visibility = Visibility.public,
    List<String>? invite,
    List<Invite3pid>? invite3pid,
    String? roomVersion,
    String? topic,
    bool waitForSync = true,
    String? spaceAliasName,
    required Function(String error) onFail,
    required Function() onSuccess,
  }) async {
    _setProcessingJoinOrLeave(true);
    String? spaceRoomId;
    try {
      printMessageInDebugMode('Creating space...');
      spaceRoomId = await _client.createSpace(
        name: name,
        visibility: visibility,
        invite: invite,
        invite3pid: invite3pid,
        roomVersion: roomVersion,
        topic: topic,
        waitForSync: waitForSync,
        spaceAliasName: spaceAliasName,
      );
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      onFail(e.toString());
    }
    if (spaceRoomId != null) {
      final space = _client.getRoomById(spaceRoomId);
      if (space != null) {
        onSuccess();
        setSelectedRoom(space);
      }
    }
    _setProcessingJoinOrLeave(false);
    return spaceRoomId;
  }

  Future<void> joinDirectChat(
    String userId, {
    required Function(String error) onFail,
  }) async {
    _setProcessingJoinOrLeave(true);

    Room? maybeRoom = _rooms.where((e) => !e.isArchived).firstWhereOrNull(
          (e) =>
              e.isDirectChat &&
              e.getParticipants().any((e) => e.id == myUserId) &&
              e.getParticipants().any((e) => e.id == userId),
        );

    if (maybeRoom == null) {
      String? maybeId;
      try {
        maybeId = await _client.startDirectChat(
          userId,
          preset: CreateRoomPreset.privateChat,
        );
      } on Exception catch (e) {
        onFail(e.toString());
      }

      if (maybeId != null) {
        maybeRoom = Room(id: maybeId, client: _client);
      }
    }

    if (maybeRoom != null) {
      try {
        await joinRoom(maybeRoom, onFail: onFail);
      } on Exception catch (e) {
        onFail(e.toString());
      } finally {
        _setProcessingJoinOrLeave(false);
      }
    }

    _setProcessingJoinOrLeave(false);
  }

  Future<void> joinAndSelectRoomByChunk(
    PublicRoomsChunk chunk, {
    required Function(String error) onFail,
  }) async {
    _setProcessingJoinOrLeave(true);

    final knock = chunk.joinRule == 'knock';

    String? roomId;
    try {
      if (_client.getRoomById(chunk.roomId) != null) {
        roomId = chunk.roomId;
      }
      roomId = knock
          ? await _client.knockRoom(chunk.roomId)
          : await _client.joinRoom(chunk.roomId);

      if (!knock && _client.getRoomById(roomId) == null) {
        await _client.waitForRoomInSync(roomId);
      }
    } on Exception catch (e) {
      onFail(e.toString());
    } finally {
      if (roomId != null) {
        final room = _client.getRoomById(roomId);
        if (room != null && !room.isSpace) {
          setSelectedRoom(room);
        }
      }
      _setProcessingJoinOrLeave(false);
    }
  }

  Future<void> leaveSelectedRoom({
    required Function(String error) onFail,
    Room? room,
    bool forget = false,
  }) async {
    _setProcessingJoinOrLeave(true);
    try {
      await (room ?? _selectedRoom)?.leave();
      if (forget) {
        await (room ?? _selectedRoom)?.forget();
      }
      if (room == activeSpace) {
        setActiveSpace(null);
      }
    } on Exception catch (e) {
      onFail(e.toString());
    } finally {
      setSelectedRoom(null);
      _setProcessingJoinOrLeave(false);
    }
  }

  Future<void> initAfterEncryptionSetup() async {
    await _client.roomsLoading;
    await _client.userDeviceKeysLoading;
    await _client.firstSyncReceived;
  }
}
