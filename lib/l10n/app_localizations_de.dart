// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get alwaysUse24HourFormat => 'false';

  @override
  String get repeatPassword => 'Repeat password';

  @override
  String get notAnImage => 'Not an image file.';

  @override
  String get remove => 'Remove';

  @override
  String get importNow => 'Import now';

  @override
  String get importEmojis => 'Import Emojis';

  @override
  String get importFromZipFile => 'Import from .zip file';

  @override
  String get exportEmotePack => 'Export Emote pack as .zip';

  @override
  String get replace => 'Replace';

  @override
  String get about => 'About';

  @override
  String get accept => 'Accept';

  @override
  String acceptedTheInvitation(String username) {
    return '👍 $username accepted the invitation';
  }

  @override
  String get account => 'Account';

  @override
  String activatedEndToEndEncryption(String username) {
    return '🔐 $username activated end to end encryption';
  }

  @override
  String get addEmail => 'Add email';

  @override
  String get confirmMatrixId =>
      'Please confirm your Matrix ID in order to delete your account.';

  @override
  String supposedMxid(String mxid) {
    return 'This should be $mxid';
  }

  @override
  String get addChatDescription => 'Add a chat description...';

  @override
  String get addToSpace => 'Add to space';

  @override
  String get admin => 'Admin';

  @override
  String get alias => 'alias';

  @override
  String get all => 'All';

  @override
  String get allChats => 'All chats';

  @override
  String get commandHint_googly => 'Send some googly eyes';

  @override
  String get commandHint_cuddle => 'Send a cuddle';

  @override
  String get commandHint_hug => 'Send a hug';

  @override
  String googlyEyesContent(String senderName) {
    return '$senderName sends you googly eyes';
  }

  @override
  String cuddleContent(String senderName) {
    return '$senderName cuddles you';
  }

  @override
  String hugContent(String senderName) {
    return '$senderName hugs you';
  }

  @override
  String answeredTheCall(String senderName) {
    return '$senderName answered the call';
  }

  @override
  String get anyoneCanJoin => 'Anyone can join';

  @override
  String get appLock => 'App lock';

  @override
  String get appLockDescription =>
      'Lock the app when not using with a pin code';

  @override
  String get archive => 'Archive';

  @override
  String get areGuestsAllowedToJoin => 'Are guest users allowed to join';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get areYouSureYouWantToLogout => 'Are you sure you want to log out?';

  @override
  String get askSSSSSign =>
      'To be able to sign the other person, please enter your secure store passphrase or recovery key.';

  @override
  String askVerificationRequest(String username) {
    return 'Accept this verification request from $username?';
  }

  @override
  String get autoplayImages =>
      'Automatically play animated stickers and emotes';

  @override
  String badServerLoginTypesException(
    String serverVersions,
    String supportedVersions,
  ) {
    return 'The homeserver supports the login types:\n$serverVersions\nBut this app supports only:\n$supportedVersions';
  }

  @override
  String get sendTypingNotifications => 'Send typing notifications';

  @override
  String get swipeRightToLeftToReply => 'Swipe right to left to reply';

  @override
  String get sendOnEnter => 'Send on enter';

  @override
  String badServerVersionsException(
    String serverVersions,
    String supportedVersions,
  ) {
    return 'The homeserver supports the Spec versions:\n$serverVersions\nBut this app supports only $supportedVersions';
  }

  @override
  String countChatsAndCountParticipants(String chats, Object participants) {
    return '$chats chats and $participants participants';
  }

  @override
  String get noMoreChatsFound => 'No more chats found...';

  @override
  String get noChatsFoundHere =>
      'No chats found here yet. Start a new chat with someone by using the button below. ⤵️';

  @override
  String get joinedChats => 'Joined chats';

  @override
  String get unread => 'Unread';

  @override
  String get space => 'Space';

  @override
  String get spaces => 'Spaces';

  @override
  String get banFromChat => 'Ban from chat';

  @override
  String get banned => 'Banned';

  @override
  String bannedUser(String username, String targetName) {
    return '$username banned $targetName';
  }

  @override
  String get blockDevice => 'Block Device';

  @override
  String get blocked => 'Blocked';

  @override
  String get botMessages => 'Bot messages';

  @override
  String get cancel => 'Cancel';

  @override
  String cantOpenUri(String uri) {
    return 'Can\'t open the URI $uri';
  }

  @override
  String get changeDeviceName => 'Change device name';

  @override
  String changedTheChatAvatar(String username) {
    return '$username changed the chat avatar';
  }

  @override
  String changedTheChatDescriptionTo(String username, String description) {
    return '$username changed the chat description to: \'$description\'';
  }

  @override
  String changedTheChatNameTo(String username, String chatname) {
    return '$username changed the chat name to: \'$chatname\'';
  }

  @override
  String changedTheChatPermissions(String username) {
    return '$username changed the chat permissions';
  }

  @override
  String changedTheDisplaynameTo(String username, String displayname) {
    return '$username changed their displayname to: \'$displayname\'';
  }

  @override
  String changedTheGuestAccessRules(String username) {
    return '$username changed the guest access rules';
  }

  @override
  String changedTheGuestAccessRulesTo(String username, String rules) {
    return '$username changed the guest access rules to: $rules';
  }

  @override
  String changedTheHistoryVisibility(String username) {
    return '$username changed the history visibility';
  }

  @override
  String changedTheHistoryVisibilityTo(String username, String rules) {
    return '$username changed the history visibility to: $rules';
  }

  @override
  String changedTheJoinRules(String username) {
    return '$username changed the join rules';
  }

  @override
  String changedTheJoinRulesTo(String username, String joinRules) {
    return '$username changed the join rules to: $joinRules';
  }

  @override
  String changedTheProfileAvatar(String username) {
    return '$username changed their avatar';
  }

  @override
  String changedTheRoomAliases(String username) {
    return '$username changed the room aliases';
  }

  @override
  String changedTheRoomInvitationLink(String username) {
    return '$username changed the invitation link';
  }

  @override
  String get changePassword => 'Change password';

  @override
  String get changeTheHomeserver => 'Change the homeserver';

  @override
  String get changeTheme => 'Change your style';

  @override
  String get changeTheNameOfTheGroup => 'Change the name of the group';

  @override
  String get changeYourAvatar => 'Change your avatar';

  @override
  String get channelCorruptedDecryptError =>
      'The encryption has been corrupted';

  @override
  String get chat => 'Chat';

  @override
  String get yourChatBackupHasBeenSetUp => 'Your chat backup has been set up.';

  @override
  String get chatBackup => 'Chat backup';

  @override
  String get chatBackupDescription =>
      'Your old messages are secured with a recovery key. Please make sure you don\'t lose it.';

  @override
  String get chatDetails => 'Chat details';

  @override
  String get chatHasBeenAddedToThisSpace => 'Chat has been added to this space';

  @override
  String get chats => 'Chats';

  @override
  String get chooseAStrongPassword => 'Choose a strong password';

  @override
  String get clearArchive => 'Clear archive';

  @override
  String get close => 'Close';

  @override
  String get commandHint_markasdm =>
      'Mark as direct message room for the giving Matrix ID';

  @override
  String get commandHint_markasgroup => 'Mark as group';

  @override
  String get commandHint_ban => 'Ban the given user from this room';

  @override
  String get commandHint_clearcache => 'Clear cache';

  @override
  String get commandHint_create =>
      'Create an empty group chat\nUse --no-encryption to disable encryption';

  @override
  String get commandHint_discardsession => 'Discard session';

  @override
  String get commandHint_dm =>
      'Start a direct chat\nUse --no-encryption to disable encryption';

  @override
  String get commandHint_html => 'Send HTML-formatted text';

  @override
  String get commandHint_invite => 'Invite the given user to this room';

  @override
  String get commandHint_join => 'Join the given room';

  @override
  String get commandHint_kick => 'Remove the given user from this room';

  @override
  String get commandHint_leave => 'Leave this room';

  @override
  String get commandHint_me => 'Describe yourself';

  @override
  String get commandHint_myroomavatar =>
      'Set your picture for this room (by mxc-uri)';

  @override
  String get commandHint_myroomnick => 'Set your display name for this room';

  @override
  String get commandHint_op =>
      'Set the given user\'s power level (default: 50)';

  @override
  String get commandHint_plain => 'Send unformatted text';

  @override
  String get commandHint_react => 'Send reply as a reaction';

  @override
  String get commandHint_send => 'Send text';

  @override
  String get commandHint_unban => 'Unban the given user from this room';

  @override
  String get commandInvalid => 'Command invalid';

  @override
  String commandMissing(String command) {
    return '$command is not a command.';
  }

  @override
  String get compareEmojiMatch => 'Please compare the emojis';

  @override
  String get compareNumbersMatch => 'Please compare the numbers';

  @override
  String get configureChat => 'Configure chat';

  @override
  String get confirm => 'Confirm';

  @override
  String get connect => 'Connect';

  @override
  String get contactHasBeenInvitedToTheGroup =>
      'Contact has been invited to the group';

  @override
  String get containsDisplayName => 'Contains display name';

  @override
  String get containsUserName => 'Contains username';

  @override
  String get contentHasBeenReported =>
      'The content has been reported to the server admins';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get copy => 'Copy';

  @override
  String get copyToClipboard => 'Copy to clipboard';

  @override
  String couldNotDecryptMessage(String error) {
    return 'Could not decrypt message: $error';
  }

  @override
  String countParticipants(int count) {
    return '$count participants';
  }

  @override
  String get create => 'Create';

  @override
  String createdTheChat(String username) {
    return '💬 $username created the chat';
  }

  @override
  String get createGroup => 'Create group';

  @override
  String get createNewSpace => 'New space';

  @override
  String get currentlyActive => 'Currently active';

  @override
  String get darkTheme => 'Dark';

  @override
  String dateAndTimeOfDay(String date, String timeOfDay) {
    return '$date, $timeOfDay';
  }

  @override
  String dateWithoutYear(int month, int day) {
    return '$month-$day';
  }

  @override
  String dateWithYear(int year, int month, int day) {
    return '$year-$month-$day';
  }

  @override
  String get deactivateAccountWarning =>
      'This will deactivate your user account. This can not be undone! Are you sure?';

  @override
  String get defaultPermissionLevel => 'Default permission level for new users';

  @override
  String get delete => 'Delete';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteMessage => 'Delete message';

  @override
  String get device => 'Device';

  @override
  String get deviceId => 'Device ID';

  @override
  String get devices => 'Devices';

  @override
  String get directChats => 'Direct Chats';

  @override
  String get allRooms => 'All Group Chats';

  @override
  String get displaynameHasBeenChanged => 'Displayname has been changed';

  @override
  String get downloadFile => 'Download file';

  @override
  String get edit => 'Edit';

  @override
  String get editBlockedServers => 'Edit blocked servers';

  @override
  String get chatPermissions => 'Chat permissions';

  @override
  String get editDisplayname => 'Edit displayname';

  @override
  String get editRoomAliases => 'Edit room aliases';

  @override
  String get editRoomAvatar => 'Edit room avatar';

  @override
  String get emoteExists => 'Emote already exists!';

  @override
  String get emoteInvalid => 'Invalid emote shortcode!';

  @override
  String get emoteKeyboardNoRecents =>
      'Recently-used emotes will appear here...';

  @override
  String get emotePacks => 'Emote packs for room';

  @override
  String get emoteSettings => 'Emote Settings';

  @override
  String get globalChatId => 'Global chat ID';

  @override
  String get accessAndVisibility => 'Access and visibility';

  @override
  String get accessAndVisibilityDescription =>
      'Who is allowed to join this chat and how the chat can be discovered.';

  @override
  String get calls => 'Calls';

  @override
  String get customEmojisAndStickers => 'Custom emojis and stickers';

  @override
  String get customEmojisAndStickersBody =>
      'Add or share custom emojis or stickers which can be used in any chat.';

  @override
  String get emoteShortcode => 'Emote shortcode';

  @override
  String get emoteWarnNeedToPick =>
      'You need to pick an emote shortcode and an image!';

  @override
  String get emptyChat => 'Empty chat';

  @override
  String get enableEmotesGlobally => 'Enable emote pack globally';

  @override
  String get enableEncryption => 'Enable encryption';

  @override
  String get enableEncryptionWarning =>
      'You won\'t be able to disable the encryption anymore. Are you sure?';

  @override
  String get encrypted => 'Encrypted';

  @override
  String get encryption => 'Encryption';

  @override
  String get encryptionNotEnabled => 'Encryption is not enabled';

  @override
  String endedTheCall(String senderName) {
    return '$senderName ended the call';
  }

  @override
  String get enterAnEmailAddress => 'Enter an email address';

  @override
  String get homeserver => 'Homeserver';

  @override
  String get enterYourHomeserver => 'Enter your homeserver';

  @override
  String errorObtainingLocation(String error) {
    return 'Error obtaining location: $error';
  }

  @override
  String get everythingReady => 'Everything ready!';

  @override
  String get extremeOffensive => 'Extremely offensive';

  @override
  String get fileName => 'File name';

  @override
  String get nebuchadnezzar => 'Nebuchadnezzar';

  @override
  String get fontSize => 'Font size';

  @override
  String get forward => 'Forward';

  @override
  String get fromJoining => 'From joining';

  @override
  String get fromTheInvitation => 'From the invitation';

  @override
  String get goToTheNewRoom => 'Go to the new room';

  @override
  String get group => 'Group';

  @override
  String get chatDescription => 'Chat description';

  @override
  String get chatDescriptionHasBeenChanged => 'Chat description changed';

  @override
  String get groupIsPublic => 'Group is public';

  @override
  String get groups => 'Groups';

  @override
  String groupWith(String displayname) {
    return 'Group with $displayname';
  }

  @override
  String get guestsAreForbidden => 'Guests are forbidden';

  @override
  String get guestsCanJoin => 'Guests can join';

  @override
  String hasWithdrawnTheInvitationFor(String username, String targetName) {
    return '$username has withdrawn the invitation for $targetName';
  }

  @override
  String get help => 'Help';

  @override
  String get hideRedactedEvents => 'Hide redacted events';

  @override
  String get hideRedactedMessages => 'Hide redacted messages';

  @override
  String get hideRedactedMessagesBody =>
      'If someone redacts a message, this message won\'t be visible in the chat anymore.';

  @override
  String get hideInvalidOrUnknownMessageFormats =>
      'Hide invalid or unknown message formats';

  @override
  String get howOffensiveIsThisContent => 'How offensive is this content?';

  @override
  String get id => 'ID';

  @override
  String get identity => 'Identity';

  @override
  String get block => 'Block';

  @override
  String get blockedUsers => 'Blocked users';

  @override
  String get blockListDescription =>
      'You can block users who are disturbing you. You won\'t be able to receive any messages or room invites from the users on your personal block list.';

  @override
  String get blockUsername => 'Ignore username';

  @override
  String get iHaveClickedOnLink => 'I have clicked on the link';

  @override
  String get incorrectPassphraseOrKey => 'Incorrect passphrase or recovery key';

  @override
  String get inoffensive => 'Inoffensive';

  @override
  String get inviteContact => 'Invite contact';

  @override
  String inviteContactToGroupQuestion(Object contact, Object groupName) {
    return 'Do you want to invite $contact to the chat \"$groupName\"?';
  }

  @override
  String inviteContactToGroup(String groupName) {
    return 'Invite contact to $groupName';
  }

  @override
  String get noChatDescriptionYet => 'No chat description created yet.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get invalidServerName => 'Invalid server name';

  @override
  String get invited => 'Invited';

  @override
  String get redactMessageDescription =>
      'The message will be redacted for all participants in this conversation. This cannot be undone.';

  @override
  String get optionalRedactReason =>
      '(Optional) Reason for redacting this message...';

  @override
  String invitedUser(String username, String targetName) {
    return '📩 $username invited $targetName';
  }

  @override
  String get invitedUsersOnly => 'Invited users only';

  @override
  String get inviteForMe => 'Invite for me';

  @override
  String inviteText(String username, String link) {
    return '$username invited you to Nebuchadnezzar.\n1. Visit https://snapcraft.io/nebuchadnezzar and install the app \n2. Sign up or sign in \n3. Open the invite link: \n $link';
  }

  @override
  String get isTyping => 'is typing…';

  @override
  String joinedTheChat(String username) {
    return '👋 $username joined the chat';
  }

  @override
  String get joinRoom => 'Join room';

  @override
  String kicked(String username, String targetName) {
    return '👞 $username kicked $targetName';
  }

  @override
  String kickedAndBanned(String username, String targetName) {
    return '🙅 $username kicked and banned $targetName';
  }

  @override
  String get kickFromChat => 'Kick from chat';

  @override
  String lastActiveAgo(String localizedTimeShort) {
    return 'Last active: $localizedTimeShort';
  }

  @override
  String get leave => 'Leave';

  @override
  String get leftTheChat => 'Left the chat';

  @override
  String get license => 'License';

  @override
  String get lightTheme => 'Light';

  @override
  String loadCountMoreParticipants(int count) {
    return 'Load $count more participants';
  }

  @override
  String get dehydrate => 'Export session and wipe device';

  @override
  String get dehydrateWarning =>
      'This action cannot be undone. Ensure you safely store the backup file.';

  @override
  String get dehydrateTor => 'TOR Users: Export session';

  @override
  String get dehydrateTorLong =>
      'For TOR users, it is recommended to export the session before closing the window.';

  @override
  String get hydrateTor => 'TOR Users: Import session export';

  @override
  String get hydrateTorLong =>
      'Did you export your session last time on TOR? Quickly import it and continue chatting.';

  @override
  String get hydrate => 'Restore from backup file';

  @override
  String get loadingPleaseWait => 'Loading… Please wait.';

  @override
  String get loadMore => 'Load more…';

  @override
  String get locationDisabledNotice =>
      'Location services are disabled. Please enable them to be able to share your location.';

  @override
  String get locationPermissionDeniedNotice =>
      'Location permission denied. Please grant them to be able to share your location.';

  @override
  String get login => 'Login';

  @override
  String logInTo(String homeserver) {
    return 'Log in to $homeserver';
  }

  @override
  String get logout => 'Logout';

  @override
  String get memberChanges => 'Member changes';

  @override
  String get mention => 'Mention';

  @override
  String get messages => 'Messages';

  @override
  String get messagesStyle => 'Messages:';

  @override
  String get moderator => 'Moderator';

  @override
  String get muteChat => 'Mute chat';

  @override
  String get needPantalaimonWarning =>
      'Please be aware that you need Pantalaimon to use end-to-end encryption for now.';

  @override
  String get newChat => 'New chat';

  @override
  String get newMessageInNebuchadnezzar => '💬 New message in Nebuchadnezzar';

  @override
  String get newVerificationRequest => 'New verification request!';

  @override
  String get next => 'Next';

  @override
  String get no => 'No';

  @override
  String get noConnectionToTheServer => 'No connection to the server';

  @override
  String get noEmotesFound => 'No emotes found. 😕';

  @override
  String get noEncryptionForPublicRooms =>
      'You can only activate encryption as soon as the room is no longer publicly accessible.';

  @override
  String get noGoogleServicesWarning =>
      'Firebase Cloud Messaging doesn\'t appear to be available on your device. To still receive push notifications, we recommend installing ntfy. With ntfy or another Unified Push provider you can receive push notifications in a data secure way. You can download ntfy from the PlayStore or from F-Droid.';

  @override
  String noMatrixServer(String server1, String server2) {
    return '$server1 is no matrix server, use $server2 instead?';
  }

  @override
  String get shareInviteLink => 'Share invite link';

  @override
  String get scanQrCode => 'Scan QR code';

  @override
  String get none => 'None';

  @override
  String get noPasswordRecoveryDescription =>
      'You have not added a way to recover your password yet.';

  @override
  String get noPermission => 'No permission';

  @override
  String get noRoomsFound => 'No rooms found…';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsEnabledForThisAccount =>
      'Notifications enabled for this account';

  @override
  String numUsersTyping(int count) {
    return '$count users are typing…';
  }

  @override
  String get obtainingLocation => 'Obtaining location…';

  @override
  String get offensive => 'Offensive';

  @override
  String get offline => 'Offline';

  @override
  String get ok => 'Ok';

  @override
  String get online => 'Online';

  @override
  String get onlineKeyBackupEnabled => 'Online Key Backup is enabled';

  @override
  String get oopsPushError =>
      'Oops! Unfortunately, an error occurred when setting up the push notifications.';

  @override
  String get oopsSomethingWentWrong => 'Oops, something went wrong…';

  @override
  String get openAppToReadMessages => 'Open app to read messages';

  @override
  String get openCamera => 'Open camera';

  @override
  String get openVideoCamera => 'Open camera for a video';

  @override
  String get oneClientLoggedOut => 'One of your clients has been logged out';

  @override
  String get addAccount => 'Add account';

  @override
  String get editBundlesForAccount => 'Edit bundles for this account';

  @override
  String get addToBundle => 'Add to bundle';

  @override
  String get removeFromBundle => 'Remove from this bundle';

  @override
  String get bundleName => 'Bundle name';

  @override
  String get enableMultiAccounts =>
      '(BETA) Enable multi accounts on this device';

  @override
  String get openInMaps => 'Open in maps';

  @override
  String get link => 'Link';

  @override
  String get serverRequiresEmail =>
      'This server needs to validate your email address for registration.';

  @override
  String get or => 'Or';

  @override
  String get participant => 'Participant';

  @override
  String get passphraseOrKey => 'passphrase or recovery key';

  @override
  String get password => 'Password';

  @override
  String get passwordForgotten => 'Password forgotten';

  @override
  String get passwordHasBeenChanged => 'Password has been changed';

  @override
  String get hideMemberChangesInPublicChats =>
      'Hide member changes in public chats';

  @override
  String get hideMemberChangesInPublicChatsBody =>
      'Do not show in the chat timeline if someone joins or leaves a public chat to improve readability.';

  @override
  String get overview => 'Overview';

  @override
  String get notifyMeFor => 'Notify me for';

  @override
  String get passwordRecoverySettings => 'Password recovery settings';

  @override
  String get passwordRecovery => 'Password recovery';

  @override
  String get people => 'People';

  @override
  String get pickImage => 'Pick an image';

  @override
  String get pin => 'Pin';

  @override
  String play(String fileName) {
    return 'Play $fileName';
  }

  @override
  String get pleaseChoose => 'Please choose';

  @override
  String get pleaseChooseAPasscode => 'Please choose a pass code';

  @override
  String get pleaseClickOnLink =>
      'Please click on the link in the email and then proceed.';

  @override
  String get pleaseEnter4Digits =>
      'Please enter 4 digits or leave empty to disable app lock.';

  @override
  String get pleaseEnterRecoveryKey => 'Please enter your recovery key:';

  @override
  String get pleaseEnterYourPassword => 'Please enter your password';

  @override
  String get pleaseEnterYourPin => 'Please enter your pin';

  @override
  String get pleaseEnterYourUsername => 'Please enter your username';

  @override
  String get pleaseFollowInstructionsOnWeb =>
      'Please follow the instructions on the website and tap on next.';

  @override
  String get privacy => 'Privacy';

  @override
  String get publicRooms => 'Public Rooms';

  @override
  String get pushRules => 'Push rules';

  @override
  String get reason => 'Reason';

  @override
  String get recording => 'Recording';

  @override
  String redactedBy(String username) {
    return 'Redacted by $username';
  }

  @override
  String get directChat => 'Direct chat';

  @override
  String redactedByBecause(String username, String reason) {
    return 'Redacted by $username because: \"$reason\"';
  }

  @override
  String redactedAnEvent(String username) {
    return '$username redacted an event';
  }

  @override
  String get redactMessage => 'Redact message';

  @override
  String get register => 'Register';

  @override
  String get reject => 'Reject';

  @override
  String rejectedTheInvitation(String username) {
    return '$username rejected the invitation';
  }

  @override
  String get rejoin => 'Rejoin';

  @override
  String get removeAllOtherDevices => 'Remove all other devices';

  @override
  String removedBy(String username) {
    return 'Removed by $username';
  }

  @override
  String get removeDevice => 'Remove device';

  @override
  String get unbanFromChat => 'Unban from chat';

  @override
  String get removeYourAvatar => 'Remove your avatar';

  @override
  String get replaceRoomWithNewerVersion => 'Replace room with newer version';

  @override
  String get reply => 'Reply';

  @override
  String get reportMessage => 'Report message';

  @override
  String get requestPermission => 'Request permission';

  @override
  String get roomHasBeenUpgraded => 'Room has been upgraded';

  @override
  String get roomVersion => 'Room version';

  @override
  String get saveFile => 'Save file';

  @override
  String get search => 'Search';

  @override
  String get security => 'Security';

  @override
  String get recoveryKey => 'Recovery key';

  @override
  String get recoveryKeyLost => 'Recovery key lost?';

  @override
  String seenByUser(String username) {
    return 'Seen by $username';
  }

  @override
  String get send => 'Send';

  @override
  String get sendAMessage => 'Send a message';

  @override
  String get sendAsText => 'Send as text';

  @override
  String get sendAudio => 'Send audio';

  @override
  String get sendFile => 'Send file';

  @override
  String get sendImage => 'Send image';

  @override
  String get sendMessages => 'Send messages';

  @override
  String get sendOriginal => 'Send original';

  @override
  String get sendSticker => 'Send sticker';

  @override
  String get sendVideo => 'Send video';

  @override
  String sentAFile(String username) {
    return '📁 $username sent a file';
  }

  @override
  String sentAnAudio(String username) {
    return '🎤 $username sent an audio';
  }

  @override
  String sentAPicture(String username) {
    return '🖼️ $username sent a picture';
  }

  @override
  String sentASticker(String username) {
    return '😊 $username sent a sticker';
  }

  @override
  String sentAVideo(String username) {
    return '🎥 $username sent a video';
  }

  @override
  String sentCallInformations(String senderName) {
    return '$senderName sent call information';
  }

  @override
  String get separateChatTypes => 'Separate Direct Chats and Groups';

  @override
  String get setAsCanonicalAlias => 'Set as main alias';

  @override
  String get setCustomEmotes => 'Set custom emotes';

  @override
  String get setChatDescription => 'Set chat description';

  @override
  String get setInvitationLink => 'Set invitation link';

  @override
  String get setPermissionsLevel => 'Set permissions level';

  @override
  String get setStatus => 'Set status';

  @override
  String get settings => 'Settings';

  @override
  String get share => 'Share';

  @override
  String sharedTheLocation(String username) {
    return '$username shared their location';
  }

  @override
  String get shareLocation => 'Share location';

  @override
  String get showPassword => 'Show password';

  @override
  String get presenceStyle => 'Presence:';

  @override
  String get presencesToggle => 'Show status messages from other users';

  @override
  String get singlesignon => 'Single Sign on';

  @override
  String get skip => 'Skip';

  @override
  String get sourceCode => 'Source code';

  @override
  String get spaceIsPublic => 'Space is public';

  @override
  String get spaceName => 'Space name';

  @override
  String startedACall(String senderName) {
    return '$senderName started a call';
  }

  @override
  String get startFirstChat => 'Start your first chat';

  @override
  String get status => 'Status';

  @override
  String get statusExampleMessage => 'How are you today?';

  @override
  String get submit => 'Submit';

  @override
  String get synchronizingPleaseWait => 'Synchronizing… Please wait.';

  @override
  String get systemTheme => 'System';

  @override
  String get theyDontMatch => 'They Don\'t Match';

  @override
  String get theyMatch => 'They Match';

  @override
  String get title => 'Nebuchadnezzar';

  @override
  String get toggleFavorite => 'Toggle Favorite';

  @override
  String get toggleMuted => 'Toggle Muted';

  @override
  String get toggleUnread => 'Mark Read/Unread';

  @override
  String get tooManyRequestsWarning =>
      'Too many requests. Please try again later!';

  @override
  String get transferFromAnotherDevice => 'Transfer from another device';

  @override
  String get tryToSendAgain => 'Try to send again';

  @override
  String get unavailable => 'Unavailable';

  @override
  String unbannedUser(String username, String targetName) {
    return '$username unbanned $targetName';
  }

  @override
  String get unblockDevice => 'Unblock Device';

  @override
  String get unknownDevice => 'Unknown device';

  @override
  String get unknownEncryptionAlgorithm => 'Unknown encryption algorithm';

  @override
  String unknownEvent(String type) {
    return 'Unknown event \'$type\'';
  }

  @override
  String get unmuteChat => 'Unmute chat';

  @override
  String get unpin => 'Unpin';

  @override
  String unreadChats(int unreadCount) {
    String _temp0 = intl.Intl.pluralLogic(
      unreadCount,
      locale: localeName,
      other: '$unreadCount unread chats',
      one: '1 unread chat',
    );
    return '$_temp0';
  }

  @override
  String userAndOthersAreTyping(String username, int count) {
    return '$username and $count others are typing…';
  }

  @override
  String userAndUserAreTyping(String username, String username2) {
    return '$username and $username2 are typing…';
  }

  @override
  String userIsTyping(String username) {
    return '$username is typing…';
  }

  @override
  String userLeftTheChat(String username) {
    return '🚪 $username left the chat';
  }

  @override
  String get username => 'Username';

  @override
  String userSentUnknownEvent(String username, String type) {
    return '$username sent a $type event';
  }

  @override
  String get unverified => 'Unverified';

  @override
  String get verified => 'Verified';

  @override
  String get verify => 'Verify';

  @override
  String get verifyStart => 'Start Verification';

  @override
  String get verifySuccess => 'You successfully verified!';

  @override
  String get verifyTitle => 'Verifying other account';

  @override
  String get videoCall => 'Video call';

  @override
  String get visibilityOfTheChatHistory => 'Visibility of the chat history';

  @override
  String get visibleForAllParticipants => 'Visible for all participants';

  @override
  String get visibleForEveryone => 'Visible for everyone';

  @override
  String get voiceMessage => 'Voice message';

  @override
  String get waitingPartnerAcceptRequest =>
      'Waiting for partner to accept the request…';

  @override
  String get waitingPartnerEmoji => 'Waiting for partner to accept the emoji…';

  @override
  String get waitingPartnerNumbers =>
      'Waiting for partner to accept the numbers…';

  @override
  String get wallpaper => 'Wallpaper:';

  @override
  String get warning => 'Warning!';

  @override
  String get weSentYouAnEmail => 'We sent you an email';

  @override
  String get whoCanPerformWhichAction => 'Who can perform which action';

  @override
  String get whoIsAllowedToJoinThisGroup => 'Who is allowed to join this group';

  @override
  String get whyDoYouWantToReportThis => 'Why do you want to report this?';

  @override
  String get wipeChatBackup =>
      'Wipe your chat backup to create a new recovery key?';

  @override
  String get withTheseAddressesRecoveryDescription =>
      'With these addresses you can recover your password.';

  @override
  String get writeAMessage => 'Write a message…';

  @override
  String get yes => 'Yes';

  @override
  String get you => 'You';

  @override
  String get youAreNoLongerParticipatingInThisChat =>
      'You are no longer participating in this chat';

  @override
  String get youHaveBeenBannedFromThisChat =>
      'You have been banned from this chat';

  @override
  String get yourPublicKey => 'Your public key';

  @override
  String get messageInfo => 'Message info';

  @override
  String get time => 'Time';

  @override
  String get messageType => 'Message Type';

  @override
  String get sender => 'Sender';

  @override
  String get openGallery => 'Open gallery';

  @override
  String get removeFromSpace => 'Remove from space';

  @override
  String get addToSpaceDescription => 'Select a space to add this chat to it.';

  @override
  String get start => 'Start';

  @override
  String get pleaseEnterRecoveryKeyDescription =>
      'To unlock your old messages, please enter your recovery key that has been generated in a previous session. Your recovery key is NOT your password.';

  @override
  String get publish => 'Publish';

  @override
  String videoWithSize(String size) {
    return 'Video ($size)';
  }

  @override
  String get openChat => 'Open Chat';

  @override
  String get markAsRead => 'Mark as read';

  @override
  String get reportUser => 'Report user';

  @override
  String get dismiss => 'Dismiss';

  @override
  String reactedWith(String sender, String reaction) {
    return '$sender reacted with $reaction';
  }

  @override
  String get pinMessage => 'Pin to room';

  @override
  String get confirmEventUnpin =>
      'Are you sure to permanently unpin the event?';

  @override
  String get emojis => 'Emojis';

  @override
  String get placeCall => 'Place call';

  @override
  String get voiceCall => 'Voice call';

  @override
  String get unsupportedAndroidVersion => 'Unsupported Android version';

  @override
  String get unsupportedAndroidVersionLong =>
      'This feature requires a newer Android version. Please check for updates or Lineage OS support.';

  @override
  String get videoCallsBetaWarning =>
      'Please note that video calls are currently in beta. They might not work as expected or work at all on all platforms.';

  @override
  String get experimentalVideoCalls => 'Experimental video calls';

  @override
  String get emailOrUsername => 'Email or username';

  @override
  String get indexedDbErrorTitle => 'Private mode issues';

  @override
  String get indexedDbErrorLong =>
      'The message storage is unfortunately not enabled in private mode by default.\nPlease visit\n - about:config\n - set dom.indexedDB.privateBrowsing.enabled to true\nOtherwise, it is not possible to run Nebuchadnezzar.';

  @override
  String switchToAccount(int number) {
    return 'Switch to account $number';
  }

  @override
  String get nextAccount => 'Next account';

  @override
  String get previousAccount => 'Previous account';

  @override
  String get addWidget => 'Add widget';

  @override
  String get widgetVideo => 'Video';

  @override
  String get widgetEtherpad => 'Text note';

  @override
  String get widgetJitsi => 'Jitsi Meet';

  @override
  String get widgetCustom => 'Custom';

  @override
  String get widgetName => 'Name';

  @override
  String get widgetUrlError => 'This is not a valid URL.';

  @override
  String get widgetNameError => 'Please provide a display name.';

  @override
  String get errorAddingWidget => 'Error adding the widget.';

  @override
  String get youRejectedTheInvitation => 'You rejected the invitation';

  @override
  String get youJoinedTheChat => 'You joined the chat';

  @override
  String get youAcceptedTheInvitation => '👍 You accepted the invitation';

  @override
  String youBannedUser(String user) {
    return 'You banned $user';
  }

  @override
  String youHaveWithdrawnTheInvitationFor(String user) {
    return 'You have withdrawn the invitation for $user';
  }

  @override
  String youInvitedToBy(String alias) {
    return '📩 You have been invited via link to:\n$alias';
  }

  @override
  String youInvitedBy(String user) {
    return '📩 You have been invited by $user';
  }

  @override
  String invitedBy(String user) {
    return '📩 Invited by $user';
  }

  @override
  String youInvitedUser(String user) {
    return '📩 You invited $user';
  }

  @override
  String youKicked(String user) {
    return '👞 You kicked $user';
  }

  @override
  String youKickedAndBanned(String user) {
    return '🙅 You kicked and banned $user';
  }

  @override
  String youUnbannedUser(String user) {
    return 'You unbanned $user';
  }

  @override
  String hasKnocked(String user) {
    return '🚪 $user has knocked';
  }

  @override
  String get usersMustKnock => 'Users must knock';

  @override
  String get noOneCanJoin => 'No one can join';

  @override
  String userWouldLikeToChangeTheChat(String user) {
    return '$user would like to join the chat.';
  }

  @override
  String get noPublicLinkHasBeenCreatedYet =>
      'No public link has been created yet';

  @override
  String get knock => 'Knock';

  @override
  String get users => 'Users';

  @override
  String get unlockOldMessages => 'Unlock old messages';

  @override
  String get storeInSecureStorageDescription =>
      'Store the recovery key in the secure storage of this device.';

  @override
  String get saveKeyManuallyDescription =>
      'Save this key manually by triggering the system share dialog or clipboard.';

  @override
  String get storeInAndroidKeystore => 'Store in Android KeyStore';

  @override
  String get storeInAppleKeyChain => 'Store in Apple KeyChain';

  @override
  String get storeSecurlyOnThisDevice => 'Store securely on this device';

  @override
  String countFiles(int count) {
    return '$count files';
  }

  @override
  String get user => 'User';

  @override
  String get custom => 'Custom';

  @override
  String get foregroundServiceRunning =>
      'This notification appears when the foreground service is running.';

  @override
  String get screenSharingTitle => 'screen sharing';

  @override
  String get screenSharingDetail => 'You are sharing your screen in FuffyChat';

  @override
  String get callingPermissions => 'Calling permissions';

  @override
  String get callingAccount => 'Calling account';

  @override
  String get callingAccountDetails =>
      'Allows Nebuchadnezzar to use the native android dialer app.';

  @override
  String get appearOnTop => 'Appear on top';

  @override
  String get appearOnTopDetails =>
      'Allows the app to appear on top (not needed if you already have Fluffychat setup as a calling account)';

  @override
  String get otherCallingPermissions =>
      'Microphone, camera and other Nebuchadnezzar permissions';

  @override
  String get whyIsThisMessageEncrypted => 'Why is this message unreadable?';

  @override
  String get noKeyForThisMessage =>
      'This can happen if the message was sent before you have signed in to your account at this device.\n\nIt is also possible that the sender has blocked your device or something went wrong with the internet connection.\n\nAre you able to read the message on another session? Then you can transfer the message from it! Go to Settings > Devices and make sure that your devices have verified each other. When you open the room the next time and both sessions are in the foreground, the keys will be transmitted automatically.\n\nDo you not want to lose the keys when logging out or switching devices? Make sure that you have enabled the chat backup in the settings.';

  @override
  String get newGroup => 'New group';

  @override
  String get newSpace => 'New space';

  @override
  String get enterSpace => 'Enter space';

  @override
  String get enterRoom => 'Enter room';

  @override
  String get allSpaces => 'All spaces';

  @override
  String numChats(int number) {
    return '$number chats';
  }

  @override
  String get hideUnimportantStateEvents => 'Hide unimportant state events';

  @override
  String get hidePresences => 'Hide Status List?';

  @override
  String get doNotShowAgain => 'Do not show again';

  @override
  String wasDirectChatDisplayName(String oldDisplayName) {
    return 'Empty chat (was $oldDisplayName)';
  }

  @override
  String get newSpaceDescription =>
      'Spaces allows you to consolidate your chats and build private or public communities.';

  @override
  String get encryptThisChat => 'Encrypt this chat';

  @override
  String get disableEncryptionWarning =>
      'For security reasons you can not disable encryption in a chat, where it has been enabled before.';

  @override
  String get sorryThatsNotPossible => 'Sorry... that is not possible';

  @override
  String get deviceKeys => 'Device keys:';

  @override
  String get reopenChat => 'Reopen chat';

  @override
  String get noBackupWarning =>
      'Warning! Without enabling chat backup, you will lose access to your encrypted messages. It is highly recommended to enable the chat backup first before logging out.';

  @override
  String get noOtherDevicesFound => 'No other devices found';

  @override
  String fileIsTooBigForServer(int max) {
    return 'Unable to send! The server only supports attachments up to $max.';
  }

  @override
  String fileHasBeenSavedAt(String path) {
    return 'File has been saved at $path';
  }

  @override
  String get jumpToLastReadMessage => 'Jump to last read message';

  @override
  String get readUpToHere => 'Read up to here';

  @override
  String get jump => 'Jump';

  @override
  String get openLinkInBrowser => 'Open link in browser';

  @override
  String get reportErrorDescription =>
      '😭 Oh no. Something went wrong. If you want, you can report this bug to the developers.';

  @override
  String get report => 'report';

  @override
  String get signInWithPassword => 'Sign in with password';

  @override
  String get pleaseTryAgainLaterOrChooseDifferentServer =>
      'Please try again later or choose a different server.';

  @override
  String signInWith(String provider) {
    return 'Sign in with $provider';
  }

  @override
  String get profileNotFound =>
      'The user could not be found on the server. Maybe there is a connection problem or the user doesn\'t exist.';

  @override
  String get setTheme => 'Set theme:';

  @override
  String get setColorTheme => 'Set color theme:';

  @override
  String get invite => 'Invite';

  @override
  String get inviteGroupChat => '📨 Invite group chat';

  @override
  String get invitePrivateChat => '📨 Invite private chat';

  @override
  String get invalidInput => 'Invalid input!';

  @override
  String wrongPinEntered(int seconds) {
    return 'Wrong pin entered! Try again in $seconds seconds...';
  }

  @override
  String get pleaseEnterANumber => 'Please enter a number greater than 0';

  @override
  String get archiveRoomDescription =>
      'The chat will be moved to the archive. Other users will be able to see that you have left the chat.';

  @override
  String get roomUpgradeDescription =>
      'The chat will then be recreated with the new room version. All participants will be notified that they need to switch to the new chat. You can find out more about room versions at https://spec.matrix.org/latest/rooms/';

  @override
  String get removeDevicesDescription =>
      'You will be logged out of this device and will no longer be able to receive messages.';

  @override
  String get banUserDescription =>
      'The user will be banned from the chat and will not be able to enter the chat again until they are unbanned.';

  @override
  String get unbanUserDescription =>
      'The user will be able to enter the chat again if they try.';

  @override
  String get kickUserDescription =>
      'The user is kicked out of the chat but not banned. In public chats, the user can rejoin at any time.';

  @override
  String get makeAdminDescription =>
      'Once you make this user admin, you may not be able to undo this as they will then have the same permissions as you.';

  @override
  String get pushNotificationsNotAvailable =>
      'Push notifications not available';

  @override
  String get learnMore => 'Learn more';

  @override
  String get yourGlobalUserIdIs => 'Your global user-ID is: ';

  @override
  String noUsersFoundWithQuery(String query) {
    return 'Unfortunately no user could be found with \"$query\". Please check whether you made a typo.';
  }

  @override
  String get knocking => 'Knocking';

  @override
  String chatCanBeDiscoveredViaSearchOnServer(String server) {
    return 'Chat can be discovered via the search on $server';
  }

  @override
  String get searchChatsRooms => 'Search for #chats, @users...';

  @override
  String get nothingFound => 'Nothing found...';

  @override
  String get groupName => 'Group name';

  @override
  String get createGroupAndInviteUsers => 'Create a group and invite users';

  @override
  String get groupCanBeFoundViaSearch => 'Group can be found via search';

  @override
  String get wrongRecoveryKey =>
      'Sorry... this does not seem to be the correct recovery key.';

  @override
  String get startConversation => 'Start conversation';

  @override
  String get commandHint_sendraw => 'Send raw json';

  @override
  String get databaseMigrationTitle => 'Database is optimized';

  @override
  String get databaseMigrationBody => 'Please wait. This may take a moment.';

  @override
  String get leaveEmptyToClearStatus => 'Leave empty to clear your status.';

  @override
  String get select => 'Select';

  @override
  String get searchForUsers => 'Search for @users...';

  @override
  String get pleaseEnterYourCurrentPassword =>
      'Please enter your current password';

  @override
  String get newPassword => 'New password';

  @override
  String get pleaseChooseAStrongPassword => 'Please choose a strong password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordIsWrong => 'Your entered password is wrong';

  @override
  String get publicLink => 'Public link';

  @override
  String get publicChatAddresses => 'Public chat addresses';

  @override
  String get createNewAddress => 'Create new address';

  @override
  String get joinSpace => 'Join space';

  @override
  String get publicSpaces => 'Public spaces';

  @override
  String get addChatOrSubSpace => 'Add chat or sub space';

  @override
  String get subspace => 'Subspace';

  @override
  String get decline => 'Decline';

  @override
  String get thisDevice => 'This device:';

  @override
  String get initAppError => 'An error occured while init the app';

  @override
  String get userRole => 'User role';

  @override
  String minimumPowerLevel(int level) {
    return '$level is the minimum power level.';
  }

  @override
  String searchIn(String chat) {
    return 'Search in chat \"$chat\"...';
  }

  @override
  String get searchMore => 'Search more...';

  @override
  String get gallery => 'Gallery';

  @override
  String get files => 'Files';

  @override
  String databaseBuildErrorBody(String url, String error) {
    return 'Unable to build the SQlite database. The app tries to use the legacy database for now. Please report this error to the developers at $url. The error message is: $error';
  }

  @override
  String sessionLostBody(String url, String error) {
    return 'Your session is lost. Please report this error to the developers at $url. The error message is: $error';
  }

  @override
  String restoreSessionBody(String url, String error) {
    return 'The app now tries to restore your session from the backup. Please report this error to the developers at $url. The error message is: $error';
  }

  @override
  String forwardMessageTo(String roomName) {
    return 'Forward message to $roomName?';
  }

  @override
  String get sendReadReceipts => 'Send read receipts';

  @override
  String get sendTypingNotificationsDescription =>
      'Other participants in a chat can see when you are typing a new message.';

  @override
  String get sendReadReceiptsDescription =>
      'Other participants in a chat can see when you have read a message.';

  @override
  String get formattedMessages => 'Formatted messages';

  @override
  String get formattedMessagesDescription =>
      'Display rich message content like bold text using markdown.';

  @override
  String get verifyOtherUser => '🔐 Verify other user';

  @override
  String get verifyOtherUserDescription =>
      'If you verify another user, you can be sure that you know who you are really writing to. 💪\n\nWhen you start a verification, you and the other user will see a popup in the app. There you will then see a series of emojis or numbers that you have to compare with each other.\n\nThe best way to do this is to meet up or start a video call. 👭';

  @override
  String get verifyOtherDevice => '🔐 Verify other device';

  @override
  String get verifyOtherDeviceDescription =>
      'When you verify another device, those devices can exchange keys, increasing your overall security. 💪 When you start a verification, a popup will appear in the app on both devices. There you will then see a series of emojis or numbers that you have to compare with each other. It\'s best to have both devices handy before you start the verification. 🤳';

  @override
  String acceptedKeyVerification(String sender) {
    return '$sender accepted key verification';
  }

  @override
  String canceledKeyVerification(String sender) {
    return '$sender canceled key verification';
  }

  @override
  String completedKeyVerification(String sender) {
    return '$sender completed key verification';
  }

  @override
  String isReadyForKeyVerification(String sender) {
    return '$sender is ready for key verification';
  }

  @override
  String requestedKeyVerification(String sender) {
    return '$sender requested key verification';
  }

  @override
  String startedKeyVerification(String sender) {
    return '$sender started key verification';
  }

  @override
  String get transparent => 'Transparent';

  @override
  String get incomingMessages => 'Incoming messages';

  @override
  String get stickers => 'Stickers';

  @override
  String get discover => 'Discover';

  @override
  String get commandHint_ignore => 'Ignore the given matrix ID';

  @override
  String get commandHint_unignore => 'Unignore the given matrix ID';

  @override
  String unreadChatsInApp(String appname, String unread) {
    return '$appname: $unread unread chats';
  }

  @override
  String get noDatabaseEncryption =>
      'Database encryption is not supported on this platform';

  @override
  String thereAreCountUsersBlocked(Object count) {
    return 'Right now there are $count users blocked.';
  }

  @override
  String get restricted => 'Restricted';

  @override
  String get knockRestricted => 'Knock restricted';

  @override
  String goToSpace(Object space) {
    return 'Go to space: $space';
  }

  @override
  String get markAsUnread => 'Mark as unread';

  @override
  String userLevel(int level) {
    return '$level - User';
  }

  @override
  String moderatorLevel(int level) {
    return '$level - Moderator';
  }

  @override
  String adminLevel(int level) {
    return '$level - Admin';
  }

  @override
  String get changeGeneralChatSettings => 'Change general chat settings';

  @override
  String get inviteOtherUsers => 'Invite other users to this chat';

  @override
  String get changeTheChatPermissions => 'Change the chat permissions';

  @override
  String get changeTheVisibilityOfChatHistory =>
      'Change the visibility of the chat history';

  @override
  String get changeTheCanonicalRoomAlias =>
      'Change the main public chat address';

  @override
  String get sendRoomNotifications => 'Send a @room notifications';

  @override
  String get changeTheDescriptionOfTheGroup =>
      'Change the description of the chat';

  @override
  String get chatPermissionsDescription =>
      'Define which power level is necessary for certain actions in this chat. The power levels 0, 50 and 100 are usually representing users, moderators and admins, but any gradation is possible.';

  @override
  String updateInstalled(String version) {
    return '🎉 Update $version installed!';
  }

  @override
  String get changelog => 'Changelog';

  @override
  String get sendCanceled => 'Sending canceled';

  @override
  String get loginWithMatrixId => 'Login with Matrix-ID';

  @override
  String get discoverHomeservers => 'Discover homeservers';

  @override
  String get whatIsAHomeserver => 'What is a homeserver?';

  @override
  String get homeserverDescription =>
      'All your data is stored on the homeserver, just like an email provider. You can choose which homeserver you want to use, while you can still communicate with everyone. Learn more at at https://matrix.org.';

  @override
  String get doesNotSeemToBeAValidHomeserver =>
      'Doesn\'t seem to be a compatible homeserver. Wrong URL?';

  @override
  String get calculatingFileSize => 'Calculating file size...';

  @override
  String get prepareSendingAttachment => 'Prepare sending attachment...';

  @override
  String get sendingAttachment => 'Sending attachment...';

  @override
  String get generatingVideoThumbnail => 'Generating video thumbnail...';

  @override
  String get compressVideo => 'Compressing video...';

  @override
  String sendingAttachmentCountOfCount(int index, int length) {
    return 'Sending attachment $index of $length...';
  }

  @override
  String serverLimitReached(int seconds) {
    return 'Server limit reached! Waiting $seconds seconds...';
  }

  @override
  String get yesterday => 'Gestern';
}
