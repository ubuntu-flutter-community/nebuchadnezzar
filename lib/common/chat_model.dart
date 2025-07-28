import 'dart:async';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'rooms_filter.dart';

class ChatModel extends SafeChangeNotifier {
  ChatModel({required Client client}) : _client = client;

  // The matrix dart SDK client
  final Client _client;

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

  Stream<List<User>> getTypingUsersStream(Room room) =>
      getJoinedRoomUpdate(room.id)
          .where((u) => u?.ephemeral?.any((e) => e.type == 'm.typing') ?? false)
          .map(
            (u) => room.typingUsers
                .where((e) => e.senderId != _client.userID)
                .toList(),
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

  Room? _selectedRoom;
  Room? get selectedRoom => _selectedRoom;
  void setSelectedRoom(Room? value) {
    _selectedRoom = value;
    notifyListeners();
  }

  bool _archiveActive = false;
  bool get archiveActive => _archiveActive;
  Future<void> toggleArchive() async {
    _archiveActive = !_archiveActive;
    if (_archiveActive) {
      await _client.loadArchive();
    } else {
      await Future.value();
    }
    setSelectedRoom(null);
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
