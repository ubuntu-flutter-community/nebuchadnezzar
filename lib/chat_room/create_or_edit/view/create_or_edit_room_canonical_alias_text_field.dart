import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../authentication/authentication_model.dart';
import '../../../common/room_x.dart';
import '../../../common/view/build_context_x.dart';
import '../../../common/view/theme.dart';
import '../../../l10n/l10n.dart';
import '../create_or_edit_room_model.dart';

class CreateOrEditRoomCanonicalAliasTextField extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const CreateOrEditRoomCanonicalAliasTextField({
    super.key,
    required this.room,
    required this.isSpace,
  });
  final Room room;
  final bool isSpace;
  @override
  State<CreateOrEditRoomCanonicalAliasTextField> createState() =>
      _CreateOrEditRoomCanonicalAliasTextFieldState();
}

class _CreateOrEditRoomCanonicalAliasTextFieldState
    extends State<CreateOrEditRoomCanonicalAliasTextField> {
  late final TextEditingController _aliasController;
  late final String _initialText;

  @override
  void initState() {
    super.initState();
    _aliasController = TextEditingController(text: widget.room.canonicalAlias);
    _initialText = _aliasController.text;
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final enabledAliasField =
        watchStream(
          (CreateOrEditRoomModel m) =>
              m.getCanChangeCanonicalAliasStream(widget.room),
          initialValue: widget.room.canChangeCanonicalAlias,
          preserveState: false,
        ).data ??
        false;

    final l10n = context.l10n;
    final roomAlias =
        watchStream(
          (CreateOrEditRoomModel m) =>
              m.getJoinedRoomCanonicalAliasStream(widget.room),
          initialValue: widget.room.canonicalAlias,
          preserveState: false,
        ).data ??
        widget.room.canonicalAlias;
    final homeServer = watchPropertyValue(
      (AuthenticationModel m) => m.homeServerName,
    );

    return Form(
      key: formKey,
      child: ListenableBuilder(
        listenable: _aliasController,
        builder: (context, _) {
          final aliasIsSynced = _aliasController.text == roomAlias;
          final draftWasChanged = _initialText != _aliasController.text;
          return TextFormField(
            onChanged: (value) {
              formKey.currentState?.validate();
            },

            validator: (value) {
              final regex = RegExp(
                '^#([a-zA-Z0-9_\\-\\.]+):${RegExp.escape(homeServer!)}\$',
              );
              if (value == null || value.isEmpty) {
                return null;
              } else if (!regex.hasMatch(value)) {
                // TODO: Localize this error message
                return 'Invalid input, must match #SOMETHING:$homeServer';
              } else if (value == widget.room.canonicalAlias) {
                return null;
              }
              return null;
            },
            controller: _aliasController,
            autofocus: true,
            enabled: enabledAliasField,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              label: Text(l10n.alias),
              helper: aliasIsSynced
                  ? null
                  : Text(
                      // TODO: Localize this helper text
                      'Example: #${widget.room.name.toLowerCase()}:${homeServer?.toLowerCase()}',
                    ),
              suffixIcon: enabledAliasField
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      style: textFieldSuffixStyle,
                      onPressed: aliasIsSynced
                          ? null
                          : () => showFutureLoadingDialog(
                              context: context,
                              onError: (e) {
                                _aliasController.clear();
                                return e.toString();
                              },
                              future: () => di<CreateOrEditRoomModel>()
                                  .changeRoomCanonicalAlias(
                                    widget.room,
                                    _aliasController.text,
                                  ),
                            ),
                      icon: aliasIsSynced
                          ? YaruAnimatedVectorIcon(
                              YaruAnimatedIcons.ok_filled,
                              color: draftWasChanged
                                  ? context.colorScheme.success
                                  : null,
                            )
                          : const Icon(YaruIcons.save),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
