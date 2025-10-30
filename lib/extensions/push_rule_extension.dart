// ignore_for_file: use_build_context_synchronously

import 'package:matrix/matrix.dart';

import '../l10n/app_localizations.dart';

extension PushRuleExtension on PushRule {
  String getPushRuleName(AppLocalizations l10n) => switch (ruleId) {
    '.m.rule.contains_user_name' => l10n.notificationRuleContainsUserName,
    '.m.rule.master' => l10n.notificationRuleMaster,
    '.m.rule.suppress_notices' => l10n.notificationRuleSuppressNotices,
    '.m.rule.invite_for_me' => l10n.notificationRuleInviteForMe,
    '.m.rule.member_event' => l10n.notificationRuleMemberEvent,
    '.m.rule.is_user_mention' => l10n.notificationRuleIsUserMention,
    '.m.rule.contains_display_name' => l10n.notificationRuleContainsDisplayName,
    '.m.rule.is_room_mention' => l10n.notificationRuleIsRoomMention,
    '.m.rule.roomnotif' => l10n.notificationRuleRoomnotif,
    '.m.rule.tombstone' => l10n.notificationRuleTombstone,
    '.m.rule.reaction' => l10n.notificationRuleReaction,
    '.m.rule.room_server_acl' => l10n.notificationRuleRoomServerAcl,
    '.m.rule.suppress_edits' => l10n.notificationRuleSuppressEdits,
    '.m.rule.call' => l10n.notificationRuleCall,
    '.m.rule.encrypted_room_one_to_one' =>
      l10n.notificationRuleEncryptedRoomOneToOne,
    '.m.rule.room_one_to_one' => l10n.notificationRuleRoomOneToOne,
    '.m.rule.message' => l10n.notificationRuleMessage,
    '.m.rule.encrypted' => l10n.notificationRuleEncrypted,
    '.m.rule.room.server_acl' => l10n.notificationRuleServerAcl,
    '.im.vector.jitsi' => l10n.notificationRuleJitsi,
    _ => ruleId.split('.').last.replaceAll('_', ' ').capitalize(),
  };

  String getPushRuleDescription(AppLocalizations l10n) => switch (ruleId) {
    '.m.rule.contains_user_name' =>
      l10n.notificationRuleContainsUserNameDescription,
    '.m.rule.master' => l10n.notificationRuleMasterDescription,
    '.m.rule.suppress_notices' =>
      l10n.notificationRuleSuppressNoticesDescription,
    '.m.rule.invite_for_me' => l10n.notificationRuleInviteForMeDescription,
    '.m.rule.member_event' => l10n.notificationRuleMemberEventDescription,
    '.m.rule.is_user_mention' => l10n.notificationRuleIsUserMentionDescription,
    '.m.rule.contains_display_name' =>
      l10n.notificationRuleContainsDisplayNameDescription,
    '.m.rule.is_room_mention' => l10n.notificationRuleIsRoomMentionDescription,
    '.m.rule.roomnotif' => l10n.notificationRuleRoomnotifDescription,
    '.m.rule.tombstone' => l10n.notificationRuleTombstoneDescription,
    '.m.rule.reaction' => l10n.notificationRuleReactionDescription,
    '.m.rule.room_server_acl' => l10n.notificationRuleRoomServerAclDescription,
    '.m.rule.suppress_edits' => l10n.notificationRuleSuppressEditsDescription,
    '.m.rule.call' => l10n.notificationRuleCallDescription,
    '.m.rule.encrypted_room_one_to_one' =>
      l10n.notificationRuleEncryptedRoomOneToOneDescription,
    '.m.rule.room_one_to_one' => l10n.notificationRuleRoomOneToOneDescription,
    '.m.rule.message' => l10n.notificationRuleMessageDescription,
    '.m.rule.encrypted' => l10n.notificationRuleEncryptedDescription,
    '.m.rule.room.server_acl' => l10n.notificationRuleServerAclDescription,
    '.im.vector.jitsi' => l10n.notificationRuleJitsiDescription,
    _ => l10n.unknownPushRule(ruleId),
  };
}

extension PushRuleKindLocal on PushRuleKind {
  String localized(AppLocalizations l10n) => switch (this) {
    PushRuleKind.content => l10n.contentNotificationSettings,
    PushRuleKind.override => l10n.generalNotificationSettings,
    PushRuleKind.room => l10n.roomNotificationSettings,
    PushRuleKind.sender => l10n.userSpecificNotificationSettings,
    PushRuleKind.underride => l10n.otherNotificationSettings,
  };
}

extension on String {
  String capitalize() =>
      '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}
