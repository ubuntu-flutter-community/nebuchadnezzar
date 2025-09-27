import 'dart:async';

import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'logging.dart';

class SearchManager extends SafeChangeNotifier {
  SearchManager({required Client client}) : _client = client;

  final Client _client;

  @override
  Future<void> dispose() async {
    _debounce?.cancel();
    super.dispose();
  }

  Future<Profile> lookupProfile(String userId) async =>
      _client.getProfileFromUserId(userId);

  bool _searchActive = false;
  bool get searchActive => _searchActive;
  void toggleSearch({bool? value}) {
    _searchActive = value ?? !_searchActive;
    notifyListeners();
  }

  SearchType _searchType = SearchType.profiles;
  SearchType get searchType => _searchType;
  void setSearchType(SearchType value) {
    if (_searchType == value) return;
    _searchType = value;
    notifyListeners();
  }

  bool _spaceSearchVisible = true;
  bool get spaceSearchVisible => _spaceSearchVisible;
  void setSpaceSearchVisible({required bool value}) {
    _spaceSearchVisible = value;
    notifyListeners();
  }

  List<SpaceRoomsChunk>? _spaceSearch = [];
  List<SpaceRoomsChunk>? get spaceSearch => _spaceSearch;
  void resetSpaceSearch() {
    _spaceSearch = [];
    notifyListeners();
  }

  Future<void> searchSpaces(
    Room room, {
    required Function(String error) onFail,
  }) async {
    setSpaceSearchVisible(value: true);
    String? nextBatch;
    _spaceSearch = null;
    notifyListeners();
    try {
      final hierarchy = await _client.getSpaceHierarchy(
        room.id,
        suggestedOnly: false,
        maxDepth: 2,
        from: nextBatch,
      );
      nextBatch = hierarchy.nextBatch;
      _spaceSearch = hierarchy.rooms
          .where((c) => room.client.getRoomById(c.roomId) == null)
          .toList();
    } on Exception catch (e) {
      onFail(e.toString());
    }

    notifyListeners();
  }

  Timer? _debounce;

  Future<List<Profile>?> findUserProfiles(
    String searchQuery, {
    required Function() onFail,
  }) async {
    SearchUserDirectoryResponse? searchUserDirectoryResponse;
    try {
      searchUserDirectoryResponse = await _client.searchUserDirectory(
        searchQuery,
      );
    } on Exception catch (e, s) {
      onFail();
      printMessageInDebugMode(e, s);
    }

    return searchUserDirectoryResponse?.results;
  }

  Future<List<PublicRoomsChunk>> findPublicRoomChunks(
    String searchQuery, {
    required Function(String error) onFail,
  }) async {
    QueryPublicRoomsResponse? roomSearchResult;
    try {
      roomSearchResult = await _client.queryPublicRooms(
        filter: PublicRoomQueryFilter(genericSearchTerm: searchQuery),
        limit: 20,
        includeAllNetworks: true,
      );

      if (searchQuery.isValidMatrixId &&
          searchQuery.sigil == '#' &&
          roomSearchResult.chunk.any(
                (room) => room.canonicalAlias == searchQuery,
              ) ==
              false) {
        final response = await _client.getRoomIdByAlias(searchQuery);
        final roomId = response.roomId;
        if (roomId != null) {
          roomSearchResult.chunk.add(
            PublicRoomsChunk(
              avatarUrl: _client.getRoomById(roomId)?.avatar,
              name: searchQuery,
              guestCanJoin: false,
              numJoinedMembers: 0,
              roomId: roomId,
              worldReadable: true,
              canonicalAlias: searchQuery,
            ),
          );
        }
      }
    } catch (e, s) {
      onFail(e.toString());
      printMessageInDebugMode(e, s);
    }

    return (roomSearchResult?.chunk ?? [])
        .where(
          (r) =>
              searchType == SearchType.spaces ? r.roomType == 'm.space' : true,
        )
        .toList();
  }
}

enum SearchType { profiles, rooms, spaces }
