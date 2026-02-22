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
  String get repeatPassword => 'Passwort wiederholen';

  @override
  String get notAnImage => 'Keine Bilddatei.';

  @override
  String get remove => 'Entfernen';

  @override
  String get importNow => 'Jetzt importieren';

  @override
  String get importEmojis => 'Emojis importieren';

  @override
  String get importFromZipFile => 'Aus .zip Datei importieren';

  @override
  String get exportEmotePack => 'Emote-Paket als .zip exportieren';

  @override
  String get replace => 'Ersetzen';

  @override
  String get about => 'Über';

  @override
  String get accept => 'Akzeptieren';

  @override
  String acceptedTheInvitation(String username) {
    return '👍 $username hat die Einladung angenommen';
  }

  @override
  String get account => 'Konto';

  @override
  String activatedEndToEndEncryption(String username) {
    return '🔐 $username hat die Ende-zu-Ende-Verschlüsselung aktiviert';
  }

  @override
  String get addEmail => 'E-Mail hinzufügen';

  @override
  String get confirmMatrixId =>
      'Bitte bestätigen Sie Ihre Matrix-ID, um Ihr Konto zu löschen.';

  @override
  String supposedMxid(String mxid) {
    return 'Dies sollte $mxid sein';
  }

  @override
  String get addChatDescription => 'Chat-Beschreibung hinzufügen...';

  @override
  String get addToSpace => 'Zum Space hinzufügen';

  @override
  String get admin => 'Admin';

  @override
  String get alias => 'Alias';

  @override
  String get all => 'Alle';

  @override
  String get allChats => 'Alle Chats';

  @override
  String get commandHint_googly => 'Sende Kulleraugen';

  @override
  String get commandHint_cuddle => 'Sende Kuscheln';

  @override
  String get commandHint_hug => 'Sende eine Umarmung';

  @override
  String googlyEyesContent(String senderName) {
    return '$senderName sendet Kulleraugen';
  }

  @override
  String cuddleContent(String senderName) {
    return '$senderName knuddelt dich';
  }

  @override
  String hugContent(String senderName) {
    return '$senderName umarmt dich';
  }

  @override
  String answeredTheCall(String senderName) {
    return '$senderName hat den Anruf angenommen';
  }

  @override
  String get anyoneCanJoin => 'Jeder kann beitreten';

  @override
  String get appLock => 'App-Sperre';

  @override
  String get appLockDescription =>
      'Sperre die App mit einem PIN-Code, wenn sie nicht verwendet wird';

  @override
  String get archive => 'Archiv';

  @override
  String get areGuestsAllowedToJoin => 'Dürfen Gäste beitreten';

  @override
  String get areYouSure => 'Sind Sie sicher?';

  @override
  String get areYouSureYouWantToLogout =>
      'Sind Sie sicher, dass Sie sich abmelden möchten?';

  @override
  String get askSSSSSign =>
      'Um die andere Person signieren zu können, geben Sie bitte Ihre Passphrase oder Ihren Wiederherstellungsschlüssel für den sicheren Speicher ein.';

  @override
  String askVerificationRequest(String username) {
    return 'Diese Verifizierungsanfrage von $username annehmen?';
  }

  @override
  String get autoplayImages =>
      'Automatische Wiedergabe von animierten Stickern und Emotes';

  @override
  String badServerLoginTypesException(
    String serverVersions,
    String supportedVersions,
  ) {
    return 'Der Homeserver unterstützt die Anmeldetypen:\n$serverVersions\nAber diese App unterstützt nur:\n$supportedVersions';
  }

  @override
  String get sendTypingNotifications => 'Sende Schreibbenachrichtigungen';

  @override
  String get swipeRightToLeftToReply =>
      'Wische von rechts nach links zum Antworten';

  @override
  String get sendOnEnter => 'Senden mit Eingabetaste';

  @override
  String badServerVersionsException(
    String serverVersions,
    String supportedVersions,
  ) {
    return 'Der Homeserver unterstützt die Spec-Versionen:\n$serverVersions\nAber diese App unterstützt nur $supportedVersions';
  }

  @override
  String countChatsAndCountParticipants(String chats, Object participants) {
    return '$chats Chats und $participants Teilnehmer';
  }

  @override
  String get noMoreChatsFound => 'Keine weiteren Chats gefunden...';

  @override
  String get noChatsFoundHere =>
      'Hier wurden noch keine Chats gefunden. Starte einen neuen Chat mit jemandem, indem du den Button unten benutzt. ⤵️';

  @override
  String get joinedChats => 'Beigetretene Chats';

  @override
  String get unread => 'Ungelesen';

  @override
  String get space => 'Space';

  @override
  String get spaces => 'Spaces';

  @override
  String get banFromChat => 'Aus dem Chat verbannen';

  @override
  String get banned => 'Verbannt';

  @override
  String bannedUser(String username, String targetName) {
    return '$username hat $targetName verbannt';
  }

  @override
  String get blockDevice => 'Gerät blockieren';

  @override
  String get blocked => 'Blockiert';

  @override
  String get botMessages => 'Bot-Nachrichten';

  @override
  String get cancel => 'Abbrechen';

  @override
  String cantOpenUri(String uri) {
    return 'Kann die URI $uri nicht öffnen';
  }

  @override
  String get changeDeviceName => 'Gerätename ändern';

  @override
  String changedTheChatAvatar(String username) {
    return '$username hat den Chat-Avatar geändert';
  }

  @override
  String changedTheChatDescriptionTo(String username, String description) {
    return '$username hat die Chat-Beschreibung geändert zu: \'$description\'';
  }

  @override
  String changedTheChatNameTo(String username, String chatname) {
    return '$username hat den Chat-Namen geändert zu: \'$chatname\'';
  }

  @override
  String changedTheChatPermissions(String username) {
    return '$username hat die Chat-Berechtigungen geändert';
  }

  @override
  String changedTheDisplaynameTo(String username, String displayname) {
    return '$username hat den Anzeigenamen geändert zu: \'$displayname\'';
  }

  @override
  String changedTheGuestAccessRules(String username) {
    return '$username hat die Gästezugriffsregeln geändert';
  }

  @override
  String changedTheGuestAccessRulesTo(String username, String rules) {
    return '$username hat die Gästezugriffsregeln geändert zu: $rules';
  }

  @override
  String changedTheHistoryVisibility(String username) {
    return '$username hat die Sichtbarkeit des Verlaufs geändert';
  }

  @override
  String changedTheHistoryVisibilityTo(String username, String rules) {
    return '$username hat die Sichtbarkeit des Verlaufs geändert zu: $rules';
  }

  @override
  String changedTheJoinRules(String username) {
    return '$username hat die Beitrittsregeln geändert';
  }

  @override
  String changedTheJoinRulesTo(String username, String joinRules) {
    return '$username hat die Beitrittsregeln geändert zu: $joinRules';
  }

  @override
  String changedTheProfileAvatar(String username) {
    return '$username hat den Avatar geändert';
  }

  @override
  String changedTheRoomAliases(String username) {
    return '$username hat die Raum-Aliase geändert';
  }

  @override
  String changedTheRoomInvitationLink(String username) {
    return '$username hat den Einladungslink geändert';
  }

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get changeTheHomeserver => 'Homeserver ändern';

  @override
  String get changeTheme => 'Design ändern';

  @override
  String get changeTheNameOfTheGroup => 'Gruppennamen ändern';

  @override
  String get changeYourAvatar => 'Avatar ändern';

  @override
  String get channelCorruptedDecryptError =>
      'Die Verschlüsselung wurde beschädigt';

  @override
  String get chat => 'Chat';

  @override
  String get yourChatBackupHasBeenSetUp =>
      'Dein Chat-Backup wurde eingerichtet.';

  @override
  String get chatBackup => 'Chat-Backup';

  @override
  String get chatBackupDescription =>
      'Deine alten Nachrichten sind mit einem Wiederherstellungsschlüssel gesichert. Bitte stelle sicher, dass du ihn nicht verlierst.';

  @override
  String get chatDetails => 'Chat-Details';

  @override
  String get chatHasBeenAddedToThisSpace =>
      'Chat wurde zu diesem Space hinzugefügt';

  @override
  String get chats => 'Chats';

  @override
  String get chooseAStrongPassword => 'Wähle ein sicheres Passwort';

  @override
  String get clearArchive => 'Archiv leeren';

  @override
  String get close => 'Schließen';

  @override
  String get commandHint_markasdm =>
      'Als Direktnachrichtenraum für die angegebene Matrix-ID markieren';

  @override
  String get commandHint_markasgroup => 'Als Gruppe markieren';

  @override
  String get commandHint_ban =>
      'Den angegebenen Benutzer aus diesem Raum verbannen';

  @override
  String get commandHint_clearcache => 'Cache leeren';

  @override
  String get commandHint_create =>
      'Erstelle einen leeren Gruppenchat\nVerwende --no-encryption, um die Verschlüsselung zu deaktivieren';

  @override
  String get commandHint_discardsession => 'Sitzung verwerfen';

  @override
  String get commandHint_dm =>
      'Starte einen Direktchat\nVerwende --no-encryption, um die Verschlüsselung zu deaktivieren';

  @override
  String get commandHint_html => 'HTML-formatierten Text senden';

  @override
  String get commandHint_invite =>
      'Lade den angegebenen Benutzer in diesen Raum ein';

  @override
  String get commandHint_join => 'Dem angegebenen Raum beitreten';

  @override
  String get commandHint_kick =>
      'Entferne den angegebenen Benutzer aus diesem Raum';

  @override
  String get commandHint_leave => 'Verlasse diesen Raum';

  @override
  String get commandHint_me => 'Beschreibe dich selbst';

  @override
  String get commandHint_myroomavatar =>
      'Setze dein Bild für diesen Raum (per mxc-uri)';

  @override
  String get commandHint_myroomnick =>
      'Setze deinen Anzeigenamen für diesen Raum';

  @override
  String get commandHint_op =>
      'Setze das Power-Level des angegebenen Benutzers (Standard: 50)';

  @override
  String get commandHint_plain => 'Unformatierten Text senden';

  @override
  String get commandHint_react => 'Antwort als Reaktion senden';

  @override
  String get commandHint_send => 'Text senden';

  @override
  String get commandHint_unban =>
      'Entbanne den angegebenen Benutzer aus diesem Raum';

  @override
  String get commandInvalid => 'Ungültiger Befehl';

  @override
  String commandMissing(String command) {
    return '$command ist kein Befehl.';
  }

  @override
  String get compareEmojiMatch => 'Bitte vergleichen Sie die Emojis';

  @override
  String get compareNumbersMatch => 'Bitte vergleichen Sie die Zahlen';

  @override
  String get configureChat => 'Chat konfigurieren';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get connect => 'Verbinden';

  @override
  String get contactHasBeenInvitedToTheGroup =>
      'Kontakt wurde in die Gruppe eingeladen';

  @override
  String get containsDisplayName => 'Enthält Anzeigename';

  @override
  String get containsUserName => 'Enthält Benutzername';

  @override
  String get contentHasBeenReported =>
      'Der Inhalt wurde den Server-Admins gemeldet';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get copy => 'Kopieren';

  @override
  String get copyToClipboard => 'In die Zwischenablage kopieren';

  @override
  String couldNotDecryptMessage(String error) {
    return 'Nachricht konnte nicht entschlüsselt werden: $error';
  }

  @override
  String countParticipants(int count) {
    return '$count Teilnehmer';
  }

  @override
  String get create => 'Erstellen';

  @override
  String createdTheChat(String username) {
    return '💬 $username hat den Chat erstellt';
  }

  @override
  String get createGroup => 'Gruppe erstellen';

  @override
  String get createNewSpace => 'Neuer Space';

  @override
  String get currentlyActive => 'Gerade aktiv';

  @override
  String get darkTheme => 'Dunkel';

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
      'Dies wird dein Benutzerkonto deaktivieren. Das kann nicht rückgängig gemacht werden! Bist du sicher?';

  @override
  String get defaultPermissionLevel =>
      'Standardberechtigungsstufe für neue Benutzer';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteMessage => 'Nachricht löschen';

  @override
  String get device => 'Gerät';

  @override
  String get deviceId => 'Geräte-ID';

  @override
  String get devices => 'Geräte';

  @override
  String get directChats => 'Direktnachrichten';

  @override
  String get allRooms => 'Alle Gruppenchats';

  @override
  String get displaynameHasBeenChanged => 'Anzeigename wurde geändert';

  @override
  String get downloadFile => 'Datei herunterladen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get editBlockedServers => 'Blockierte Server bearbeiten';

  @override
  String get chatPermissions => 'Chat-Berechtigungen';

  @override
  String get editDisplayname => 'Anzeigenamen bearbeiten';

  @override
  String get editRoomAliases => 'Raum-Aliase bearbeiten';

  @override
  String get editRoomAvatar => 'Raum-Avatar bearbeiten';

  @override
  String get emoteExists => 'Emote existiert bereits!';

  @override
  String get emoteInvalid => 'Ungültiges Emote-Kürzel!';

  @override
  String get emoteKeyboardNoRecents =>
      'Kürzlich verwendete Emotes erscheinen hier...';

  @override
  String get emotePacks => 'Emote-Pakete für Raum';

  @override
  String get emoteSettings => 'Emote-Einstellungen';

  @override
  String get globalChatId => 'Globale Chat-ID';

  @override
  String get accessAndVisibility => 'Zugriff und Sichtbarkeit';

  @override
  String get accessAndVisibilityDescription =>
      'Wer darf diesem Chat beitreten und wie kann der Chat gefunden werden.';

  @override
  String get calls => 'Anrufe';

  @override
  String get customEmojisAndStickers => 'Benutzerdefinierte Emojis und Sticker';

  @override
  String get customEmojisAndStickersBody =>
      'Füge benutzerdefinierte Emojis oder Sticker hinzu, die in jedem Chat verwendet werden können.';

  @override
  String get emoteShortcode => 'Emote-Kürzel';

  @override
  String get emoteWarnNeedToPick =>
      'Du musst ein Emote-Kürzel und ein Bild auswählen!';

  @override
  String get emptyChat => 'Leerer Chat';

  @override
  String get enableEmotesGlobally => 'Emote-Paket global aktivieren';

  @override
  String get enableEncryption => 'Verschlüsselung aktivieren';

  @override
  String get enableEncryptionWarning =>
      'Du wirst die Verschlüsselung nicht mehr deaktivieren können. Bist du sicher?';

  @override
  String get encrypted => 'Verschlüsselt';

  @override
  String get encryption => 'Verschlüsselung';

  @override
  String get encryptionNotEnabled => 'Verschlüsselung ist nicht aktiviert';

  @override
  String endedTheCall(String senderName) {
    return '$senderName hat den Anruf beendet';
  }

  @override
  String get enterAnEmailAddress => 'Gib eine E-Mail-Adresse ein';

  @override
  String get homeserver => 'Homeserver';

  @override
  String get enterYourHomeserver => 'Gib deinen Homeserver ein';

  @override
  String errorObtainingLocation(String error) {
    return 'Fehler beim Abrufen des Standorts: $error';
  }

  @override
  String get everythingReady => 'Alles bereit!';

  @override
  String get extremeOffensive => 'Extrem anstößig';

  @override
  String get fileName => 'Dateiname';

  @override
  String get nebuchadnezzar => 'Nebuchadnezzar';

  @override
  String get fontSize => 'Schriftgröße';

  @override
  String get forward => 'Weiterleiten';

  @override
  String get fromJoining => 'Vom Beitreten';

  @override
  String get fromTheInvitation => 'Von der Einladung';

  @override
  String get goToTheNewRoom => 'Gehe zum neuen Raum';

  @override
  String get group => 'Gruppe';

  @override
  String get chatDescription => 'Chat-Beschreibung';

  @override
  String get chatDescriptionHasBeenChanged => 'Chat-Beschreibung geändert';

  @override
  String get groupIsPublic => 'Gruppe ist öffentlich';

  @override
  String get groups => 'Gruppen';

  @override
  String groupWith(String displayname) {
    return 'Gruppe mit $displayname';
  }

  @override
  String get guestsAreForbidden => 'Gäste sind verboten';

  @override
  String get guestsCanJoin => 'Gäste können beitreten';

  @override
  String hasWithdrawnTheInvitationFor(String username, String targetName) {
    return '$username hat die Einladung für $targetName zurückgezogen';
  }

  @override
  String get help => 'Hilfe';

  @override
  String get hideRedactedEvents => 'Redigierte Ereignisse verbergen';

  @override
  String get hideRedactedMessages => 'Redigierte Nachrichten verbergen';

  @override
  String get hideRedactedMessagesBody =>
      'Wenn jemand eine Nachricht redigiert, wird diese Nachricht im Chat nicht mehr sichtbar sein.';

  @override
  String get hideInvalidOrUnknownMessageFormats =>
      'Ungültige oder unbekannte Nachrichtenformate verbergen';

  @override
  String get howOffensiveIsThisContent => 'Wie anstößig ist dieser Inhalt?';

  @override
  String get id => 'ID';

  @override
  String get identity => 'Identität';

  @override
  String get block => 'Blockieren';

  @override
  String get blockedUsers => 'Blockierte Benutzer';

  @override
  String get blockListDescription =>
      'Du kannst Benutzer blockieren, die dich stören. Du wirst keine Nachrichten oder Raumeinladungen von den Benutzern auf deiner persönlichen Blockierliste erhalten.';

  @override
  String blockUsername(String username) {
    return '$username ignorieren';
  }

  @override
  String get iHaveClickedOnLink => 'Ich habe auf den Link geklickt';

  @override
  String get incorrectPassphraseOrKey =>
      'Falsche Passphrase oder Wiederherstellungsschlüssel';

  @override
  String get inoffensive => 'Harmlos';

  @override
  String get inviteContact => 'Kontakt einladen';

  @override
  String inviteContactToGroupQuestion(String contact, String groupName) {
    return 'Möchtest du $contact in den Chat \"$groupName\" einladen?';
  }

  @override
  String get noChatDescriptionYet => 'Noch keine Chat-Beschreibung erstellt.';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get invalidServerName => 'Ungültiger Servername';

  @override
  String get invited => 'Eingeladen';

  @override
  String get redactMessageDescription =>
      'Die Nachricht wird für alle Teilnehmer in dieser Konversation redigiert. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get optionalRedactReason =>
      '(Optional) Grund für das Redigieren dieser Nachricht...';

  @override
  String invitedUser(String username, String targetName) {
    return '📩 $username hat $targetName eingeladen';
  }

  @override
  String get invitedUsersOnly => 'Nur eingeladene Benutzer';

  @override
  String get inviteForMe => 'Invite for me';

  @override
  String inviteText(String username, String link) {
    return '$username hat dich zu Nebuchadnezzar eingeladen.\n1. Gehe zu https://snapcraft.io/nebuchadnezzar und installiere die App\n2. Melde dich an oder registriere dich\n3. Öffne den Einladungslink:\n $link';
  }

  @override
  String get isTyping => 'schreibt...';

  @override
  String joinedTheChat(String username) {
    return '👋 $username ist dem Chat beigetreten';
  }

  @override
  String get joinRoom => 'Raum beitreten';

  @override
  String kicked(String username, String targetName) {
    return '👞 $username hat $targetName rausgeworfen';
  }

  @override
  String kickedAndBanned(String username, String targetName) {
    return '🙅 $username hat $targetName rausgeworfen und verbannt';
  }

  @override
  String get kickFromChat => 'Aus dem Chat werfen';

  @override
  String lastActiveAgo(String localizedTimeShort) {
    return 'Zuletzt aktiv: $localizedTimeShort';
  }

  @override
  String get leave => 'Verlassen';

  @override
  String get leftTheChat => 'Hat den Chat verlassen';

  @override
  String get license => 'Lizenz';

  @override
  String get lightTheme => 'Hell';

  @override
  String loadCountMoreParticipants(int count) {
    return 'Lade $count weitere Teilnehmer';
  }

  @override
  String get dehydrate => 'Sitzung exportieren und Gerät löschen';

  @override
  String get dehydrateWarning =>
      'Diese Aktion kann nicht rückgängig gemacht werden. Stelle sicher, dass du die Sicherungsdatei sicher aufbewahrst.';

  @override
  String get dehydrateTor => 'TOR-Benutzer: Sitzung exportieren';

  @override
  String get dehydrateTorLong =>
      'Für TOR-Benutzer wird empfohlen, die Sitzung vor dem Schließen des Fensters zu exportieren.';

  @override
  String get hydrateTor => 'TOR-Benutzer: Sitzungsexport importieren';

  @override
  String get hydrateTorLong =>
      'Hast du deine Sitzung beim letzten Mal über TOR exportiert? Importiere sie schnell und chatte weiter.';

  @override
  String get hydrate => 'Aus Sicherungsdatei wiederherstellen';

  @override
  String get loadingPleaseWait => 'Laden... Bitte warten.';

  @override
  String get loadMore => 'Mehr laden...';

  @override
  String get locationDisabledNotice =>
      'Standortdienste sind deaktiviert. Bitte aktiviere sie, um deinen Standort teilen zu können.';

  @override
  String get locationPermissionDeniedNotice =>
      'Standortberechtigung verweigert. Bitte gewähre sie, um deinen Standort teilen zu können.';

  @override
  String get login => 'Anmelden';

  @override
  String logInTo(String homeserver) {
    return 'Bei $homeserver anmelden';
  }

  @override
  String get logout => 'Abmelden';

  @override
  String get memberChanges => 'Mitgliederänderungen';

  @override
  String get mention => 'Erwähnung';

  @override
  String get messages => 'Nachrichten';

  @override
  String get messagesStyle => 'Nachrichten:';

  @override
  String get moderator => 'Moderator';

  @override
  String get muteChat => 'Chat stummschalten';

  @override
  String get needPantalaimonWarning =>
      'Bitte beachte, dass du Pantalaimon benötigst, um die Ende-zu-Ende-Verschlüsselung vorerst nutzen zu können.';

  @override
  String get newChat => 'Neuer Chat';

  @override
  String get newMessageInNebuchadnezzar =>
      '💬 Neue Nachricht in Nebuchadnezzar';

  @override
  String get newVerificationRequest => 'Neue Verifizierungsanfrage!';

  @override
  String get next => 'Weiter';

  @override
  String get no => 'Nein';

  @override
  String get noConnectionToTheServer => 'Keine Verbindung zum Server';

  @override
  String get noEmotesFound => 'Keine Emotes gefunden. 😕';

  @override
  String get noEncryptionForPublicRooms =>
      'Du kannst die Verschlüsselung erst aktivieren, wenn der Raum nicht mehr öffentlich zugänglich ist.';

  @override
  String get noGoogleServicesWarning =>
      'Firebase Cloud Messaging scheint auf deinem Gerät nicht verfügbar zu sein. Um trotzdem Push-Benachrichtigungen zu erhalten, empfehlen wir die Installation von ntfy. Mit ntfy oder einem anderen Unified Push-Anbieter kannst du Push-Benachrichtigungen datenschutzkonform empfangen. Du kannst ntfy aus dem PlayStore oder von F-Droid herunterladen.';

  @override
  String noMatrixServer(String server1, String server2) {
    return '$server1 ist kein Matrix-Server, $server2 stattdessen verwenden?';
  }

  @override
  String get shareInviteLink => 'Einladungslink teilen';

  @override
  String get scanQrCode => 'QR-Code scannen';

  @override
  String get none => 'Keine';

  @override
  String get noPasswordRecoveryDescription =>
      'Du hast noch keine Methode zur Wiederherstellung deines Passworts hinzugefügt.';

  @override
  String get noPermission => 'Keine Berechtigung';

  @override
  String get noRoomsFound => 'Keine Räume gefunden...';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get notificationsEnabledForThisAccount =>
      'Benachrichtigungen für dieses Konto aktiviert';

  @override
  String numUsersTyping(int count) {
    return '$count Nutzer schreiben gerade...';
  }

  @override
  String get obtainingLocation => 'Standort wird abgerufen...';

  @override
  String get offensive => 'Anstößig';

  @override
  String get offline => 'Offline';

  @override
  String get ok => 'Ok';

  @override
  String get online => 'Online';

  @override
  String get onlineKeyBackupEnabled => 'Online-Schlüssel-Backup ist aktiviert';

  @override
  String get oopsPushError =>
      'Hoppla! Leider ist beim Einrichten der Push-Benachrichtigungen ein Fehler aufgetreten.';

  @override
  String get oopsSomethingWentWrong => 'Hoppla, etwas ist schief gelaufen...';

  @override
  String get openAppToReadMessages => 'App öffnen, um Nachrichten zu lesen';

  @override
  String get openCamera => 'Kamera öffnen';

  @override
  String get openVideoCamera => 'Kamera für ein Video öffnen';

  @override
  String get oneClientLoggedOut => 'Einer deiner Clients wurde abgemeldet';

  @override
  String get addAccount => 'Konto hinzufügen';

  @override
  String get editBundlesForAccount => 'Bundles für dieses Konto bearbeiten';

  @override
  String get addToBundle => 'Zu Bundle hinzufügen';

  @override
  String get removeFromBundle => 'Aus diesem Bundle entfernen';

  @override
  String get bundleName => 'Bundle-Name';

  @override
  String get enableMultiAccounts =>
      '(BETA) Multi-Accounts auf diesem Gerät aktivieren';

  @override
  String get openInMaps => 'In Karten öffnen';

  @override
  String get link => 'Link';

  @override
  String get serverRequiresEmail =>
      'Dieser Server benötigt eine Bestätigung deiner E-Mail-Adresse für die Registrierung.';

  @override
  String get or => 'Oder';

  @override
  String get participant => 'Teilnehmer';

  @override
  String get passphraseOrKey => 'Passphrase oder Wiederherstellungsschlüssel';

  @override
  String get password => 'Passwort';

  @override
  String get passwordForgotten => 'Passwort vergessen';

  @override
  String get passwordHasBeenChanged => 'Passwort wurde geändert';

  @override
  String get hideMemberChangesInPublicChats =>
      'Mitgliederänderungen in öffentlichen Chats verbergen';

  @override
  String get hideMemberChangesInPublicChatsBody =>
      'Zeige nicht im Chat-Verlauf an, wenn jemand einem öffentlichen Chat beitritt oder ihn verlässt, um die Lesbarkeit zu verbessern.';

  @override
  String get overview => 'Übersicht';

  @override
  String get notifyMeFor => 'Benachrichtige mich für';

  @override
  String get passwordRecoverySettings =>
      'Einstellungen zur Passwortwiederherstellung';

  @override
  String get passwordRecovery => 'Passwortwiederherstellung';

  @override
  String get people => 'Personen';

  @override
  String get pickImage => 'Bild auswählen';

  @override
  String get pin => 'Anpinnen';

  @override
  String play(String fileName) {
    return '$fileName abspielen';
  }

  @override
  String get pleaseChoose => 'Bitte wählen';

  @override
  String get pleaseChooseAPasscode => 'Bitte wähle einen Passcode';

  @override
  String get pleaseClickOnLink =>
      'Bitte klicke auf den Link in der E-Mail und fahre dann fort.';

  @override
  String get pleaseEnter4Digits =>
      'Bitte gib 4 Ziffern ein oder lasse das Feld leer, um die App-Sperre zu deaktivieren.';

  @override
  String get pleaseEnterRecoveryKey =>
      'Bitte gib deinen Wiederherstellungsschlüssel ein:';

  @override
  String get pleaseEnterYourPassword => 'Bitte gib dein Passwort ein';

  @override
  String get pleaseEnterYourPin => 'Bitte gib deine PIN ein';

  @override
  String get pleaseEnterYourUsername => 'Bitte gib deinen Benutzernamen ein';

  @override
  String get pleaseFollowInstructionsOnWeb =>
      'Bitte folge den Anweisungen auf der Webseite und tippe auf Weiter.';

  @override
  String get privacy => 'Privatsphäre';

  @override
  String get publicRooms => 'Öffentliche Räume';

  @override
  String get pushRules => 'Push-Regeln';

  @override
  String get reason => 'Grund';

  @override
  String get recording => 'Aufnahme';

  @override
  String redactedBy(String username) {
    return 'Zensiert von $username';
  }

  @override
  String get directChat => 'Direktchat';

  @override
  String redactedByBecause(String username, String reason) {
    return 'Zensiert von $username wegen: \"$reason\"';
  }

  @override
  String redactedAnEvent(String username) {
    return '$username hat ein Ereignis zensiert';
  }

  @override
  String get redactMessage => 'Nachricht zensieren';

  @override
  String get register => 'Registrieren';

  @override
  String get reject => 'Ablehnen';

  @override
  String rejectedTheInvitation(String username) {
    return '$username hat die Einladung abgelehnt';
  }

  @override
  String get rejoin => 'Wieder beitreten';

  @override
  String get removeAllOtherDevices => 'Alle anderen Geräte entfernen';

  @override
  String removedBy(String username) {
    return 'Entfernt von $username';
  }

  @override
  String get removeDevice => 'Gerät entfernen';

  @override
  String get unbanFromChat => 'Bann für Chat aufheben';

  @override
  String get removeYourAvatar => 'Avatar entfernen';

  @override
  String get replaceRoomWithNewerVersion =>
      'Raum durch neuere Version ersetzen';

  @override
  String get reply => 'Antworten';

  @override
  String get reportMessage => 'Nachricht melden';

  @override
  String get requestPermission => 'Berechtigung anfordern';

  @override
  String get roomHasBeenUpgraded => 'Raum wurde aktualisiert';

  @override
  String get roomVersion => 'Raumversion';

  @override
  String get saveFile => 'Datei speichern';

  @override
  String get search => 'Suchen';

  @override
  String get security => 'Sicherheit';

  @override
  String get recoveryKey => 'Wiederherstellungsschlüssel';

  @override
  String get recoveryKeyLost => 'Wiederherstellungsschlüssel verloren?';

  @override
  String seenByUser(String username) {
    return 'Gesehen von $username';
  }

  @override
  String get send => 'Senden';

  @override
  String get sendAMessage => 'Sende eine Nachricht';

  @override
  String get sendAsText => 'Als Text senden';

  @override
  String get sendAudio => 'Audio senden';

  @override
  String get sendFile => 'Datei senden';

  @override
  String get sendImage => 'Bild senden';

  @override
  String get sendMessages => 'Nachrichten senden';

  @override
  String get sendOriginal => 'Original senden';

  @override
  String get sendSticker => 'Sticker senden';

  @override
  String get sendVideo => 'Video senden';

  @override
  String sentAFile(String username) {
    return '📁 $username hat eine Datei gesendet';
  }

  @override
  String sentAnAudio(String username) {
    return '🎤 $username hat eine Audio-Nachricht gesendet';
  }

  @override
  String sentAPicture(String username) {
    return '🖼️ $username hat ein Bild gesendet';
  }

  @override
  String sentASticker(String username) {
    return '😊 $username hat einen Sticker gesendet';
  }

  @override
  String sentAVideo(String username) {
    return '🎥 $username hat ein Video gesendet';
  }

  @override
  String sentCallInformations(String senderName) {
    return '$senderName hat Anrufinformationen gesendet';
  }

  @override
  String get separateChatTypes => 'Direktnachrichten und Gruppen trennen';

  @override
  String get setAsCanonicalAlias => 'Als Hauptalias setzen';

  @override
  String get setCustomEmotes => 'Benutzerdefinierte Emotes festlegen';

  @override
  String get setChatDescription => 'Chatbeschreibung festlegen';

  @override
  String get setInvitationLink => 'Einladungslink festlegen';

  @override
  String get setPermissionsLevel => 'Berechtigungsstufe festlegen';

  @override
  String get setStatus => 'Status festlegen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get share => 'Teilen';

  @override
  String sharedTheLocation(String username) {
    return '$username hat seinen Standort geteilt';
  }

  @override
  String get shareLocation => 'Standort teilen';

  @override
  String get showPassword => 'Passwort anzeigen';

  @override
  String get presenceStyle => 'Präsenz:';

  @override
  String get presencesToggle =>
      'Statusnachrichten von anderen Benutzern anzeigen';

  @override
  String get singlesignon => 'Single Sign-on';

  @override
  String get skip => 'Überspringen';

  @override
  String get sourceCode => 'Quellcode';

  @override
  String get spaceIsPublic => 'Space ist öffentlich';

  @override
  String get spaceName => 'Space-Name';

  @override
  String startedACall(String senderName) {
    return '$senderName hat einen Anruf gestartet';
  }

  @override
  String get startFirstChat => 'Starte deinen ersten Chat';

  @override
  String get status => 'Status';

  @override
  String get statusExampleMessage => 'Wie geht es dir heute?';

  @override
  String get submit => 'Absenden';

  @override
  String get synchronizingPleaseWait => 'Synchronisiere... Bitte warten.';

  @override
  String get systemTheme => 'System';

  @override
  String get theyDontMatch => 'Sie stimmen nicht überein';

  @override
  String get theyMatch => 'Sie stimmen überein';

  @override
  String get title => 'Nebuchadnezzar';

  @override
  String get toggleFavorite => 'Favorit umschalten';

  @override
  String get toggleMuted => 'Stummschaltung umschalten';

  @override
  String get toggleUnread => 'Gelesen/Ungelesen markieren';

  @override
  String get tooManyRequestsWarning =>
      'Zu viele Anfragen. Bitte versuche es später noch einmal!';

  @override
  String get transferFromAnotherDevice => 'Von einem anderen Gerät übertragen';

  @override
  String get tryToSendAgain => 'Erneut senden';

  @override
  String get unavailable => 'Nicht verfügbar';

  @override
  String unbannedUser(String username, String targetName) {
    return '$username hat $targetName entbannt';
  }

  @override
  String get unblockDevice => 'Gerät entsperren';

  @override
  String get unknownDevice => 'Unbekanntes Gerät';

  @override
  String get unknownEncryptionAlgorithm =>
      'Unbekannter Verschlüsselungsalgorithmus';

  @override
  String unknownEvent(String type) {
    return 'Unbekanntes Ereignis \'$type\'';
  }

  @override
  String get unmuteChat => 'Stummschaltung aufheben';

  @override
  String get unpin => 'Loslösen';

  @override
  String unreadChats(int unreadCount) {
    String _temp0 = intl.Intl.pluralLogic(
      unreadCount,
      locale: localeName,
      other: '$unreadCount ungelesene Chats',
      one: '1 ungelesener Chat',
    );
    return '$_temp0';
  }

  @override
  String userAndOthersAreTyping(String username, int count) {
    return '$username und $count andere schreiben...';
  }

  @override
  String userAndUserAreTyping(String username, String username2) {
    return '$username und $username2 schreiben...';
  }

  @override
  String userIsTyping(String username) {
    return '$username schreibt...';
  }

  @override
  String userLeftTheChat(String username) {
    return '🚪 $username hat den Chat verlassen';
  }

  @override
  String get username => 'Benutzername';

  @override
  String userSentUnknownEvent(String username, String type) {
    return '$username hat ein $type Ereignis gesendet';
  }

  @override
  String get unverified => 'Unverifiziert';

  @override
  String get verified => 'Verifiziert';

  @override
  String get verify => 'Verifizieren';

  @override
  String get verifyStart => 'Verifizierung starten';

  @override
  String get verifySuccess => 'Du hast erfolgreich verifiziert!';

  @override
  String get verifyTitle => 'Anderes Konto verifizieren';

  @override
  String get videoCall => 'Videoanruf';

  @override
  String get visibilityOfTheChatHistory => 'Sichtbarkeit des Chatverlaufs';

  @override
  String get visibleForAllParticipants => 'Sichtbar für alle Teilnehmer';

  @override
  String get visibleForEveryone => 'Sichtbar für jeden';

  @override
  String get voiceMessage => 'Sprachnachricht';

  @override
  String get waitingPartnerAcceptRequest =>
      'Warten auf Annahme der Anfrage durch Partner...';

  @override
  String get waitingPartnerEmoji =>
      'Warten auf Annahme des Emojis durch Partner...';

  @override
  String get waitingPartnerNumbers =>
      'Warten auf Annahme der Zahlen durch Partner...';

  @override
  String get wallpaper => 'Hintergrundbild:';

  @override
  String get warning => 'Warnung!';

  @override
  String get weSentYouAnEmail => 'Wir haben dir eine E-Mail gesendet';

  @override
  String get whoCanPerformWhichAction => 'Wer darf welche Aktion ausführen';

  @override
  String get whoIsAllowedToJoinThisGroup => 'Wer darf dieser Gruppe beitreten';

  @override
  String get whyDoYouWantToReportThis => 'Warum möchtest du dies melden?';

  @override
  String get wipeChatBackup =>
      'Chat-Backup löschen, um einen neuen Wiederherstellungsschlüssel zu erstellen?';

  @override
  String get withTheseAddressesRecoveryDescription =>
      'Mit diesen Adressen kannst du dein Passwort wiederherstellen.';

  @override
  String get writeAMessage => 'Schreibe eine Nachricht...';

  @override
  String get yes => 'Ja';

  @override
  String get you => 'Du';

  @override
  String get youAreNoLongerParticipatingInThisChat =>
      'Du nimmst nicht mehr an diesem Chat teil';

  @override
  String get youHaveBeenBannedFromThisChat =>
      'Du wurdest aus diesem Chat verbannt';

  @override
  String get yourPublicKey => 'Dein öffentlicher Schlüssel';

  @override
  String get messageInfo => 'Nachricht-Info';

  @override
  String get time => 'Zeit';

  @override
  String get messageType => 'Nachrichtentyp';

  @override
  String get sender => 'Absender';

  @override
  String get openGallery => 'Galerie öffnen';

  @override
  String get removeFromSpace => 'Aus Space entfernen';

  @override
  String get addToSpaceDescription =>
      'Wähle einen Space, um diesen Chat hinzuzufügen.';

  @override
  String get start => 'Start';

  @override
  String get pleaseEnterRecoveryKeyDescription =>
      'Um deine alten Nachrichten freizuschalten, gib bitte deinen Wiederherstellungsschlüssel ein, der in einer früheren Sitzung generiert wurde. Dein Wiederherstellungsschlüssel ist NICHT dein Passwort.';

  @override
  String get publish => 'Veröffentlichen';

  @override
  String videoWithSize(String size) {
    return 'Video ($size)';
  }

  @override
  String get openChat => 'Chat öffnen';

  @override
  String get markAsRead => 'Als gelesen markieren';

  @override
  String get reportUser => 'Benutzer melden';

  @override
  String get dismiss => 'Verwerfen';

  @override
  String reactedWith(String sender, String reaction) {
    return '$sender hat mit $reaction reagiert';
  }

  @override
  String get pinMessage => 'Im Raum anpinnen';

  @override
  String get confirmEventUnpin =>
      'Bist du sicher, dass du das Ereignis dauerhaft loslösen möchtest?';

  @override
  String get emojis => 'Emojis';

  @override
  String get placeCall => 'Anrufen';

  @override
  String get voiceCall => 'Sprachanruf';

  @override
  String get unsupportedAndroidVersion => 'Nicht unterstützte Android-Version';

  @override
  String get unsupportedAndroidVersionLong =>
      'Diese Funktion erfordert eine neuere Android-Version. Bitte prüfe auf Updates oder Lineage OS-Unterstützung.';

  @override
  String get videoCallsBetaWarning =>
      'Bitte beachte, dass sich Videoanrufe derzeit in der Beta-Phase befinden. Sie funktionieren möglicherweise nicht wie erwartet oder auf allen Plattformen überhaupt nicht.';

  @override
  String get experimentalVideoCalls => 'Experimentelle Videoanrufe';

  @override
  String get emailOrUsername => 'E-Mail oder Benutzername';

  @override
  String get indexedDbErrorTitle => 'Probleme im privaten Modus';

  @override
  String get indexedDbErrorLong =>
      'Der Nachrichtenspeicher ist im privaten Modus leider standardmäßig nicht aktiviert.\nBitte besuche\n - about:config\n - setze dom.indexedDB.privateBrowsing.enabled auf true\nAndernfalls ist es nicht möglich, Nebuchadnezzar auszuführen.';

  @override
  String switchToAccount(int number) {
    return 'Zu Konto $number wechseln';
  }

  @override
  String get nextAccount => 'Nächstes Konto';

  @override
  String get previousAccount => 'Vorheriges Konto';

  @override
  String get addWidget => 'Widget hinzufügen';

  @override
  String get widgetVideo => 'Video';

  @override
  String get widgetEtherpad => 'Textnotiz';

  @override
  String get widgetJitsi => 'Jitsi Meet';

  @override
  String get widgetCustom => 'Benutzerdefiniert';

  @override
  String get widgetName => 'Name';

  @override
  String get widgetUrlError => 'Dies ist keine gültige URL.';

  @override
  String get widgetNameError => 'Bitte gib einen Anzeigenamen an.';

  @override
  String get errorAddingWidget => 'Fehler beim Hinzufügen des Widgets.';

  @override
  String get youRejectedTheInvitation => 'Du hast die Einladung abgelehnt';

  @override
  String get youJoinedTheChat => 'Du bist dem Chat beigetreten';

  @override
  String get youAcceptedTheInvitation => '👍 Du hast die Einladung angenommen';

  @override
  String youBannedUser(String user) {
    return 'Du hast $user gebannt';
  }

  @override
  String youHaveWithdrawnTheInvitationFor(String user) {
    return 'Du hast die Einladung für $user zurückgezogen';
  }

  @override
  String youInvitedToBy(String alias) {
    return '📩 Du wurdest über einen Link eingeladen zu:\n$alias';
  }

  @override
  String youInvitedBy(String user) {
    return '📩 Du wurdest eingeladen von $user';
  }

  @override
  String invitedBy(String user) {
    return '📩 Eingeladen von $user';
  }

  @override
  String youInvitedUser(String user) {
    return '📩 Du hast $user eingeladen';
  }

  @override
  String youKicked(String user) {
    return '👞 Du hast $user gekickt';
  }

  @override
  String youKickedAndBanned(String user) {
    return '🙅 Du hast $user gekickt und gebannt';
  }

  @override
  String youUnbannedUser(String user) {
    return 'Du hast $user entbannt';
  }

  @override
  String hasKnocked(String user) {
    return '🚪 $user hat angeklopft';
  }

  @override
  String get usersMustKnock => 'Benutzer müssen anklopfen';

  @override
  String get noOneCanJoin => 'Niemand kann beitreten';

  @override
  String userWouldLikeToChangeTheChat(String user) {
    return '$user möchte dem Chat beitreten.';
  }

  @override
  String get noPublicLinkHasBeenCreatedYet =>
      'Es wurde noch kein öffentlicher Link erstellt';

  @override
  String get knock => 'Anklopfen';

  @override
  String get users => 'Benutzer';

  @override
  String get unlockOldMessages => 'Alte Nachrichten freischalten';

  @override
  String get storeInSecureStorageDescription =>
      'Speichere den Wiederherstellungsschlüssel im sicheren Speicher dieses Geräts.';

  @override
  String get saveKeyManuallyDescription =>
      'Speichere diesen Schlüssel manuell über den Teilen-Dialog oder die Zwischenablage.';

  @override
  String get storeInAndroidKeystore => 'Im Android KeyStore speichern';

  @override
  String get storeInAppleKeyChain => 'Im Apple KeyChain speichern';

  @override
  String get storeSecurlyOnThisDevice => 'Sicher auf diesem Gerät speichern';

  @override
  String countFiles(int count) {
    return '$count Dateien';
  }

  @override
  String get user => 'Benutzer';

  @override
  String get custom => 'Benutzerdefiniert';

  @override
  String get foregroundServiceRunning =>
      'Diese Benachrichtigung erscheint, wenn der Vordergrunddienst läuft.';

  @override
  String get screenSharingTitle => 'Bildschirmfreigabe';

  @override
  String get screenSharingDetail =>
      'Du teilst deinen Bildschirm in Nebuchadnezzar';

  @override
  String get callingPermissions => 'Anrufberechtigungen';

  @override
  String get callingAccount => 'Anrufkonto';

  @override
  String get callingAccountDetails =>
      'Erlaubt Nebuchadnezzar, die native Android-Telefon-App zu verwenden.';

  @override
  String get appearOnTop => 'Im Vordergrund anzeigen';

  @override
  String get appearOnTopDetails =>
      'Erlaubt der App, im Vordergrund zu erscheinen (nicht notwendig, wenn du Nebuchadnezzar bereits als Anrufkonto eingerichtet hast)';

  @override
  String get otherCallingPermissions =>
      'Mikrofon, Kamera und andere Nebuchadnezzar-Berechtigungen';

  @override
  String get whyIsThisMessageEncrypted => 'Warum ist diese Nachricht unlesbar?';

  @override
  String get noKeyForThisMessage =>
      'Dies kann passieren, wenn die Nachricht gesendet wurde, bevor du dich auf diesem Gerät angemeldet hast.\n\nEs ist auch möglich, dass der Absender dein Gerät blockiert hat oder etwas mit der Internetverbindung schief gelaufen ist.\n\nKannst du die Nachricht in einer anderen Sitzung lesen? Dann kannst du die Nachricht von dort übertragen! Gehe zu Einstellungen > Geräte und stelle sicher, dass deine Geräte sich gegenseitig verifiziert haben. Wenn du den Raum das nächste Mal öffnest und beide Sitzungen im Vordergrund sind, werden die Schlüssel automatisch übertragen.\n\nMöchtest du die Schlüssel beim Abmelden oder Gerätewechsel nicht verlieren? Stelle sicher, dass du das Chat-Backup in den Einstellungen aktiviert hast.';

  @override
  String get newGroup => 'Neue Gruppe';

  @override
  String get newSpace => 'Neuer Space';

  @override
  String get enterSpace => 'Space betreten';

  @override
  String get enterRoom => 'Raum betreten';

  @override
  String get allSpaces => 'Alle Spaces';

  @override
  String numChats(int number) {
    return '$number Chats';
  }

  @override
  String get hideUnimportantStateEvents =>
      'Unwichtige Status-Ereignisse ausblenden';

  @override
  String get hidePresences => 'Statusliste ausblenden?';

  @override
  String get doNotShowAgain => 'Nicht erneut anzeigen';

  @override
  String wasDirectChatDisplayName(String oldDisplayName) {
    return 'Leerer Chat (war $oldDisplayName)';
  }

  @override
  String get newSpaceDescription =>
      'Spaces ermöglichen es dir, deine Chats zu konsolidieren und private oder öffentliche Communities aufzubauen.';

  @override
  String get encryptThisChat => 'Diesen Chat verschlüsseln';

  @override
  String get disableEncryptionWarning =>
      'Aus Sicherheitsgründen kannst du die Verschlüsselung in einem Chat nicht deaktivieren, wenn sie zuvor aktiviert wurde.';

  @override
  String get sorryThatsNotPossible => 'Entschuldigung... das ist nicht möglich';

  @override
  String get deviceKeys => 'Geräteschlüssel:';

  @override
  String get reopenChat => 'Chat wieder öffnen';

  @override
  String get noBackupWarning =>
      'Warnung! Ohne aktiviertes Chat-Backup verlierst du den Zugriff auf deine verschlüsselten Nachrichten. Es wird dringend empfohlen, das Chat-Backup zu aktivieren, bevor du dich abmeldest.';

  @override
  String get noOtherDevicesFound => 'Keine anderen Geräte gefunden';

  @override
  String fileIsTooBigForServer(int max) {
    return 'Konnte nicht gesendet werden! Der Server unterstützt nur Anhänge bis zu $max.';
  }

  @override
  String fileHasBeenSavedAt(String path) {
    return 'Datei wurde unter $path gespeichert';
  }

  @override
  String get jumpToLastReadMessage =>
      'Zur letzten gelesenen Nachricht springen';

  @override
  String get readUpToHere => 'Bis hierher gelesen';

  @override
  String get jump => 'Springen';

  @override
  String get openLinkInBrowser => 'Link im Browser öffnen';

  @override
  String get reportErrorDescription =>
      '😭 Oh nein. Etwas ist schief gelaufen. Wenn du möchtest, kannst du diesen Fehler den Entwicklern melden.';

  @override
  String get report => 'Melden';

  @override
  String get signInWithPassword => 'Mit Passwort anmelden';

  @override
  String get pleaseTryAgainLaterOrChooseDifferentServer =>
      'Bitte versuche es später noch einmal oder wähle einen anderen Server.';

  @override
  String signInWith(String provider) {
    return 'Anmelden mit $provider';
  }

  @override
  String get profileNotFound =>
      'Der Benutzer konnte auf dem Server nicht gefunden werden. Vielleicht gibt es ein Verbindungsproblem oder der Benutzer existiert nicht.';

  @override
  String get setTheme => 'Thema festlegen:';

  @override
  String get setColorTheme => 'Farbthema festlegen:';

  @override
  String get invite => 'Einladen';

  @override
  String get inviteGroupChat => '📨 Gruppenchat einladen';

  @override
  String get invitePrivateChat => '📨 Privatchat einladen';

  @override
  String get invalidInput => 'Ungültige Eingabe!';

  @override
  String wrongPinEntered(int seconds) {
    return 'Falsche PIN eingegeben! Versuche es in $seconds Sekunden erneut...';
  }

  @override
  String get pleaseEnterANumber => 'Bitte gib eine Zahl größer als 0 ein';

  @override
  String get archiveRoomDescription =>
      'Der Chat wird ins Archiv verschoben. Andere Benutzer sehen, dass du den Chat verlassen hast.';

  @override
  String get roomUpgradeDescription =>
      'Der Chat wird mit der neuen Raumversion neu erstellt. Alle Teilnehmer werden benachrichtigt, dass sie zum neuen Chat wechseln müssen. Mehr über Raumversionen erfährst du unter https://spec.matrix.org/latest/rooms/';

  @override
  String get removeDevicesDescription =>
      'Du wirst von diesem Gerät abgemeldet und kannst keine Nachrichten mehr empfangen.';

  @override
  String get banUserDescription =>
      'Der Benutzer wird aus dem Chat verbannt und kann den Chat nicht wieder betreten, bis er entbannt wird.';

  @override
  String get unbanUserDescription =>
      'Der Benutzer kann den Chat wieder betreten, wenn er es versucht.';

  @override
  String get kickUserDescription =>
      'Der Benutzer wird aus dem Chat geworfen, aber nicht verbannt. In öffentlichen Chats kann der Benutzer jederzeit wieder beitreten.';

  @override
  String get makeAdminDescription =>
      'Sobald du diesen Benutzer zum Admin machst, kannst du dies möglicherweise nicht mehr rückgängig machen, da er dann die gleichen Berechtigungen wie du hat.';

  @override
  String get pushNotificationsNotAvailable =>
      'Push-Benachrichtigungen nicht verfügbar';

  @override
  String get learnMore => 'Mehr erfahren';

  @override
  String get yourGlobalUserIdIs => 'Deine globale Benutzer-ID ist: ';

  @override
  String noUsersFoundWithQuery(String query) {
    return 'Leider konnte kein Benutzer mit \"$query\" gefunden werden. Bitte überprüfe, ob du dich vertippt hast.';
  }

  @override
  String get knocking => 'Anklopfen';

  @override
  String chatCanBeDiscoveredViaSearchOnServer(String server) {
    return 'Chat kann über die Suche auf $server gefunden werden';
  }

  @override
  String get searchChatsRooms => 'Suche nach #chats, @benutzern...';

  @override
  String get nothingFound => 'Nichts gefunden...';

  @override
  String get groupName => 'Gruppenname';

  @override
  String get createGroupAndInviteUsers =>
      'Gruppe erstellen und Benutzer einladen';

  @override
  String get groupCanBeFoundViaSearch =>
      'Gruppe kann über die Suche gefunden werden';

  @override
  String get wrongRecoveryKey =>
      'Entschuldigung... das scheint nicht der richtige Wiederherstellungsschlüssel zu sein.';

  @override
  String get startConversation => 'Unterhaltung starten';

  @override
  String get commandHint_sendraw => 'Sende rohes JSON';

  @override
  String get databaseMigrationTitle => 'Datenbank wird optimiert';

  @override
  String get databaseMigrationBody =>
      'Bitte warten. Dies kann einen Moment dauern.';

  @override
  String get leaveEmptyToClearStatus =>
      'Lasse das Feld leer, um deinen Status zu löschen.';

  @override
  String get select => 'Auswählen';

  @override
  String get searchForUsers => 'Suche nach @benutzern...';

  @override
  String get pleaseEnterYourCurrentPassword =>
      'Bitte gib dein aktuelles Passwort ein';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get pleaseChooseAStrongPassword => 'Bitte wähle ein starkes Passwort';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get passwordIsWrong => 'Dein eingegebenes Passwort ist falsch';

  @override
  String get publicLink => 'Öffentlicher Link';

  @override
  String get publicChatAddresses => 'Öffentliche Chat-Adressen';

  @override
  String get createNewAddress => 'Neue Adresse erstellen';

  @override
  String get joinSpace => 'Space beitreten';

  @override
  String get publicSpaces => 'Öffentliche Spaces';

  @override
  String get addChatOrSubSpace => 'Chat oder Sub-Space hinzufügen';

  @override
  String get subspace => 'Sub-Space';

  @override
  String get decline => 'Ablehnen';

  @override
  String get thisDevice => 'Dieses Gerät:';

  @override
  String get initAppError =>
      'Ein Fehler ist bei der Initialisierung der App aufgetreten';

  @override
  String get userRole => 'Benutzerrolle';

  @override
  String minimumPowerLevel(int level) {
    return '$level ist das minimale Berechtigungslevel.';
  }

  @override
  String searchIn(String chat) {
    return 'Suche in Chat \"$chat\"...';
  }

  @override
  String get searchMore => 'Mehr suchen...';

  @override
  String get gallery => 'Galerie';

  @override
  String get files => 'Dateien';

  @override
  String databaseBuildErrorBody(String url, String error) {
    return 'Konnte die SQLite-Datenbank nicht erstellen. Die App versucht vorerst, die alte Datenbank zu verwenden. Bitte melde diesen Fehler an die Entwickler unter $url. Die Fehlermeldung ist: $error';
  }

  @override
  String sessionLostBody(String url, String error) {
    return 'Deine Sitzung ist verloren gegangen. Bitte melde diesen Fehler an die Entwickler unter $url. Die Fehlermeldung ist: $error';
  }

  @override
  String restoreSessionBody(String url, String error) {
    return 'Die App versucht nun, deine Sitzung aus dem Backup wiederherzustellen. Bitte melde diesen Fehler an die Entwickler unter $url. Die Fehlermeldung ist: $error';
  }

  @override
  String forwardMessageTo(String roomName) {
    return 'Nachricht an $roomName weiterleiten?';
  }

  @override
  String get sendReadReceipts => 'Lesebestätigungen senden';

  @override
  String get sendTypingNotificationsDescription =>
      'Andere Teilnehmer in einem Chat können sehen, wenn du eine Nachricht schreibst.';

  @override
  String get sendReadReceiptsDescription =>
      'Andere Teilnehmer in einem Chat können sehen, wenn du eine Nachricht gelesen hast.';

  @override
  String get formattedMessages => 'Formatierte Nachrichten';

  @override
  String get formattedMessagesDescription =>
      'Zeige formatierte Nachrichteninhalte wie fetten Text mit Markdown an.';

  @override
  String get verifyOtherUser => '🔐 Anderen Benutzer verifizieren';

  @override
  String get verifyOtherUserDescription =>
      'Wenn du einen anderen Benutzer verifizierst, kannst du sicher sein, dass du wirklich mit der Person schreibst, mit der du schreiben möchtest. 💪\n\nWenn du eine Verifizierung startest, sehen du und der andere Benutzer ein Popup in der App. Dort seht ihr dann eine Reihe von Emojis oder Zahlen, die ihr miteinander vergleichen müsst.\n\nAm besten trefft ihr euch persönlich oder startet einen Videoanruf. 👭';

  @override
  String get verifyOtherDevice => '🔐 Anderes Gerät verifizieren';

  @override
  String get verifyOtherDeviceDescription =>
      'Wenn du ein anderes Gerät verifizierst, können diese Geräte Schlüssel austauschen, was deine allgemeine Sicherheit erhöht. 💪 Wenn du eine Verifizierung startest, erscheint auf beiden Geräten ein Popup in der App. Dort siehst du dann eine Reihe von Emojis oder Zahlen, die du miteinander vergleichen musst. Am besten hast du beide Geräte griffbereit, bevor du die Verifizierung startest. 🤳';

  @override
  String acceptedKeyVerification(String sender) {
    return '$sender hat die Schlüsselverifizierung akzeptiert';
  }

  @override
  String canceledKeyVerification(String sender) {
    return '$sender hat die Schlüsselverifizierung abgebrochen';
  }

  @override
  String completedKeyVerification(String sender) {
    return '$sender hat die Schlüsselverifizierung abgeschlossen';
  }

  @override
  String isReadyForKeyVerification(String sender) {
    return '$sender ist bereit für die Schlüsselverifizierung';
  }

  @override
  String requestedKeyVerification(String sender) {
    return '$sender hat die Schlüsselverifizierung angefordert';
  }

  @override
  String startedKeyVerification(String sender) {
    return '$sender hat die Schlüsselverifizierung gestartet';
  }

  @override
  String get transparent => 'Transparent';

  @override
  String get incomingMessages => 'Eingehende Nachrichten';

  @override
  String get stickers => 'Sticker';

  @override
  String get discover => 'Entdecken';

  @override
  String get commandHint_ignore => 'Ignoriere die angegebene Matrix-ID';

  @override
  String get commandHint_unignore =>
      'Mache das Ignorieren der angegebenen Matrix-ID rückgängig';

  @override
  String unreadChatsInApp(String appname, String unread) {
    return '$appname: $unread ungelesene Chats';
  }

  @override
  String get noDatabaseEncryption =>
      'Datenbankverschlüsselung wird auf dieser Plattform nicht unterstützt';

  @override
  String thereAreCountUsersBlocked(Object count) {
    return 'Derzeit sind $count Benutzer blockiert.';
  }

  @override
  String get restricted => 'Eingeschränkt';

  @override
  String get knockRestricted => 'Anklopfen eingeschränkt';

  @override
  String goToSpace(Object space) {
    return 'Gehe zu Space: $space';
  }

  @override
  String get markAsUnread => 'Als ungelesen markieren';

  @override
  String userLevel(int level) {
    return '$level - Benutzer';
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
  String get changeGeneralChatSettings => 'Allgemeine Chateinstellungen ändern';

  @override
  String get inviteOtherUsers => 'Andere Benutzer in diesen Chat einladen';

  @override
  String get changeTheChatPermissions => 'Chatberechtigungen ändern';

  @override
  String get changeTheVisibilityOfChatHistory =>
      'Sichtbarkeit des Chatverlaufs ändern';

  @override
  String get changeTheCanonicalRoomAlias =>
      'Hauptalias des öffentlichen Chats ändern';

  @override
  String get sendRoomNotifications => '@room Benachrichtigungen senden';

  @override
  String get changeTheDescriptionOfTheGroup => 'Chatbeschreibung ändern';

  @override
  String get chatPermissionsDescription =>
      'Definiere, welches Berechtigungslevel für bestimmte Aktionen in diesem Chat notwendig ist. Die Berechtigungslevel 0, 50 und 100 repräsentieren normalerweise Benutzer, Moderatoren und Admins, aber jede Abstufung ist möglich.';

  @override
  String updateInstalled(String version) {
    return '🎉 Update $version installiert!';
  }

  @override
  String get changelog => 'Änderungsprotokoll';

  @override
  String get sendCanceled => 'Senden abgebrochen';

  @override
  String get loginWithMatrixId => 'Mit Matrix-ID anmelden';

  @override
  String get discoverHomeservers => 'Homeserver entdecken';

  @override
  String get whatIsAHomeserver => 'Was ist ein Homeserver?';

  @override
  String get homeserverDescription =>
      'Alle deine Daten werden auf dem Homeserver gespeichert, genau wie bei einem E-Mail-Anbieter. Du kannst wählen, welchen Homeserver du verwenden möchtest, während du immer noch mit jedem kommunizieren kannst. Erfahre mehr unter https://matrix.org.';

  @override
  String get doesNotSeemToBeAValidHomeserver =>
      'Scheint kein kompatibler Homeserver zu sein. Falsche URL?';

  @override
  String get calculatingFileSize => 'Dateigröße wird berechnet...';

  @override
  String get prepareSendingAttachment =>
      'Bereite das Senden des Anhangs vor...';

  @override
  String get sendingAttachment => 'Sende Anhang...';

  @override
  String get generatingVideoThumbnail => 'Generiere Video-Vorschau...';

  @override
  String get compressVideo => 'Komprimiere Video...';

  @override
  String sendingAttachmentCountOfCount(int index, int length) {
    return 'Sende Anhang $index von $length...';
  }

  @override
  String serverLimitReached(int seconds) {
    return 'Serverlimit erreicht! Warte $seconds Sekunden...';
  }

  @override
  String get yesterday => 'Gestern';

  @override
  String get today => 'Heute';

  @override
  String get member => 'Mitglied';

  @override
  String get changePowerLevel => 'Berechtigungslevel ändern';

  @override
  String get canNotChangePowerLevel =>
      'Das Berechtigungslevel kann nicht geändert werden, da es nicht höher ist als das des Benutzers, dessen Level du ändern möchtest.';

  @override
  String changePowerLevelForUserToValue(Object user, Object value) {
    return 'Berechtigungslevel für $user auf $value ändern?';
  }

  @override
  String get loginInPleaseWait => 'Anmelden, bitte warten...';

  @override
  String get settingUpApplicationPleaseWait =>
      'App wird eingerichtet, bitte warten...';

  @override
  String get checkingEncryptionPleaseWait =>
      'Verschlüsselung wird geprüft, bitte warten...';

  @override
  String get settingUpEncryptionPleaseWait =>
      'Verschlüsselung wird eingerichtet, bitte warten...';

  @override
  String canonicalAliasInvalidInput(String homeServer) {
    return 'Ungültige Eingabe, muss #ETWAS:$homeServer entsprechen';
  }

  @override
  String canonicalAliasHelperText(String roomName, String homeServer) {
    return 'Beispiel: #\$$roomName:\$$homeServer';
  }

  @override
  String get shareKeysWithAllDevices => 'Schlüssel mit allen Geräten teilen';

  @override
  String get shareKeysWithCrossVerifiedDevices =>
      'Schlüssel mit querverifizierten Geräten teilen';

  @override
  String get shareKeysWithCrossVerifiedDevicesIfEnabled =>
      'Schlüssel mit querverifizierten Geräten teilen (falls aktiviert)';

  @override
  String get shareKeysWithDirectlyVerifiedDevicesOnly =>
      'Schlüssel nur mit direkt verifizierten Geräten teilen';

  @override
  String get joinRules => 'Beitrittsregeln';

  @override
  String get showTheseEventsInTheChat => 'Zeige diese Ereignisse im Chat';

  @override
  String get playMedia => 'Medien abspielen';

  @override
  String get appendToQueue => 'Zur Warteschlange hinzufügen';

  @override
  String appendedToQueue(String title) {
    return 'Zur Warteschlange hinzugefügt: $title';
  }

  @override
  String get queue => 'Warteschlange';

  @override
  String get clearQueue => 'Warteschlange leeren';

  @override
  String get queueCleared => 'Warteschlange geleert';

  @override
  String get radioBrowser => 'Radio-Browser';

  @override
  String get selectStation => 'Sender auswählen';

  @override
  String get noStationFound => 'Kein Sender gefunden';

  @override
  String get favorites => 'Favoriten';

  @override
  String get addToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get removeFromFavorites => 'Aus Favoriten entfernen';

  @override
  String get favoriteAdded => 'Favorit hinzugefügt';

  @override
  String get favoriteRemoved => 'Favorit entfernt';

  @override
  String get notSupportedByServer => 'Nicht vom Server unterstützt';

  @override
  String get radioStation => 'Radiosender';

  @override
  String get radioStations => 'Radiosender';

  @override
  String get noRadioBrowserConnected => 'Kein Radio-Browser verbunden';

  @override
  String appendMediaToQueueDescription(String title) {
    return '$title is already inside the queue. Do you want to append it to the end of the queue?';
  }

  @override
  String get appendMediaToQueueTitle => 'Medien zur Warteschlange hinzufügen';

  @override
  String appendMediaToQueue(String title) {
    return 'Medien zur Warteschlange hinzufügen: $title';
  }

  @override
  String get playNowButton => 'Jetzt abspielen';

  @override
  String get appendMediaToQueueButton => 'Zur Warteschlange hinzufügen';

  @override
  String get clipboardNotAvailable => 'Zwischenablage nicht verfügbar';

  @override
  String get noSupportedFormatFoundInClipboard =>
      'Kein unterstütztes Format in der Zwischenablage gefunden';

  @override
  String get fileIsTooLarge => 'Datei ist zu groß';

  @override
  String get notificationRuleContainsUserName => 'Enthält Benutzernamen';

  @override
  String get notificationRuleMaster => 'Master';

  @override
  String get notificationRuleSuppressNotices => 'Hinweise unterdrücken';

  @override
  String get notificationRuleInviteForMe => 'Einladung für mich';

  @override
  String get notificationRuleMemberEvent => 'Mitgliedsereignis';

  @override
  String get notificationRuleIsUserMention => 'Benutzererwähnung';

  @override
  String get notificationRuleContainsDisplayName => 'Enthält Anzeigenamen';

  @override
  String get notificationRuleIsRoomMention => 'Raumerwähnung';

  @override
  String get notificationRuleRoomnotif => 'Raum-Benachrichtigung';

  @override
  String get notificationRuleTombstone => 'Grabstein';

  @override
  String get notificationRuleReaction => 'Reaktion';

  @override
  String get notificationRuleRoomServerAcl => 'Raum-Server-ACL';

  @override
  String get notificationRuleSuppressEdits => 'Bearbeitungen unterdrücken';

  @override
  String get notificationRuleCall => 'Anruf';

  @override
  String get notificationRuleEncryptedRoomOneToOne =>
      'Verschlüsselter Raum (1:1)';

  @override
  String get notificationRuleRoomOneToOne => 'Raum (1:1)';

  @override
  String get notificationRuleMessage => 'Nachricht';

  @override
  String get notificationRuleEncrypted => 'Verschlüsselt';

  @override
  String get notificationRuleServerAcl => 'Server-ACL';

  @override
  String get notificationRuleJitsi => 'Jitsi';

  @override
  String get notificationRuleContainsUserNameDescription =>
      'Benutzername ist im Inhalt enthalten';

  @override
  String get notificationRuleMasterDescription => 'Master-Benachrichtigung';

  @override
  String get notificationRuleSuppressNoticesDescription =>
      'Hinweise unterdrücken';

  @override
  String get notificationRuleInviteForMeDescription => 'Einladung für mich';

  @override
  String get notificationRuleMemberEventDescription => 'Mitgliedsereignis';

  @override
  String get notificationRuleIsUserMentionDescription => 'Benutzererwähnung';

  @override
  String get notificationRuleContainsDisplayNameDescription =>
      'Enthält Anzeigenamen';

  @override
  String get notificationRuleIsRoomMentionDescription => 'Raumerwähnung';

  @override
  String get notificationRuleRoomnotifDescription => 'Raum-Benachrichtigung';

  @override
  String get notificationRuleTombstoneDescription => 'Grabstein';

  @override
  String get notificationRuleReactionDescription => 'Reaktion';

  @override
  String get notificationRuleRoomServerAclDescription => 'Raum-Server-ACL';

  @override
  String get notificationRuleSuppressEditsDescription =>
      'Bearbeitungen unterdrücken';

  @override
  String get notificationRuleCallDescription => 'Anruf';

  @override
  String get notificationRuleEncryptedRoomOneToOneDescription =>
      'Verschlüsselter Raum (1:1)';

  @override
  String get notificationRuleRoomOneToOneDescription => 'Raum (1:1)';

  @override
  String get notificationRuleMessageDescription => 'Nachricht';

  @override
  String get notificationRuleEncryptedDescription => 'Verschlüsselt';

  @override
  String get notificationRuleServerAclDescription => 'Server-ACL';

  @override
  String get notificationRuleJitsiDescription => 'Jitsi';

  @override
  String unknownPushRule(Object ruleId) {
    return 'Benutzerdefinierte Push-Regel $ruleId';
  }

  @override
  String get contentNotificationSettings =>
      'Inhalt-Benachrichtigungseinstellungen';

  @override
  String get generalNotificationSettings =>
      'Allgemeine Benachrichtigungseinstellungen';

  @override
  String get roomNotificationSettings => 'Raum-Benachrichtigungseinstellungen';

  @override
  String get userSpecificNotificationSettings =>
      'Benutzerspezifische Benachrichtigungseinstellungen';

  @override
  String get otherNotificationSettings =>
      'Andere Benachrichtigungseinstellungen';

  @override
  String deletePushRuleTitle(Object ruleName) {
    return 'Push-Regel $ruleName löschen?';
  }

  @override
  String deletePushRuleDescription(Object ruleName) {
    return 'Möchten Sie die Push-Regel $ruleName wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get pusherDevices => 'Pusher-Geräte';

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String get startAppUpPleaseWait => 'Wird gestartet, bitte warten...';

  @override
  String get retry => 'Wiederholen';

  @override
  String get reportIssue => 'Problem melden';

  @override
  String get closeApp => 'App schließen';

  @override
  String get creatingRoomPleaseWait => 'Raum wird erstellt, bitte warten...';

  @override
  String get creatingSpacePleaseWait =>
      'Bereich wird erstellt, bitte warten...';

  @override
  String get joiningRoomPleaseWait => 'Raum wird betreten, bitte warten...';

  @override
  String get leavingRoomPleaseWait => 'Raum wird verlassen, bitte warten...';

  @override
  String get deletingRoomPleaseWait => 'Raum wird gelöscht, bitte warten...';

  @override
  String get loadingArchivePleaseWait => 'Archiv wird geladen, bitte warten...';

  @override
  String get clearingArchivePleaseWait =>
      'Archiv wird geleert, bitte warten...';

  @override
  String get pleaseSelectAChatRoom => 'Bitte wählen Sie einen Chatraum aus';

  @override
  String get archiveIsEmpty =>
      'Es gibt noch keine archivierten Chats. Wenn Sie einen Chat verlassen, finden Sie ihn hier.';
}
