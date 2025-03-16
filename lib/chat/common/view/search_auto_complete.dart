import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/snackbars.dart';
import '../../../common/view/ui_constants.dart';

import '../chat_model.dart';
import '../search_model.dart';
import 'chat_avatar.dart';

class ChatUserSearchAutoComplete extends StatelessWidget with WatchItMixin {
  const ChatUserSearchAutoComplete({
    super.key,
    required this.suffix,
    this.onProfileSelected,
    this.width,
    this.labelText,
  });

  final Widget suffix;
  final void Function(Profile)? onProfileSelected;
  final double? width;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    final model = di<ChatModel>();
    final theme = context.theme;

    final processingJoinOrLeave =
        watchPropertyValue((ChatModel m) => m.processingJoinOrLeave);

    return Autocomplete<Profile>(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) =>
              TextField(
        enabled: !processingJoinOrLeave,
        decoration: InputDecoration(
          hintText: labelText ?? '${context.l10n.search} ${context.l10n.users}',
          label:
              Text(labelText ?? '${context.l10n.search} ${context.l10n.users}'),
          suffixIcon: suffix,
        ),
        controller: textEditingController,
        onSubmitted: (value) => onFieldSubmitted(),
        focusNode: focusNode,
        autofocus: true,
      ),
      onSelected: (option) {
        if (onProfileSelected != null) {
          onProfileSelected!(option);
        } else {
          model.joinDirectChat(
            option.userId,
            onFail: (error) => showSnackBar(context, content: Text(error)),
          );
        }
      },
      displayStringForOption: (profile) =>
          profile.displayName ?? profile.userId,
      optionsBuilder: (textEditingValue) async =>
          await di<SearchModel>().findUserProfiles(
            textEditingValue.text,
            onFail: () => showSnackBar(
              context,
              // TODO: localize
              content: const Text(
                'User search not available',
              ),
            ),
          ) ??
          <Profile>[],
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width ?? 220,
          height: (options.length * 50) > 400 ? 400 : options.length * 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Material(
              color: theme.popupMenuTheme.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
              elevation: 1,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return Builder(
                    builder: (BuildContext context) {
                      final bool highlight = AutocompleteHighlightedOption.of(
                            context,
                          ) ==
                          index;
                      if (highlight) {
                        SchedulerBinding.instance
                            .addPostFrameCallback((Duration timeStamp) {
                          Scrollable.ensureVisible(
                            context,
                            alignment: 0.5,
                          );
                        });
                      }
                      final t = options.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: kSmallPadding),
                        child: ListTile(
                          key: ValueKey(t.userId),
                          leading: ChatAvatar(avatarUri: t.avatarUrl),
                          title: Text(
                            t.displayName ?? t.userId,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            t.userId,
                            maxLines: 1,
                          ),
                          onTap: () => onSelected(t),
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

class RoomsAutoComplete extends StatelessWidget with WatchItMixin {
  const RoomsAutoComplete({super.key, required this.suffix});

  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    final model = di<ChatModel>();
    final theme = context.theme;

    final processingJoinOrLeave =
        watchPropertyValue((ChatModel m) => m.processingJoinOrLeave);

    final searchType = watchPropertyValue((SearchModel m) => m.searchType);
    final label =
        '${context.l10n.search} ${searchType == SearchType.spaces ? context.l10n.spaces : context.l10n.publicRooms}';

    return Autocomplete<PublicRoomsChunk>(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          enabled: !processingJoinOrLeave,
          decoration: InputDecoration(
            hintText: label,
            label: Text(label),
            suffixIcon: suffix,
          ),
          controller: textEditingController,
          onSubmitted: (value) => onFieldSubmitted(),
          focusNode: focusNode,
          autofocus: true,
        );
      },
      onSelected: (option) => model.joinAndSelectRoomByChunk(
        option,
        onFail: (error) => showSnackBar(context, content: Text(error)),
      ),
      displayStringForOption: (chunk) => chunk.name ?? chunk.roomId,
      optionsBuilder: (textEditingValue) =>
          di<SearchModel>().findPublicRoomChunks(
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
                side: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
              elevation: 1,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return Builder(
                    builder: (BuildContext context) {
                      final bool highlight = AutocompleteHighlightedOption.of(
                            context,
                          ) ==
                          index;
                      if (highlight) {
                        SchedulerBinding.instance
                            .addPostFrameCallback((Duration timeStamp) {
                          Scrollable.ensureVisible(
                            context,
                            alignment: 0.5,
                          );
                        });
                      }
                      final chunk = options.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: kSmallPadding),
                        child: ListTile(
                          key: ValueKey(chunk.roomId),
                          leading: ChatAvatar(
                            avatarUri: chunk.avatarUrl,
                          ),
                          title: Text(
                            chunk.name ?? chunk.roomId,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            chunk.canonicalAlias ?? chunk.roomId,
                            maxLines: 1,
                          ),
                          onTap: () => model.joinAndSelectRoomByChunk(
                            chunk,
                            onFail: (error) =>
                                showSnackBar(context, content: Text(error)),
                          ),
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
