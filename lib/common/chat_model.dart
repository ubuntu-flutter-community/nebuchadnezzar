import 'dart:async';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'logging.dart';
import 'rooms_filter.dart';

class ChatModel extends SafeChangeNotifier {
  ChatModel({required Client client}) : _client = client;

  // The matrix dart SDK client
  final Client _client;
  String? get myUserId => _client.userID;

  String? get homeServerId => _client.homeserver?.host;

  // Room management
  /// The list of all rooms the user is participating or invited.
  List<Room> get _rooms => _client.rooms;

  /// The list of the archived rooms, call loadArchive() before first call
  List<Room> get _archivedRooms =>
      _client.archivedRooms.map((e) => e.room).toList();

  Room? getRoomById(String? roomId) =>
      roomId == null ? null : _client.getRoomById(roomId);

  String? _filteredRoomsQuery;
  String? get filteredRoomsQuery => _filteredRoomsQuery;
  void setFilteredRoomsQuery(String? value) {
    if (value == _filteredRoomsQuery) return;
    _filteredRoomsQuery = value;
    notifyListeners();
  }

  List<Room> get _activeOrArchivedRoomsOrSpaces {
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

  List<Room> get filteredRooms => _activeOrArchivedRoomsOrSpaces
      .where(
        (e) =>
            _filteredRoomsQuery == null || _filteredRoomsQuery!.trim().isEmpty
            ? true
            : e.getLocalizedDisplayname().toLowerCase().contains(
                _filteredRoomsQuery!.toLowerCase(),
              ),
      )
      .toList();

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
  }) => syncStream.asyncMap((_) => room.requestParticipants(membershipFilter));

  /// A stream of [LeftRoomUpdate]s for a specific `roomId`
  Stream<LeftRoomUpdate?> getLeftRoomStream(String roomId) => _client
      .onSync
      .stream
      .where((e) => e.rooms?.leave?.isNotEmpty ?? false)
      .map((s) => s.rooms?.leave?[roomId]);

  Stream<SyncUpdate> get joinedUpdateStream =>
      _client.onSync.stream.where((e) => e.rooms?.join?.isNotEmpty ?? false);

  Stream<JoinedRoomUpdate?> getJoinedRoomUpdate(String? roomId) =>
      joinedUpdateStream.map((e) => e.rooms?.join?[roomId]);

  Stream<Uri?> getJoinedRoomAvatarStream(Room? room) =>
      getJoinedRoomUpdate(room?.id)
          .map(
            (e) => e?.ephemeral?.firstWhereOrNull(
              (e) => e.type == EventTypes.RoomAvatar,
            ),
          )
          .map((e) => room?.avatar);

  Stream<bool?> getJoinedRoomEncryptedStream(Room? room) =>
      getJoinedRoomUpdate(room?.id)
          .map(
            (e) => e?.ephemeral?.firstWhereOrNull(
              (e) => e.type == EventTypes.Encrypted,
            ),
          )
          .map((e) => room?.encrypted);

  Stream<List<User>> getTypingUsersStream(Room room) =>
      getJoinedRoomUpdate(room.id)
          .where((u) => u?.ephemeral?.any((e) => e.type == 'm.typing') ?? false)
          .map(
            (u) =>
                room.typingUsers.where((e) => e.senderId != myUserId).toList(),
          );

  Stream<Event> get notificationStream => _client.onNotification.stream;

  Stream<Event?> getLastEventStream(Room room) =>
      getJoinedRoomUpdate(room.id).map((joinedRoomUpdate) => room.lastEvent);

  Stream<List<Room>> get spacesStream =>
      syncStream.map((e) => _rooms.where((e) => e.isSpace).toList());

  Stream<Event> getEventStream(Room room) =>
      _client.onTimelineEvent.stream.where((e) => e.room.id == room.id);

  Stream<Event> getHistoryStream(Room room) =>
      _client.onHistoryEvent.stream.where((e) => e.room.id == room.id);

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

  Room? _selectedRoom;
  Room? get selectedRoom => _selectedRoom;
  void setSelectedRoom(Room? value) {
    _selectedRoom = value;
    notifyListeners();
  }

  bool _loadingArchive = false;
  bool get loadingArchive => _loadingArchive;
  void _setLoadingArchive(bool value) {
    if (value == _loadingArchive) return;
    _loadingArchive = value;
    notifyListeners();
  }

  bool _archiveActive = false;
  bool get archiveActive => _archiveActive;
  void setArchiveActive(bool value) {
    if (value == _archiveActive) return;
    _archiveActive = value;
    notifyListeners();
  }

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

  Future<Room> joinRoom(Room room) async {
    if (room.membership != Membership.join) {
      try {
        await room.join();
        if (room.isDirectChat && !room.encrypted) {
          await room.enableEncryption();
          printMessageInDebugMode('Room encrypted: ${room.encrypted}');
        }
      } on Exception catch (e, s) {
        printMessageInDebugMode(e, s);
        rethrow;
      }
    }

    return room;
  }

  Future<void> addToSpace(Room room, Room space) async {
    if (room.isSpace) {
      throw Exception('Cannot add a space to itself.');
    }

    try {
      await space.setSpaceChild(room.id);
      notifyListeners();
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<void> removeFromSpace(Room room, Room space) async {
    if (room.isSpace) {
      throw Exception('Cannot remove a space from itself.');
    }

    try {
      await space.removeSpaceChild(room.id);
      notifyListeners();
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<Room?> createRoomOrSpace({
    String? groupName,
    bool enableEncryption = true,
    List<String>? invite,
    List<StateEvent>? initialState,
    required JoinRules joinRules,
    HistoryVisibility? historyVisibility,
    bool waitForSync = true,
    bool groupCall = false,
    bool federated = true,
    Map<String, dynamic>? powerLevelContentOverride,
    MatrixFile? avatarFile,
    bool space = false,
    List<Invite3pid>? spaceInvite3pid,
    String? spaceRoomVersion,
    String? spaceTopic,
    String? spaceAliasName,
  }) async {
    String? roomId;
    try {
      roomId = space
          ? await _client.createSpace(
              name: groupName,
              visibility: joinRules == JoinRules.private
                  ? Visibility.private
                  : Visibility.public,
              invite: invite,
              invite3pid: spaceInvite3pid,
              roomVersion: spaceRoomVersion,
              topic: spaceTopic,
              waitForSync: waitForSync,
              spaceAliasName: spaceAliasName,
            )
          : await _client.createGroupChat(
              groupName: groupName,
              enableEncryption: enableEncryption,
              invite: invite,
              initialState: initialState,
              visibility: joinRules == JoinRules.private
                  ? Visibility.private
                  : Visibility.public,

              historyVisibility: historyVisibility,
              waitForSync: waitForSync,
              groupCall: groupCall,
              federated: federated,
              powerLevelContentOverride: powerLevelContentOverride,
            );
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }

    final maybeRoom = _client.getRoomById(roomId);
    if (maybeRoom != null) {
      if (maybeRoom.canChangeStateEvent(EventTypes.RoomAvatar) &&
          avatarFile?.bytes != null) {
        try {
          await maybeRoom.setAvatar(avatarFile);
        } on Exception catch (e, s) {
          printMessageInDebugMode(e, s);
        }
      }
      if (maybeRoom.isDirectChat && !maybeRoom.encrypted) {
        try {
          await maybeRoom.enableEncryption();
          printMessageInDebugMode('Room encrypted: ${maybeRoom.encrypted}');
        } on Exception catch (e, s) {
          printMessageInDebugMode(e, s);
          rethrow;
        }
      }
    }

    return maybeRoom;
  }

  Future<Room?> startOrGetDirectChat(String userId) async {
    final maybeDirectChatId = _client.getDirectChatFromUserId(userId);
    Room? maybeRoom;
    if (maybeDirectChatId != null) {
      maybeRoom = _client.getRoomById(maybeDirectChatId);
    }

    if (maybeRoom == null) {
      String? maybeId;
      try {
        maybeId = await _client.startDirectChat(
          userId,
          preset: CreateRoomPreset.privateChat,
        );
      } on Exception catch (e) {
        printMessageInDebugMode(e);
        rethrow;
      }

      maybeRoom = _client.getRoomById(maybeId);
    }

    return maybeRoom;
  }

  Future<Room?> knockOrJoinRoomChunk(PublicRoomsChunk chunk) async {
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
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }

    return _client.getRoomById(roomId);
  }

  Future<void> leaveRoom({required Room room, required bool forget}) async {
    try {
      await Future.wait([
        if (forget) room.forget() else room.leave(),
        if (forget) _client.oneShotSync(),
      ]);
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future initAfterEncryptionSetup() async => Future.wait<Future<dynamic>?>(
    Iterable.castFrom(<Future<dynamic>?>[
      _client.roomsLoading,
      _client.accountDataLoading,
      _client.userDeviceKeysLoading,
      _client.firstSyncReceived,
    ]),
  );
}
