import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

import '../../chat_room/create_or_edit/edit_room_manager.dart';
import '../../l10n/l10n.dart';
import '../search_manager.dart';
import 'build_context_x.dart';
import 'chat_avatar.dart';
import 'snackbars.dart';
import 'ui_constants.dart';

class ChatRoomsAndSpacesAutoComplete extends StatelessWidget with WatchItMixin {
  const ChatRoomsAndSpacesAutoComplete({super.key, required this.suffix});

  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final searchType = watchPropertyValue((SearchManager m) => m.searchType);
    final label =
        '${context.l10n.search} ${searchType == SearchType.spaces ? context.l10n.spaces : context.l10n.publicRooms}';

    return Autocomplete<PublishedRoomsChunk>(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) =>
              TextField(
                decoration: InputDecoration(
                  hintText: label,
                  label: Text(label),
                  suffixIcon: suffix,
                ),
                controller: textEditingController,
                onSubmitted: (value) => onFieldSubmitted(),
                focusNode: focusNode,
                autofocus: true,
              ),
      onSelected: (option) {
        Navigator.of(context).pop();
        di<EditRoomManager>().knockOrJoinCommand.run(option);
      },
      displayStringForOption: (chunk) => chunk.name ?? chunk.roomId,

      optionsBuilder: (textEditingValue) =>
          di<SearchManager>().findPublicRoomChunks(
            textEditingValue.text,
            onFail: (error) => showSnackBar(context, content: Text(error)),
          ),
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 220,
          height: (options.length * 50) > 400 ? 400 : options.length * 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Material(
              color: theme.popupMenuTheme.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: theme.dividerColor, width: 1),
              ),
              elevation: 1,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return Builder(
                    builder: (BuildContext context) {
                      final bool highlight =
                          AutocompleteHighlightedOption.of(context) == index;
                      if (highlight) {
                        SchedulerBinding.instance.addPostFrameCallback((
                          Duration timeStamp,
                        ) {
                          Scrollable.ensureVisible(context, alignment: 0.5);
                        });
                      }
                      final chunk = options.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: kSmallPadding),
                        child: ListTile(
                          key: ValueKey(chunk.roomId),
                          leading: ChatAvatar(avatarUri: chunk.avatarUrl),
                          title: Text(chunk.name ?? chunk.roomId, maxLines: 1),
                          subtitle: Text(
                            chunk.canonicalAlias ?? chunk.roomId,
                            maxLines: 1,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            di<EditRoomManager>().knockOrJoinCommand.run(chunk);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
