import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:slugify/slugify.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/chat_avatar.dart';
import '../../../common/view/ui_constants.dart';
import '../../common/view/chat_typing_indicator.dart';
import '../draft_manager.dart';
import 'chat_attachment_draft_panel.dart';
import 'chat_input_reply_box.dart';
import 'chat_input_text_field.dart';

class ChatInput extends StatefulWidget with WatchItStatefulWidgetMixin {
  const ChatInput({super.key, required this.room});

  final Room room;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  late final TextEditingController _sendController = TextEditingController(
    text: di<DraftManager>().getTextDraft(widget.room.id),
  );

  late final focusNode = FocusNode(
    onKeyEvent: (node, event) {
      final enterPressedWithoutShift =
          event is KeyDownEvent &&
          event.physicalKey == PhysicalKeyboardKey.enter &&
          !HardwareKeyboard.instance.physicalKeysPressed.any(
            (key) => <PhysicalKeyboardKey>{
              PhysicalKeyboardKey.shiftLeft,
              PhysicalKeyboardKey.shiftRight,
            }.contains(key),
          );

      var getSuggestions = _getSuggestions(_sendController.value);
      final suggestionsAreNotEmpty = getSuggestions.isNotEmpty;

      if (enterPressedWithoutShift && event is KeyRepeatEvent) {
        // Disable holding enter
        return KeyEventResult.handled;
      } else if (enterPressedWithoutShift && suggestionsAreNotEmpty) {
        final suggestion = getSuggestions.first;
        _insertSuggestionIntoInput(suggestion);
        return KeyEventResult.handled;
      } else if (enterPressedWithoutShift) {
        send();
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );

  @override
  void initState() {
    super.initState();
    final cursorPosition = di<DraftManager>().getCursorPosition(widget.room.id);
    if (cursorPosition != null &&
        cursorPosition <= _sendController.text.length) {
      _sendController.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition),
      );
    }
  }

  @override
  void dispose() {
    di<DraftManager>()
      ..setTextDraft(
        roomId: widget.room.id,
        draft: _sendController.text,
        notify: false,
      )
      ..setCursorPosition(
        roomId: widget.room.id,
        position: _sendController.selection.baseOffset,
      );

    _sendController.dispose();
    super.dispose();
  }

  void send() {
    if (di<DraftManager>().getFilesDraft(widget.room.id).isNotEmpty) {
      di<DraftManager>().sendCommand.runAsync(widget.room).then((_) {
        _sendController.clear();
      });
    } else {
      _sendController.clear();
      di<DraftManager>().sendCommand.run(widget.room);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChatAttachmentDraftPanel(roomId: widget.room.id),
              ChatInputReplyBox(room: widget.room),
              const Divider(height: 1),
              Autocomplete<Map<String, String?>>(
                optionsViewOpenDirection: OptionsViewOpenDirection.up,
                optionsBuilder: _getSuggestions,
                textEditingController: _sendController,
                focusNode: focusNode,
                displayStringForOption: _insertSuggestion,
                optionsViewBuilder: (c, onSelected, s) {
                  final suggestions = s.toList();

                  return Padding(
                    padding: const EdgeInsets.only(
                      left: kMediumPadding,
                      right: kMediumPadding,
                    ),
                    child: Material(
                      elevation: 4,
                      shadowColor: context.theme.appBarTheme.shadowColor,
                      borderRadius: BorderRadius.circular(kYaruButtonRadius),
                      clipBehavior: Clip.hardEdge,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: suggestions.length,
                        itemBuilder: (context, i) => _suggestionTileBuilder(
                          context: c,
                          suggestion: suggestions[i],
                          onSelected: onSelected,
                          isHighlighted: i == suggestions.length - 1,
                        ),
                      ),
                    ),
                  );
                },
                onSelected: (suggestion) {
                  _insertSuggestionIntoInput(suggestion);
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) =>
                        ChatInputTextField(
                          room: widget.room,
                          sendController: controller,
                          sendNode: focusNode,
                          send: send,
                        ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -kTypingAvatarSize - kSmallPadding,
          child: ChatTypingIndicator(room: widget.room),
        ),
      ],
    );
  }

  void _insertSuggestionIntoInput(Map<String, String?> suggestion) {
    final newText = _insertSuggestion(suggestion);
    _sendController.text = newText;
    _sendController.selection = TextSelection.fromPosition(
      TextPosition(offset: newText.length),
    );
    di<DraftManager>().setTextDraft(
      roomId: widget.room.id,
      draft: newText,
      notify: true,
    );
  }

  List<Map<String, String?>> _getSuggestions(TextEditingValue text) {
    if (text.selection.baseOffset != text.selection.extentOffset ||
        text.selection.baseOffset < 0) {
      return [];
    }
    final searchText = text.text.substring(0, text.selection.baseOffset);
    final ret = <Map<String, String?>>[];
    const maxResults = 30;

    final userMatch = RegExp(r'(?:\s|^)@([-\w]+)$').firstMatch(searchText);
    if (userMatch != null) {
      final userSearch = userMatch[1]!.toLowerCase();
      for (final user in widget.room.getParticipants()) {
        if ((user.displayName != null &&
                (user.displayName!.toLowerCase().contains(userSearch) ||
                    slugify(
                      user.displayName!.toLowerCase(),
                    ).contains(userSearch))) ||
            user.id.split(':')[0].toLowerCase().contains(userSearch)) {
          ret.add({
            'type': 'user',
            'mxid': user.id,
            'mention': user.mention,
            'displayname': user.displayName,
            'avatar_url': user.avatarUrl?.toString(),
          });
        }
        if (ret.length > maxResults) {
          break;
        }
      }
    }
    final roomMatch = RegExp(r'(?:\s|^)#([-\w]+)$').firstMatch(searchText);
    if (roomMatch != null) {
      final roomSearch = roomMatch[1]!.toLowerCase();
      for (final r in widget.room.client.rooms) {
        if (r.getState(EventTypes.RoomTombstone) != null) {
          continue;
        }
        final state = r.getState(EventTypes.RoomCanonicalAlias);
        if ((state != null &&
                ((state.content['alias'] is String &&
                        state.content
                            .tryGet<String>('alias')!
                            .split(':')[0]
                            .toLowerCase()
                            .contains(roomSearch)) ||
                    (state.content['alt_aliases'] is List &&
                        (state.content['alt_aliases'] as List).any(
                          (l) =>
                              l is String &&
                              l
                                  .split(':')[0]
                                  .toLowerCase()
                                  .contains(roomSearch),
                        )))) ||
            (r.name.toLowerCase().contains(roomSearch))) {
          ret.add({
            'type': 'room',
            'mxid': (r.canonicalAlias.isNotEmpty) ? r.canonicalAlias : r.id,
            'displayname': r.getLocalizedDisplayname(),
            'avatar_url': r.avatar?.toString(),
          });
        }
        if (ret.length > maxResults) {
          break;
        }
      }
    }
    return ret;
  }

  Widget _suggestionTileBuilder({
    required BuildContext context,
    required Map<String, String?> suggestion,
    required void Function(Map<String, String?>) onSelected,
    required bool isHighlighted,
  }) {
    const size = 30.0;

    if (suggestion['type'] == 'user' || suggestion['type'] == 'room') {
      final url = Uri.parse(suggestion['avatar_url'] ?? '');
      return ListTile(
        shape: const RoundedRectangleBorder(),
        selected: isHighlighted,
        selectedColor: context.theme.colorScheme.primary,
        onTap: () => onSelected(suggestion),
        leading: ChatAvatar(avatarUri: url, dimension: size),
        title: Text(suggestion['displayname'] ?? suggestion['mxid']!),
      );
    }
    return const SizedBox.shrink();
  }

  String _insertSuggestion(Map<String, String?> suggestion) {
    final replaceText = _sendController.text.substring(
      0,
      _sendController.selection.baseOffset,
    );
    var startText = '';
    final afterText = replaceText == _sendController.text
        ? ''
        : _sendController.text.substring(
            _sendController.selection.baseOffset + 1,
          );
    var insertText = '';

    if (suggestion['type'] == 'user') {
      insertText = '${suggestion['mention']!} ';
      startText = replaceText.replaceAllMapped(
        RegExp(r'(\s|^)(@[-\w]+)$'),
        (Match m) => '${m[1]}$insertText',
      );
    }
    if (suggestion['type'] == 'room') {
      insertText = '${suggestion['mxid']!} ';
      startText = replaceText.replaceAllMapped(
        RegExp(r'(\s|^)(#[-\w]+)$'),
        (Match m) => '${m[1]}$insertText',
      );
    }

    return startText + afterText;
  }
}
