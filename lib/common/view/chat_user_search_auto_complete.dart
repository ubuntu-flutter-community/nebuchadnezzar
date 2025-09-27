import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../chat_room/create_or_edit/create_room_manager.dart';
import '../../l10n/l10n.dart';
import '../chat_manager.dart';
import '../search_manager.dart';
import 'build_context_x.dart';
import 'chat_avatar.dart';
import 'snackbars.dart';
import 'ui_constants.dart';

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
    final theme = context.theme;

    return Autocomplete<Profile>(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) =>
              TextField(
                decoration: InputDecoration(
                  hintText:
                      labelText ??
                      '${context.l10n.search} ${context.l10n.users}',
                  label: Text(
                    labelText ?? '${context.l10n.search} ${context.l10n.users}',
                  ),
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
          showFutureLoadingDialog(
            context: context,
            future: () =>
                di<CreateRoomManager>().createOrGetDirectChat(option.userId),
          ).then((result) {
            if (result.asValue?.value != null) {
              di<ChatManager>().setSelectedRoom(result.asValue!.value!);
            }
          });
        }
      },
      displayStringForOption: (profile) =>
          profile.displayName ?? profile.userId,
      optionsBuilder: (textEditingValue) async =>
          await di<SearchManager>().findUserProfiles(
            textEditingValue.text,
            onFail: () => showSnackBar(
              context,
              content: Text(context.l10n.oopsSomethingWentWrong),
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
                      final t = options.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: kSmallPadding),
                        child: ListTile(
                          key: ValueKey(t.userId),
                          leading: ChatAvatar(avatarUri: t.avatarUrl),
                          title: Text(t.displayName ?? t.userId, maxLines: 1),
                          subtitle: Text(t.userId, maxLines: 1),
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
