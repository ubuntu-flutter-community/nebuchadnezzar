// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get alwaysUse24HourFormat => 'false';

  @override
  String get repeatPassword => 'Repetera lösenord';

  @override
  String get notAnImage => 'Inte en bildfil.';

  @override
  String get remove => 'Ta bort';

  @override
  String get importNow => 'Importera nu';

  @override
  String get importEmojis => 'Importera emojis';

  @override
  String get importFromZipFile => 'Importera från .zip fil';

  @override
  String get exportEmotePack => 'Exportera Emote-paket som zip';

  @override
  String get replace => 'Ersätt';

  @override
  String get about => 'Om';

  @override
  String get accept => 'Acceptera';

  @override
  String acceptedTheInvitation(String username) {
    return '👍 $username accepterade inbjudan';
  }

  @override
  String get account => 'Konto';

  @override
  String activatedEndToEndEncryption(String username) {
    return '🔐 $username aktiverade end-to-end-kryptering';
  }

  @override
  String get addEmail => 'Lägg till e-post';

  @override
  String get confirmMatrixId =>
      'Vänligen bekräfta ditt Matrix ID för att radera ditt konto.';

  @override
  String supposedMxid(String mxid) {
    return 'Detta ska vara $mxid';
  }

  @override
  String get addChatDescription => 'Lägg till en chattbeskrivning...';

  @override
  String get addToSpace => 'Lägg till utrymme';

  @override
  String get admin => 'Admin';

  @override
  String get alias => 'alias';

  @override
  String get all => 'Alla';

  @override
  String get allChats => 'Alla chattar';

  @override
  String get commandHint_googly => 'Skicka några googly ögon';

  @override
  String get commandHint_cuddle => 'Skicka en gosig kram';

  @override
  String get commandHint_hug => 'Skicka en kram';

  @override
  String googlyEyesContent(String senderName) {
    return '$senderName skickar dig googly ögon';
  }

  @override
  String cuddleContent(String senderName) {
    return '$senderName kramar dig hårt';
  }

  @override
  String hugContent(String senderName) {
    return '$senderName kramar dig';
  }

  @override
  String answeredTheCall(String senderName) {
    return '$senderName svarade på samtalet';
  }

  @override
  String get anyoneCanJoin => 'Vem som helst kan gå med';

  @override
  String get appLock => 'Applås';

  @override
  String get appLockDescription =>
      'Lås appen när den inte används med en pinkod';

  @override
  String get archive => 'Archive';

  @override
  String get areGuestsAllowedToJoin => 'Får gästanvändare gå med';

  @override
  String get areYouSure => 'Är du säker?';

  @override
  String get areYouSureYouWantToLogout =>
      'Är du säker på att du vill logga ut?';

  @override
  String get askSSSSSign =>
      'För att kunna signera den andra personen, ange ditt säkra lagrade lösenord eller återställningsnyckel.';

  @override
  String askVerificationRequest(String username) {
    return 'Acceptera denna verifieringsbegäran från $username?';
  }

  @override
  String get autoplayImages =>
      'Spela automatiskt animerade klistermärken och emotes';

  @override
  String badServerLoginTypesException(
    String serverVersions,
    String supportedVersions,
  ) {
    return 'Hemservern stöder inloggningstyperna:\n$serverVersions\nMen den här appen stöder bara:\n$supportedVersions';
  }

  @override
  String get sendTypingNotifications => 'Skicka skrivaviseringar';

  @override
  String get swipeRightToLeftToReply => 'Svep höger till vänster för att svara';

  @override
  String get sendOnEnter => 'Send on enter';

  @override
  String badServerVersionsException(
    String serverVersions,
    String supportedVersions,
  ) {
    return 'Hemservern har stöd för Spec-versionerna:\n$serverVersions\nBMen den här appen stöder bara $supportedVersions';
  }

  @override
  String countChatsAndCountParticipants(String chats, Object participants) {
    return '$chats chattar och $participants deltagare';
  }

  @override
  String get noMoreChatsFound => 'Inga fler chattar hittades...';

  @override
  String get noChatsFoundHere =>
      'Inga chattar har hittats här ännu. Starta en ny chatt med någon med knappen nedan.⤵️';

  @override
  String get joinedChats => 'Anslöt sig till chattar';

  @override
  String get unread => 'Oläst';

  @override
  String get space => 'Utrymme';

  @override
  String get spaces => 'Utrymmen';

  @override
  String get banFromChat => 'Blockera från chatt';

  @override
  String get banned => 'Blockerad';

  @override
  String bannedUser(String username, String targetName) {
    return '$username blockerade $targetName';
  }

  @override
  String get blockDevice => 'Blockera enhet';

  @override
  String get blocked => 'Blockerad';

  @override
  String get botMessages => 'Botmeddelanden';

  @override
  String get cancel => 'Avbryt';

  @override
  String cantOpenUri(String uri) {
    return 'Kan inte öppna URI $uri';
  }

  @override
  String get changeDeviceName => 'Ändra enhetsnamn';

  @override
  String changedTheChatAvatar(String username) {
    return '$username ändrade chattens avatar';
  }

  @override
  String changedTheChatDescriptionTo(String username, String description) {
    return '$username ändrade chattbeskrivningen till: \'$description\'';
  }

  @override
  String changedTheChatNameTo(String username, String chatname) {
    return '$username ändrade chattnamnet till: \'$chatname\'';
  }

  @override
  String changedTheChatPermissions(String username) {
    return '$username ändrade chattbehörigheterna';
  }

  @override
  String changedTheDisplaynameTo(String username, String displayname) {
    return '$username ändrade deras visningsnamn till: \'$displayname\'';
  }

  @override
  String changedTheGuestAccessRules(String username) {
    return '$username ändrade reglerna för gäståtkomst';
  }

  @override
  String changedTheGuestAccessRulesTo(String username, String rules) {
    return '$username ändrade reglerna för gäståtkomst till: $rules';
  }

  @override
  String changedTheHistoryVisibility(String username) {
    return '$username ändrade historikens synlighet';
  }

  @override
  String changedTheHistoryVisibilityTo(String username, String rules) {
    return '$username cändrade historikens synlighet till: $rules';
  }

  @override
  String changedTheJoinRules(String username) {
    return '$username ändrade reglerna för medlemskap';
  }

  @override
  String changedTheJoinRulesTo(String username, String joinRules) {
    return '$username ändrade reglerna för medlemskap till: $joinRules';
  }

  @override
  String changedTheProfileAvatar(String username) {
    return '$username ändrade sin avatar';
  }

  @override
  String changedTheRoomAliases(String username) {
    return '$username ändrade rumsaliasen';
  }

  @override
  String changedTheRoomInvitationLink(String username) {
    return '$username ändrade inbjudningslänken';
  }

  @override
  String get changePassword => 'Ändra lösenord';

  @override
  String get changeTheHomeserver => 'Byt hemserver';

  @override
  String get changeTheme => 'Ändra din stil';

  @override
  String get changeTheNameOfTheGroup => 'Ändra namnet på gruppen';

  @override
  String get changeYourAvatar => 'Ändra din avatar';

  @override
  String get channelCorruptedDecryptError => 'Krypteringen har blivit korrupt';

  @override
  String get chat => 'Chatt';

  @override
  String get yourChatBackupHasBeenSetUp => 'Din chattbackup har ställts in.';

  @override
  String get chatBackup => 'Chat backup';

  @override
  String get chatBackupDescription =>
      'Dina gamla meddelanden är säkrade med en återställningsnyckel. Se till att du inte tappar bort den.';

  @override
  String get chatDetails => 'Chattdetaljer';

  @override
  String get chatHasBeenAddedToThisSpace =>
      'Chatten har lagts till i det här utrymmet';

  @override
  String get chats => 'Chats';

  @override
  String get chooseAStrongPassword => 'Välj ett starkt lösenord';

  @override
  String get clearArchive => 'Rensa arkiv';

  @override
  String get close => 'Stäng';

  @override
  String get commandHint_markasdm =>
      'Markera som direktmeddelanderum för det givna Matrix-ID';

  @override
  String get commandHint_markasgroup => 'Markera som grupp';

  @override
  String get commandHint_ban => 'Blockera den givna användaren från detta rum';

  @override
  String get commandHint_clearcache => 'Rensa cache';

  @override
  String get commandHint_create =>
      'Skapa en tom gruppchatt\nAnvänd --no-encryption för att inaktivera kryptering';

  @override
  String get commandHint_discardsession => 'Discard session';

  @override
  String get commandHint_dm =>
      'Starta en direkt chatt\nAnvänd --no-encryption för att inaktivera kryptering';

  @override
  String get commandHint_html => 'Skicka HTML-formaterad text';

  @override
  String get commandHint_invite =>
      'Bjud in den angivna användaren till det här rummet';

  @override
  String get commandHint_join => 'Gå med i det angivna rummet';

  @override
  String get commandHint_kick =>
      'Ta bort den angivna användaren från det här rummet';

  @override
  String get commandHint_leave => 'Lämna det här rummet';

  @override
  String get commandHint_me => 'Beskriv dig själv';

  @override
  String get commandHint_myroomavatar =>
      'Ställ in din bild för det här rummet (med mxc-uri)';

  @override
  String get commandHint_myroomnick =>
      'Ange ditt visningsnamn för det här rummet';

  @override
  String get commandHint_op =>
      'Ställ in den givna användarens effektnivå (standard: 50)';

  @override
  String get commandHint_plain => 'Skicka oformaterad text';

  @override
  String get commandHint_react => 'Skicka svar som en reaktion';

  @override
  String get commandHint_send => 'Skicka text';

  @override
  String get commandHint_unban =>
      'Avblockera den givna användaren från det här rummet';

  @override
  String get commandInvalid => 'Kommandot är ogiltigt';

  @override
  String commandMissing(String command) {
    return '$command är inte ett kommando.';
  }

  @override
  String get compareEmojiMatch => 'Vänligen jämför emojierna';

  @override
  String get compareNumbersMatch => 'Vänligen jämför numret';

  @override
  String get configureChat => 'Konfigurera chatt';

  @override
  String get confirm => 'Bekräfta';

  @override
  String get connect => 'Anslut';

  @override
  String get contactHasBeenInvitedToTheGroup =>
      'Kontakt har bjudits in till gruppen';

  @override
  String get containsDisplayName => 'Innehåller visningsnamn';

  @override
  String get containsUserName => 'Innehåller användarnamn';

  @override
  String get contentHasBeenReported =>
      'Innehållet har rapporterats till serveradministratörerna';

  @override
  String get copiedToClipboard => 'Kopierade till urklipp';

  @override
  String get copy => 'Kopiera';

  @override
  String get copyToClipboard => 'Kopiera till urklipp';

  @override
  String couldNotDecryptMessage(String error) {
    return 'Det gick inte att avkryptera meddelandet: $error';
  }

  @override
  String countParticipants(int count) {
    return '$count deltagare';
  }

  @override
  String get create => 'Skapa';

  @override
  String createdTheChat(String username) {
    return '💬 $username skapade chatten';
  }

  @override
  String get createGroup => 'Skapa grupp';

  @override
  String get createNewSpace => 'Nytt utrymme';

  @override
  String get currentlyActive => 'Nuvarande aktiva';

  @override
  String get darkTheme => 'Mörkt';

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
      'Detta kommer att inaktivera ditt användarkonto. Detta kan inte ångras! Är du säker?';

  @override
  String get defaultPermissionLevel =>
      'Standardbehörighetsnivå för nya användare';

  @override
  String get delete => 'Ta bort';

  @override
  String get deleteAccount => 'Ta bort konto';

  @override
  String get deleteMessage => 'Ta bort meddelande';

  @override
  String get device => 'Enhet';

  @override
  String get deviceId => 'Enhets-ID';

  @override
  String get devices => 'Enheter';

  @override
  String get directChats => 'Direktchattar';

  @override
  String get allRooms => 'Alla gruppchattar';

  @override
  String get displaynameHasBeenChanged => 'Visningsnamn har ändrats';

  @override
  String get downloadFile => 'Ladda ner fil';

  @override
  String get edit => 'Redigera';

  @override
  String get editBlockedServers => 'Redigera blockerade servrar';

  @override
  String get chatPermissions => 'Chattbehörigheter';

  @override
  String get editDisplayname => 'Redigera visningsnamn';

  @override
  String get editRoomAliases => 'Redigera rumsalias';

  @override
  String get editRoomAvatar => 'Redigera rumsavatar';

  @override
  String get emoteExists => 'Emote existerar redan!';

  @override
  String get emoteInvalid => 'Ogiltig kortkod för emote!';

  @override
  String get emoteKeyboardNoRecents =>
      'Nyligen använda emotes kommer att visas här...';

  @override
  String get emotePacks => 'Emote-paket för rum';

  @override
  String get emoteSettings => 'Emote inställningar';

  @override
  String get globalChatId => 'Globalt chatt-ID';

  @override
  String get accessAndVisibility => 'Tillgång och synlighet';

  @override
  String get accessAndVisibilityDescription =>
      'Vem får gå med i denna chatt och hur chatten kan upptäckas.';

  @override
  String get calls => 'Samtal';

  @override
  String get customEmojisAndStickers => 'Anpassade emojis och klistermärken';

  @override
  String get customEmojisAndStickersBody =>
      'Lägg till eller dela anpassade emojis eller klistermärken som kan användas i vilken chatt som helst.';

  @override
  String get emoteShortcode => 'Emote kortkod';

  @override
  String get emoteWarnNeedToPick =>
      'Du måste välja en emote-kortkod och en bild!';

  @override
  String get emptyChat => 'Tom chatt';

  @override
  String get enableEmotesGlobally => 'Aktivera emote-paket globalt';

  @override
  String get enableEncryption => 'Aktivera kryptering';

  @override
  String get enableEncryptionWarning =>
      'Du kommer inte att kunna inaktivera krypteringen längre. Är du säker?';

  @override
  String get encrypted => 'Krypterad';

  @override
  String get encryption => 'Kryptering';

  @override
  String get encryptionNotEnabled => 'Kryptering är inte aktiverad';

  @override
  String endedTheCall(String senderName) {
    return '$senderName avslutade samtalet';
  }

  @override
  String get enterAnEmailAddress => 'Ange en e-postadress';

  @override
  String get homeserver => 'Hemserver';

  @override
  String get enterYourHomeserver => 'Ange din hemmaserver';

  @override
  String errorObtainingLocation(String error) {
    return 'Ett fel uppstod när platsen skulle hämtasn: $error';
  }

  @override
  String get everythingReady => 'Allt redo!';

  @override
  String get extremeOffensive => 'Extremt kränkande';

  @override
  String get fileName => 'Filnamn';

  @override
  String get nebuchadnezzar => 'Nebuchadnezzar';

  @override
  String get fontSize => 'Teckenstorlek';

  @override
  String get forward => 'Vidarebefordra';

  @override
  String get fromJoining => 'Från att gå med';

  @override
  String get fromTheInvitation => 'Från inbjudan';

  @override
  String get goToTheNewRoom => 'Gå till det nya rummet';

  @override
  String get group => 'Grupp';

  @override
  String get chatDescription => 'Chattbeskrivning';

  @override
  String get chatDescriptionHasBeenChanged => 'Chattbeskrivning ändrad';

  @override
  String get groupIsPublic => 'Gruppen är offentlig';

  @override
  String get groups => 'Grupper';

  @override
  String groupWith(String displayname) {
    return 'Grupp med $displayname';
  }

  @override
  String get guestsAreForbidden => 'Gäster är förbjudna';

  @override
  String get guestsCanJoin => 'Gästerna kan gå med';

  @override
  String hasWithdrawnTheInvitationFor(String username, String targetName) {
    return '$username har återkallat inbjudan till $targetName';
  }

  @override
  String get help => 'Hjälp';

  @override
  String get hideRedactedEvents => 'Dölj borttagna händelser';

  @override
  String get hideRedactedMessages => 'Dölj borttagna meddelanden';

  @override
  String get hideRedactedMessagesBody =>
      'Om någon tar bort ett meddelande kommer detta meddelande inte att vara synligt i chatten längre.';

  @override
  String get hideInvalidOrUnknownMessageFormats =>
      'Dölj ogiltiga eller okända meddelandeformat';

  @override
  String get howOffensiveIsThisContent => 'Hur stötande är detta innehåll?';

  @override
  String get id => 'ID';

  @override
  String get identity => 'Identitet';

  @override
  String get block => 'Blockera';

  @override
  String get blockedUsers => 'Blockerade användare';

  @override
  String get blockListDescription =>
      'Du kan blockera användare som stör dig. Du kommer inte att kunna ta emot några meddelanden eller rumsinbjudningar från användarna på din personliga blockeringslista.';

  @override
  String blockUsername(String username) {
    return 'Ignore användarnamn';
  }

  @override
  String get iHaveClickedOnLink => 'Jag har klickat på länken';

  @override
  String get incorrectPassphraseOrKey =>
      'Felaktig lösenfras eller återställningsnyckel';

  @override
  String get inoffensive => 'Oförarglig';

  @override
  String get inviteContact => 'Bjud in kontakt';

  @override
  String inviteContactToGroupQuestion(String contact, String groupName) {
    return 'Vill du bjuda in $contact till chatten \"$groupName\"?';
  }

  @override
  String get noChatDescriptionYet => 'Ingen chattbeskrivning har skapats ännu.';

  @override
  String get tryAgain => 'Försök igen';

  @override
  String get invalidServerName => 'Ogiltigt servernamn';

  @override
  String get invited => 'Inbjudna';

  @override
  String get redactMessageDescription =>
      'Meddelandet kommer att tas bort för alla deltagare i denna konversation. Detta kan inte ångras.';

  @override
  String get optionalRedactReason =>
      '(Valfritt) Anledning till att ta bort detta meddelande...';

  @override
  String invitedUser(String username, String targetName) {
    return '📩 $username bjöd in $targetName';
  }

  @override
  String get invitedUsersOnly => 'Endast inbjudna användare';

  @override
  String get inviteForMe => 'Bjud in åt mig';

  @override
  String inviteText(String username, String link) {
    return '$username bjöd in dig till Nebuchadnezzar.\n1. Besök https://snapcraft.io/nebuchadnezzar och installera appen\n2. Registrera dig eller logga in \n3. Öppna inbjudningslänken: \n $link';
  }

  @override
  String get isTyping => 'skriver…';

  @override
  String joinedTheChat(String username) {
    return '👋 $username gick med i chatten';
  }

  @override
  String get joinRoom => 'Gå med i rum';

  @override
  String kicked(String username, String targetName) {
    return '👞 $username sparkade ut $targetName';
  }

  @override
  String kickedAndBanned(String username, String targetName) {
    return '🙅 $username sparkade ut och blockerade $targetName';
  }

  @override
  String get kickFromChat => 'Utsparkad från chatten';

  @override
  String lastActiveAgo(String localizedTimeShort) {
    return 'Senast aktiv: $localizedTimeShort';
  }

  @override
  String get leave => 'Lämna';

  @override
  String get leftTheChat => 'Lämnade chatten';

  @override
  String get license => 'Licens';

  @override
  String get lightTheme => 'Ljust';

  @override
  String loadCountMoreParticipants(int count) {
    return 'Ladda $count mer deltagare';
  }

  @override
  String get dehydrate => 'Exportera session och rensa enheten';

  @override
  String get dehydrateWarning =>
      'Denna åtgärd kan inte ångras. Se till att du lagrar säkerhetskopian på ett säkert sätt.';

  @override
  String get dehydrateTor => 'TOR användare: Exportera session';

  @override
  String get dehydrateTorLong =>
      'För TOR användare, det rekommenderas att exportera sessionen innan du stänger fönstret.';

  @override
  String get hydrateTor => 'TOR användare: Importera sessionsexport';

  @override
  String get hydrateTorLong =>
      'Exporterade du din session förra gången på TOR? Importera den snabbt och fortsätt chatta.';

  @override
  String get hydrate => 'Återställ från backupfil';

  @override
  String get loadingPleaseWait => 'Laddar... Var god vänta.';

  @override
  String get loadMore => 'Ladda mer…';

  @override
  String get locationDisabledNotice =>
      'Platstjänster är inaktiverade. Vänligen aktivera dem för att kunna dela din plats.';

  @override
  String get locationPermissionDeniedNotice =>
      'Platsbehörighet nekades. Bevilja dem för att dela din plats.';

  @override
  String get login => 'Logga in';

  @override
  String logInTo(String homeserver) {
    return 'Logga in till $homeserver';
  }

  @override
  String get logout => 'Logga ut';

  @override
  String get memberChanges => 'Medlemsförändringar';

  @override
  String get mention => 'Nämn';

  @override
  String get messages => 'Meddelanden';

  @override
  String get messagesStyle => 'Meddelanden:';

  @override
  String get moderator => 'Moderator';

  @override
  String get muteChat => 'Stäng av ljudet för chatten';

  @override
  String get needPantalaimonWarning =>
      'Var medveten om att du behöver Pantalaimon för att använda end-to-end-kryptering för tillfället.';

  @override
  String get newChat => 'Ny chatt';

  @override
  String get newMessageInNebuchadnezzar =>
      '💬 Nytt meddelande i Nebuchadnezzar';

  @override
  String get newVerificationRequest => 'Ny verifieringsförfrågan!';

  @override
  String get next => 'Nästa';

  @override
  String get no => 'Nej';

  @override
  String get noConnectionToTheServer => 'Ingen anslutning till servern';

  @override
  String get noEmotesFound => 'Inga emotes hittades. 😕';

  @override
  String get noEncryptionForPublicRooms =>
      'Du kan bara aktivera kryptering så snart rummet inte längre är allmänt tillgängligt.';

  @override
  String get noGoogleServicesWarning =>
      'Firebase Cloud Messaging verkar inte vara tillgängligt på din enhet. För att fortfarande få push-meddelanden rekommenderar vi att du installerar ntfy. Med ntfy eller annan Unified Push-leverantör kan du ta emot push-meddelanden på ett datasäkert sätt. Du kan ladda ner ntfy från Play Store eller från F-Droid.';

  @override
  String noMatrixServer(String server1, String server2) {
    return '$server1 finns ingen matrisserver, använd $server2 istället?';
  }

  @override
  String get shareInviteLink => 'Dela inbjudningslänk';

  @override
  String get scanQrCode => 'Skanna QR-kod';

  @override
  String get none => 'Ingen';

  @override
  String get noPasswordRecoveryDescription =>
      'Du har inte lagt till något sätt att återställa ditt lösenord än.';

  @override
  String get noPermission => 'Inga behörigheter';

  @override
  String get noRoomsFound => 'Inga rum hittades…';

  @override
  String get notifications => 'Aviseringar';

  @override
  String get notificationsEnabledForThisAccount =>
      'Aviseringar aktiverat för detta konto';

  @override
  String numUsersTyping(int count) {
    return '$count användare skriver…';
  }

  @override
  String get obtainingLocation => 'Erhåller plats…';

  @override
  String get offensive => 'Offensiv';

  @override
  String get offline => 'Offline';

  @override
  String get ok => 'Ok';

  @override
  String get online => 'Online';

  @override
  String get onlineKeyBackupEnabled =>
      'Onlinenyckelsäkerhetskopiering är aktiverad';

  @override
  String get oopsPushError =>
      'Oj! Tyvärr uppstod ett fel när du satte upp push-meddelanden.';

  @override
  String get oopsSomethingWentWrong => 'Oj, något gick fel...';

  @override
  String get openAppToReadMessages => 'Öppna app för att läsa meddelanden';

  @override
  String get openCamera => 'Öppna kamera';

  @override
  String get openVideoCamera => 'Öppna kamera för en video';

  @override
  String get oneClientLoggedOut => 'En av dina klienter har loggats ut';

  @override
  String get addAccount => 'Lägg till konto';

  @override
  String get editBundlesForAccount => 'Redigera paket för detta konto';

  @override
  String get addToBundle => 'Lägg till i paket';

  @override
  String get removeFromBundle => 'Ta bort från detta paket';

  @override
  String get bundleName => 'Paketnamn';

  @override
  String get enableMultiAccounts =>
      '(BETA) Aktivera flera konton på den här enheten';

  @override
  String get openInMaps => 'Öppna i kartor';

  @override
  String get link => 'Länk';

  @override
  String get serverRequiresEmail =>
      'Denna server måste validera din e-postadress för registrering.';

  @override
  String get or => 'Or';

  @override
  String get participant => 'Deltagare';

  @override
  String get passphraseOrKey => 'lösenfras eller återställningsnyckel';

  @override
  String get password => 'Lösenord';

  @override
  String get passwordForgotten => 'Glömt lösenord';

  @override
  String get passwordHasBeenChanged => 'Lösenordet har ändrats';

  @override
  String get hideMemberChangesInPublicChats =>
      'Dölj medlemsändringar i offentliga chattar';

  @override
  String get hideMemberChangesInPublicChatsBody =>
      'Visa inte i chatttidslinjen om någon går med i eller lämnar en offentlig chatt för att förbättra läsbarheten.';

  @override
  String get overview => 'Översikt';

  @override
  String get notifyMeFor => 'Meddela mig för';

  @override
  String get passwordRecoverySettings => 'Lösenordsåterställningsinställningar';

  @override
  String get passwordRecovery => 'Lösenordsåterställning';

  @override
  String get people => 'Personer';

  @override
  String get pickImage => 'Välj en bild';

  @override
  String get pin => 'Nåla';

  @override
  String play(String fileName) {
    return 'Spela $fileName';
  }

  @override
  String get pleaseChoose => 'Vänligen välj';

  @override
  String get pleaseChooseAPasscode => 'Vänligen välj en lösenordskod';

  @override
  String get pleaseClickOnLink =>
      'Vänligen klicka på länken i e-postmeddelandet och fortsätt sedan.';

  @override
  String get pleaseEnter4Digits =>
      'Ange 4 siffror eller lämna tomt för att inaktivera applås.';

  @override
  String get pleaseEnterRecoveryKey => 'Ange din återställningsnyckel:';

  @override
  String get pleaseEnterYourPassword => 'Ange ditt lösenord';

  @override
  String get pleaseEnterYourPin => 'Ange din pinkod';

  @override
  String get pleaseEnterYourUsername => 'Vänligen ange ditt användarnamn';

  @override
  String get pleaseFollowInstructionsOnWeb =>
      'Vänligen följ instruktionerna på webbplatsen och tryck på nästa.';

  @override
  String get privacy => 'Sekretess';

  @override
  String get publicRooms => 'Allmänna rum';

  @override
  String get pushRules => 'Push regler';

  @override
  String get reason => 'Andledning';

  @override
  String get recording => 'Inspelning';

  @override
  String redactedBy(String username) {
    return 'Borttaget av $username';
  }

  @override
  String get directChat => 'Direktchatt';

  @override
  String redactedByBecause(String username, String reason) {
    return 'Borttaget av $username på grund av: \"$reason\"';
  }

  @override
  String redactedAnEvent(String username) {
    return '$username tog bort en händelse';
  }

  @override
  String get redactMessage => 'Ta bort meddelande';

  @override
  String get register => 'Registrera';

  @override
  String get reject => 'Avvisa';

  @override
  String rejectedTheInvitation(String username) {
    return '$username avslog inbjudan';
  }

  @override
  String get rejoin => 'Gå med igen';

  @override
  String get removeAllOtherDevices => 'Ta bort alla andra enheter';

  @override
  String removedBy(String username) {
    return 'Togs bort av $username';
  }

  @override
  String get removeDevice => 'Ta bort enhet';

  @override
  String get unbanFromChat => 'Ta bort blockeringen från chatten';

  @override
  String get removeYourAvatar => 'Ta bort din avatar';

  @override
  String get replaceRoomWithNewerVersion =>
      'Byt ut rummet mot en nyare version';

  @override
  String get reply => 'Svara';

  @override
  String get reportMessage => 'Rapportera meddelande';

  @override
  String get requestPermission => 'Begär behörigheter';

  @override
  String get roomHasBeenUpgraded => 'Rummet har uppgraderats';

  @override
  String get roomVersion => 'Rumsversion';

  @override
  String get saveFile => 'Spara fil';

  @override
  String get search => 'Sök';

  @override
  String get security => 'Säkerhet';

  @override
  String get recoveryKey => 'Återställningsnyckel';

  @override
  String get recoveryKeyLost => 'Återställningsnyckel förlorad?';

  @override
  String seenByUser(String username) {
    return 'Sett av $username';
  }

  @override
  String get send => 'Skicka';

  @override
  String get sendAMessage => 'Skicka ett meddelande ';

  @override
  String get sendAsText => 'Skicka som text';

  @override
  String get sendAudio => 'Skicka ljud';

  @override
  String get sendFile => 'Skicka fil';

  @override
  String get sendImage => 'Skicka bild';

  @override
  String get sendMessages => 'Skicka meddelanden';

  @override
  String get sendOriginal => 'Skicka original';

  @override
  String get sendSticker => 'Skicka klistermärke';

  @override
  String get sendVideo => 'Skicka video';

  @override
  String sentAFile(String username) {
    return '📁 $username har skickat en fil';
  }

  @override
  String sentAnAudio(String username) {
    return '🎤 $username skickade ett ljud';
  }

  @override
  String sentAPicture(String username) {
    return '🖼️ $username skickade en bild';
  }

  @override
  String sentASticker(String username) {
    return '😊 $username skickade ett klistermärke';
  }

  @override
  String sentAVideo(String username) {
    return '🎥 $username skickade en video';
  }

  @override
  String sentCallInformations(String senderName) {
    return '$senderName skickade samtalsinformation';
  }

  @override
  String get separateChatTypes => 'Separata direktchatt och grupper';

  @override
  String get setAsCanonicalAlias => 'Ställ in som huvudalias';

  @override
  String get setCustomEmotes => 'Ställ in anpassade emotes';

  @override
  String get setChatDescription => 'Ställ in chattbeskrivning';

  @override
  String get setInvitationLink => 'Ställ in inbjudningslänk';

  @override
  String get setPermissionsLevel => 'Ställ in behörighetsnivå';

  @override
  String get setStatus => 'Ställ in status';

  @override
  String get settings => 'Inställningar';

  @override
  String get share => 'Dela';

  @override
  String sharedTheLocation(String username) {
    return '$username delade sin plats';
  }

  @override
  String get shareLocation => 'Dela plats';

  @override
  String get showPassword => 'Visa lösenord';

  @override
  String get presenceStyle => 'Närvaro:';

  @override
  String get presencesToggle => 'SVisa statusmeddelanden från andra användare';

  @override
  String get singlesignon => 'Enkel inloggning';

  @override
  String get skip => 'Hoppa över';

  @override
  String get sourceCode => 'Källkod';

  @override
  String get spaceIsPublic => 'Utrymmet är offentligt';

  @override
  String get spaceName => 'Namn på utrymmet';

  @override
  String startedACall(String senderName) {
    return '$senderName startade ett samtal';
  }

  @override
  String get startFirstChat => 'Starta din första chatt';

  @override
  String get status => 'Status';

  @override
  String get statusExampleMessage => 'Hur mår du idag?';

  @override
  String get submit => 'Skicka in';

  @override
  String get synchronizingPleaseWait => 'Synkroniserar... Vänta.';

  @override
  String get systemTheme => 'System';

  @override
  String get theyDontMatch => 'De matchar inte';

  @override
  String get theyMatch => 'De matchar';

  @override
  String get title => 'Nebuchadnezzar';

  @override
  String get toggleFavorite => 'Växla Favorit';

  @override
  String get toggleMuted => 'Växla tyst';

  @override
  String get toggleUnread => 'Markera Läst/Oläst';

  @override
  String get tooManyRequestsWarning =>
      'För många förfrågningar. Försök igen senare!';

  @override
  String get transferFromAnotherDevice => 'Överför från en annan enhet';

  @override
  String get tryToSendAgain => 'Försök att skicka igen';

  @override
  String get unavailable => 'Inte tillgänglig';

  @override
  String unbannedUser(String username, String targetName) {
    return '$username oförbjuden $targetName';
  }

  @override
  String get unblockDevice => 'Avblockera enhet';

  @override
  String get unknownDevice => 'Okänd enhet';

  @override
  String get unknownEncryptionAlgorithm => 'Okänd krypteringsalgoritm';

  @override
  String unknownEvent(String type) {
    return 'Okänd händelse \'$type\'';
  }

  @override
  String get unmuteChat => 'Slå på ljudet för chatten';

  @override
  String get unpin => 'Frigör';

  @override
  String unreadChats(int unreadCount) {
    String _temp0 = intl.Intl.pluralLogic(
      unreadCount,
      locale: localeName,
      other: '$unreadCount olästa chattar',
      one: '1 oläst chatt',
    );
    return '$_temp0';
  }

  @override
  String userAndOthersAreTyping(String username, int count) {
    return '$username och $count andra skriver…';
  }

  @override
  String userAndUserAreTyping(String username, String username2) {
    return '$username och $username2 skriver…';
  }

  @override
  String userIsTyping(String username) {
    return '$username skriver…';
  }

  @override
  String userLeftTheChat(String username) {
    return '🚪 $username lämnade chatten';
  }

  @override
  String get username => 'Användarnamn';

  @override
  String userSentUnknownEvent(String username, String type) {
    return '$username skickade en $type händelse';
  }

  @override
  String get unverified => 'Ej verifierad';

  @override
  String get verified => 'Verifierad';

  @override
  String get verify => 'Verifiera';

  @override
  String get verifyStart => 'Starta verifiering';

  @override
  String get verifySuccess => 'Du har verifierats!';

  @override
  String get verifyTitle => 'Verifierar annat konto';

  @override
  String get videoCall => 'Videosamtal';

  @override
  String get visibilityOfTheChatHistory => 'Synlighet för chatthistoriken';

  @override
  String get visibleForAllParticipants => 'Synlig för alla deltagare';

  @override
  String get visibleForEveryone => 'Synlig för alla';

  @override
  String get voiceMessage => 'Röstmeddelande';

  @override
  String get waitingPartnerAcceptRequest =>
      'Väntar på att partner ska acceptera begäran…';

  @override
  String get waitingPartnerEmoji =>
      'Väntar på att partner ska acceptera emojin…';

  @override
  String get waitingPartnerNumbers =>
      'Väntar på att partner ska acceptera numret…';

  @override
  String get wallpaper => 'Bakgrund:';

  @override
  String get warning => 'Varning!';

  @override
  String get weSentYouAnEmail => 'Vi har skickat ett e-postmeddelande till dig';

  @override
  String get whoCanPerformWhichAction => 'Vem kan utföra vilken åtgärd';

  @override
  String get whoIsAllowedToJoinThisGroup => 'Vem får gå med i denna grupp';

  @override
  String get whyDoYouWantToReportThis => 'Varför vill du rapportera detta?';

  @override
  String get wipeChatBackup =>
      'Kasta din chattsäkerhetskopia för att skapa en ny återställningsnyckel?';

  @override
  String get withTheseAddressesRecoveryDescription =>
      'Med dessa adresser kan du återställa ditt lösenord.';

  @override
  String get writeAMessage => 'Skriv ett meddelande…';

  @override
  String get yes => 'Ja';

  @override
  String get you => 'Du';

  @override
  String get youAreNoLongerParticipatingInThisChat =>
      'Du deltar inte längre i den här chatten';

  @override
  String get youHaveBeenBannedFromThisChat =>
      'Du har blivit avstängd från den här chatten';

  @override
  String get yourPublicKey => 'Din publika nyckel';

  @override
  String get messageInfo => 'Meddelandeinformation';

  @override
  String get time => 'Time';

  @override
  String get messageType => 'Meddelandetyp';

  @override
  String get sender => 'Avsändare';

  @override
  String get openGallery => 'Öppna galleri';

  @override
  String get removeFromSpace => 'Ta bort från utrymmet';

  @override
  String get addToSpaceDescription =>
      'Välj ett utrymme för att lägga till denna chatt till den.';

  @override
  String get start => 'Start';

  @override
  String get pleaseEnterRecoveryKeyDescription =>
      'För att låsa upp dina gamla meddelanden, ange din återställningsnyckel som har genererats i en tidigare session. Din återställningsnyckel är INTE ditt lösenord.';

  @override
  String get publish => 'Publicera';

  @override
  String videoWithSize(String size) {
    return 'Video ($size)';
  }

  @override
  String get openChat => 'Öppna chatt';

  @override
  String get markAsRead => 'Markera som läst';

  @override
  String get reportUser => 'Rapportera användare';

  @override
  String get dismiss => 'Avvisa';

  @override
  String reactedWith(String sender, String reaction) {
    return '$sender reagerade med $reaction';
  }

  @override
  String get pinMessage => 'Nåla fast i rummet';

  @override
  String get confirmEventUnpin =>
      'Är du säker på att permanent lossa händelsen?';

  @override
  String get emojis => 'Emojis';

  @override
  String get placeCall => 'Ring samtal';

  @override
  String get voiceCall => 'Röstsamtal';

  @override
  String get unsupportedAndroidVersion => 'Android-version som inte stöds';

  @override
  String get unsupportedAndroidVersionLong =>
      'Den här funktionen kräver en nyare Android-version. Kontrollera om det finns uppdateringar eller stöd för Lineage OS.';

  @override
  String get videoCallsBetaWarning =>
      'Observera att videosamtal för närvarande är i beta. De kanske inte fungerar som förväntat eller fungerar alls på alla plattformar.';

  @override
  String get experimentalVideoCalls => 'Experimentella videosamtal';

  @override
  String get emailOrUsername => 'E-post eller användarnamn';

  @override
  String get indexedDbErrorTitle => 'Problem med privat läge';

  @override
  String get indexedDbErrorLong =>
      'Meddelandelagringen är tyvärr inte aktiverad i privat läge som standard.\nPVänligen besök\n - about:config\n - ställ in dom.indexedDB.privateBrowsing.enabled till sant\nAnnars går det inte att köra Nebuchadnezzar.';

  @override
  String switchToAccount(int number) {
    return 'Ändra till konto $number';
  }

  @override
  String get nextAccount => 'Nästa konto';

  @override
  String get previousAccount => 'Föregående konto';

  @override
  String get addWidget => 'Lägg till widget';

  @override
  String get widgetVideo => 'Video';

  @override
  String get widgetEtherpad => 'Textanteckning';

  @override
  String get widgetJitsi => 'Jitsi Meet';

  @override
  String get widgetCustom => 'Anpassad';

  @override
  String get widgetName => 'Namn';

  @override
  String get widgetUrlError => 'Detta är inte en giltig URL.';

  @override
  String get widgetNameError => 'Ange ett visningsnamn.';

  @override
  String get errorAddingWidget =>
      'Ett fel uppstod när widgeten skulle läggas till.';

  @override
  String get youRejectedTheInvitation => 'Du avvisade inbjudan';

  @override
  String get youJoinedTheChat => 'Du gick med i chatten';

  @override
  String get youAcceptedTheInvitation => '👍 Du tackade ja till inbjudan';

  @override
  String youBannedUser(String user) {
    return 'Du blockerade $user';
  }

  @override
  String youHaveWithdrawnTheInvitationFor(String user) {
    return 'Du har dragit tillbaka inbjudan för $user';
  }

  @override
  String youInvitedToBy(String alias) {
    return '📩 Du har blivit inbjuden via länk till:\n$alias';
  }

  @override
  String youInvitedBy(String user) {
    return '📩 Du har blivit inbjuden av $user';
  }

  @override
  String invitedBy(String user) {
    return '📩 Inbjuden av $user';
  }

  @override
  String youInvitedUser(String user) {
    return '📩 Du bjöd in $user';
  }

  @override
  String youKicked(String user) {
    return '👞 Du sparkade ut $user';
  }

  @override
  String youKickedAndBanned(String user) {
    return '🙅 Du sparkade ut och blockerade $user';
  }

  @override
  String youUnbannedUser(String user) {
    return 'Du avblockerade $user';
  }

  @override
  String hasKnocked(String user) {
    return '🚪 $user har knackat';
  }

  @override
  String get usersMustKnock => 'Användare måste knacka';

  @override
  String get noOneCanJoin => 'Ingen får gå med';

  @override
  String userWouldLikeToChangeTheChat(String user) {
    return '$user vill gå med i chatten.';
  }

  @override
  String get noPublicLinkHasBeenCreatedYet =>
      'Ingen offentlig länk har skapats ännu';

  @override
  String get knock => 'Knacka';

  @override
  String get users => 'Användare';

  @override
  String get unlockOldMessages => 'Lås upp gamla meddelanden';

  @override
  String get storeInSecureStorageDescription =>
      'Förvara återställningsnyckeln på den här enhetens säkra lagring.';

  @override
  String get saveKeyManuallyDescription =>
      'Spara den här nyckeln manuellt genom att aktivera systemdelningsdialogrutan eller urklipp.';

  @override
  String get storeInAndroidKeystore => 'Lagra i Android KeyStore';

  @override
  String get storeInAppleKeyChain => 'Lagra i Apple Keychain';

  @override
  String get storeSecurlyOnThisDevice => 'Förvara säkert på den här enheten';

  @override
  String countFiles(int count) {
    return '$count filer';
  }

  @override
  String get user => 'Användare';

  @override
  String get custom => 'Anpassat';

  @override
  String get foregroundServiceRunning =>
      'Detta meddelande visas när förgrundstjänsten körs.';

  @override
  String get screenSharingTitle => 'Skärmdelning';

  @override
  String get screenSharingDetail => 'Du delar din skärm i Nebuchadnezzar';

  @override
  String get callingPermissions => 'Ringbehörigheter';

  @override
  String get callingAccount => 'Ringer konto';

  @override
  String get callingAccountDetails =>
      'Tillåter Nebuchadnezzar att använda den ursprungliga uppringningsappen för Android.';

  @override
  String get appearOnTop => 'Visas överst';

  @override
  String get appearOnTopDetails =>
      'Tillåter att appen visas överst (behövs inte om du redan har konfigurerat Fluffychat som ett samtalskonto)';

  @override
  String get otherCallingPermissions =>
      'Mikrofon, kamera och andra Nebuchadnezzar-behörigheter';

  @override
  String get whyIsThisMessageEncrypted =>
      'Varför är detta meddelande oläsbart?';

  @override
  String get noKeyForThisMessage =>
      'Detta kan hända om meddelandet skickades innan du har loggat in på ditt konto på den här enheten.\n\nDet är också möjligt att avsändaren har blockerat din enhet eller att något gick fel med internetanslutningen.\n\nKan du läsa meddelandet på en annan session? Då kan du överföra meddelandet från den! Gå till Inställningar > Enheter och se till att dina enheter har verifierat varandra. När du öppnar rummet nästa gång och båda sessionerna är i förgrunden kommer nycklarna att överföras automatiskt.\n\nVill du inte tappa nycklarna när du loggar ut eller byter enhet? Se till att du har aktiverat chattsäkerhetskopieringen i inställningarna.';

  @override
  String get newGroup => 'Ny grupp';

  @override
  String get newSpace => 'Nytt utrymme';

  @override
  String get enterSpace => 'Gå med i utrymme';

  @override
  String get enterRoom => 'Gå med i rum';

  @override
  String get allSpaces => 'Alla utrymmen';

  @override
  String numChats(int number) {
    return '$number chatter';
  }

  @override
  String get hideUnimportantStateEvents => 'Dölj oviktiga tillståndshändelser';

  @override
  String get hidePresences => 'Dölj statuslista?';

  @override
  String get doNotShowAgain => 'Visa inte igen';

  @override
  String wasDirectChatDisplayName(String oldDisplayName) {
    return 'Tom chatt (var $oldDisplayName)';
  }

  @override
  String get newSpaceDescription =>
      'Utrymmen låter dig konsolidera dina chattar och bygga privata eller offentliga gemenskaper.';

  @override
  String get encryptThisChat => 'Kryptera denna chatt';

  @override
  String get disableEncryptionWarning =>
      'Av säkerhetsskäl kan du inte inaktivera kryptering i en chatt, där den har aktiverats tidigare.';

  @override
  String get sorryThatsNotPossible => 'Tyvärr... det är inte möjligt';

  @override
  String get deviceKeys => 'Enhetsnycklar:';

  @override
  String get reopenChat => 'Öppna chatten igen';

  @override
  String get noBackupWarning =>
      'Varning! Utan att aktivera chattsäkerhetskopiering förlorar du åtkomst till dina krypterade meddelanden. Det rekommenderas starkt att aktivera chattbackupen först innan du loggar ut.';

  @override
  String get noOtherDevicesFound => 'Inga andra enheter hittades';

  @override
  String fileIsTooBigForServer(int max) {
    return 'Kan inte skicka! Servern stöder endast bilagor upp till $max.';
  }

  @override
  String fileHasBeenSavedAt(String path) {
    return 'Filen har sparats på $path';
  }

  @override
  String get jumpToLastReadMessage => 'Hoppa till senast lästa meddelande';

  @override
  String get readUpToHere => 'Läs fram till här';

  @override
  String get jump => 'Hoppa';

  @override
  String get openLinkInBrowser => 'Öppna länk i webbläsare';

  @override
  String get reportErrorDescription =>
      '😭 Åh nej. Något gick fel. Om du vill kan du rapportera detta fel till utvecklarna.';

  @override
  String get report => 'rapportera';

  @override
  String get signInWithPassword => 'Logga in med lösenord';

  @override
  String get pleaseTryAgainLaterOrChooseDifferentServer =>
      'Försök igen senare eller välj en annan server.';

  @override
  String signInWith(String provider) {
    return 'Logga in med $provider';
  }

  @override
  String get profileNotFound =>
      'Användaren kunde inte hittas på servern. Kanske finns det ett anslutningsproblem eller så finns inte användaren.';

  @override
  String get setTheme => 'Ställ in tema:';

  @override
  String get setColorTheme => 'Ställ in färgtema:';

  @override
  String get invite => 'Bjud in';

  @override
  String get inviteGroupChat => '📨 Bjud in till gruppchatt';

  @override
  String get invitePrivateChat => '📨 Bjud in till privatchatt';

  @override
  String get invalidInput => 'Ogiltig inmatning!';

  @override
  String wrongPinEntered(int seconds) {
    return 'Fel pin har angetts! Försök igen om $seconds sekunder...';
  }

  @override
  String get pleaseEnterANumber => 'Ange ett nummer som är större än 0';

  @override
  String get archiveRoomDescription =>
      'Chatten kommer att flyttas till arkivet. Andra användare kommer att kunna se att du har lämnat chatten.';

  @override
  String get roomUpgradeDescription =>
      'Chatten kommer sedan att återskapas med den nya rumsversionen. Alla deltagare kommer att meddelas att de behöver byta till den nya chatten. Du kan ta reda på mer om rumsversioner på https://spec.matrix.org/latest/rooms/';

  @override
  String get removeDevicesDescription =>
      'Du kommer att loggas ut från den här enheten och kommer inte längre att kunna ta emot meddelanden.';

  @override
  String get banUserDescription =>
      'Användaren kommer att bli avstängd från chatten och kommer inte att kunna gå in i chatten igen förrän de är välkommna igen.';

  @override
  String get unbanUserDescription =>
      'Användaren kommer att kunna gå in i chatten igen om de försöker.';

  @override
  String get kickUserDescription =>
      'Användaren kastas ut från chatten men blockeras inte. I offentliga chattar kan användaren gå med igen när som helst.';

  @override
  String get makeAdminDescription =>
      'När du väl har gjort den här användaren till administratör kanske du inte kan ångra detta eftersom de då har samma behörigheter som du.';

  @override
  String get pushNotificationsNotAvailable =>
      'Pushnotiser är inte tillgängliga';

  @override
  String get learnMore => 'Läs mer';

  @override
  String get yourGlobalUserIdIs => 'Ditt globala användar-ID är: ';

  @override
  String noUsersFoundWithQuery(String query) {
    return 'Tyvärr kunde ingen användare hittas med \"$query\". Kontrollera om du gjort ett stavfel.';
  }

  @override
  String get knocking => 'Knacka';

  @override
  String chatCanBeDiscoveredViaSearchOnServer(String server) {
    return 'Chatten kan upptäckas via sökningen på $server';
  }

  @override
  String get searchChatsRooms => 'Sök efter #chattar, @användare...';

  @override
  String get nothingFound => 'Inget hittades...';

  @override
  String get groupName => 'Gruppnamn';

  @override
  String get createGroupAndInviteUsers =>
      'Skapa en grupp och bjud in användare';

  @override
  String get groupCanBeFoundViaSearch => 'Gruppen kan hittas via sök';

  @override
  String get wrongRecoveryKey =>
      'Förlåt... detta verkar inte vara rätt återställningsnyckel.';

  @override
  String get startConversation => 'Starta konversation';

  @override
  String get commandHint_sendraw => 'Skicka rå json';

  @override
  String get databaseMigrationTitle => 'Databasen är optimerad';

  @override
  String get databaseMigrationBody => 'Vänta. Detta kan ta en stund.';

  @override
  String get leaveEmptyToClearStatus => 'Lämna tomt för att rensa din status.';

  @override
  String get select => 'Select';

  @override
  String get searchForUsers => 'Sök efter @användare...';

  @override
  String get pleaseEnterYourCurrentPassword =>
      'Vänligen ange ditt nuvarande lösenord';

  @override
  String get newPassword => 'Nytt lösenord';

  @override
  String get pleaseChooseAStrongPassword => 'Välj ett starkt lösenord';

  @override
  String get passwordsDoNotMatch => 'Lösenord stämmer inte överens';

  @override
  String get passwordIsWrong => 'Ditt angivna lösenord är fel';

  @override
  String get publicLink => 'Offentlig länk';

  @override
  String get publicChatAddresses => 'Offentliga chattadresser';

  @override
  String get createNewAddress => 'Skapa ny adress';

  @override
  String get joinSpace => 'Gå med i utrymmet';

  @override
  String get publicSpaces => 'Offentliga utrymmen';

  @override
  String get addChatOrSubSpace => 'Lägg till chatt eller underutrymme';

  @override
  String get subspace => 'Underutrymmen';

  @override
  String get decline => 'Avslå';

  @override
  String get thisDevice => 'Denna enhet:';

  @override
  String get initAppError => 'Ett fel inträffade när appen startas';

  @override
  String get userRole => 'Användarroll';

  @override
  String minimumPowerLevel(int level) {
    return '$level är den lägsta effektnivån.';
  }

  @override
  String searchIn(String chat) {
    return 'Sök i chatt \"$chat\"...';
  }

  @override
  String get searchMore => 'Sök mer...';

  @override
  String get gallery => 'Galleri';

  @override
  String get files => 'Filer';

  @override
  String databaseBuildErrorBody(String url, String error) {
    return 'Det går inte att bygga SQLite-databasen. Appen försöker använda den äldre databasen för tillfället. Rapportera detta fel till utvecklarna på $url. Felmeddelandet är: $error';
  }

  @override
  String sessionLostBody(String url, String error) {
    return 'Din session är förlorad. Vänligen rapportera detta fel till utvecklarna på $url. The error message is: $error';
  }

  @override
  String restoreSessionBody(String url, String error) {
    return 'Appen försöker nu återställa din session från säkerhetskopian. Rapportera detta fel till utvecklarna på $url. Felmeddelandet är: $error';
  }

  @override
  String forwardMessageTo(String roomName) {
    return 'Vidarebefordra meddelande till $roomName?';
  }

  @override
  String get sendReadReceipts => 'Skicka läskvitton';

  @override
  String get sendTypingNotificationsDescription =>
      'Andra deltagare i en chatt kan se när du skriver ett nytt meddelande.';

  @override
  String get sendReadReceiptsDescription =>
      'Andra deltagare i en chatt kan se när du har läst ett meddelande.';

  @override
  String get formattedMessages => 'Formaterade meddelanden';

  @override
  String get formattedMessagesDescription =>
      'Visa rikt meddelandeinnehåll som fet text med markdown.';

  @override
  String get verifyOtherUser => '🔐 Verifiera annan användare';

  @override
  String get verifyOtherUserDescription =>
      'Om du verifierar en annan användare kan du vara säker på att du vet vem du verkligen skriver till. 💪\n\nNär du startar en verifiering kommer du och den andra användaren att se en popup i appen. Där ser du sedan en serie emojis eller siffror som du måste jämföra med varandra.\n\nDet bästa sättet att göra detta är att träffas eller starta ett videosamtal. 👭';

  @override
  String get verifyOtherDevice => '🔐Verifiera annan enhet';

  @override
  String get verifyOtherDeviceDescription =>
      'När du verifierar en annan enhet kan dessa enheter utbyta nycklar, vilket ökar din övergripande säkerhet. 💪 När du startar en verifiering visas en popup i appen på båda enheterna. Där ser du sedan en serie emojis eller siffror som du måste jämföra med varandra. Det är bäst att ha båda enheterna till hands innan du startar verifieringen. 🤳';

  @override
  String acceptedKeyVerification(String sender) {
    return '$sender accepterade nyckelverifiering';
  }

  @override
  String canceledKeyVerification(String sender) {
    return '$sender avbröt nyckelverifiering';
  }

  @override
  String completedKeyVerification(String sender) {
    return '$sender slutförde nyckelverifiering';
  }

  @override
  String isReadyForKeyVerification(String sender) {
    return '$sender är redo för nyckelverifiering';
  }

  @override
  String requestedKeyVerification(String sender) {
    return '$sender begärde nyckelverifiering';
  }

  @override
  String startedKeyVerification(String sender) {
    return '$sender startade nyckelverifiering';
  }

  @override
  String get transparent => 'Transparent';

  @override
  String get incomingMessages => 'Inkommande meddelanden';

  @override
  String get stickers => 'Klistermärken';

  @override
  String get discover => 'Upptäck';

  @override
  String get commandHint_ignore => 'Ignorera angivet matrix-ID';

  @override
  String get commandHint_unignore => 'Avignorera angivet matrix-ID';

  @override
  String unreadChatsInApp(String appname, String unread) {
    return '$appname: $unread olästa chattar';
  }

  @override
  String get noDatabaseEncryption =>
      'Databaskryptering stöds inte på den här plattformen';

  @override
  String thereAreCountUsersBlocked(Object count) {
    return 'Just nu finns det $count användare blockerade.';
  }

  @override
  String get restricted => 'Begränsad';

  @override
  String get knockRestricted => 'Knackning begränsad';

  @override
  String goToSpace(Object space) {
    return 'Gå till utrymme: $space';
  }

  @override
  String get markAsUnread => 'Markera som oläst';

  @override
  String userLevel(int level) {
    return '$level - Användare';
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
  String get changeGeneralChatSettings => 'Ändra allmänna chattinställningar';

  @override
  String get inviteOtherUsers => 'Bjud in andra användare till denna chatt';

  @override
  String get changeTheChatPermissions => 'Ändra chattbehörigheterna';

  @override
  String get changeTheVisibilityOfChatHistory =>
      'Ändra synligheten för chatthistoriken';

  @override
  String get changeTheCanonicalRoomAlias =>
      'Ändra den huvudsakliga offentliga chattadressen';

  @override
  String get sendRoomNotifications => 'Skicka en @room underrättelser';

  @override
  String get changeTheDescriptionOfTheGroup => 'Ändra beskrivningen av chatten';

  @override
  String get chatPermissionsDescription =>
      'Definiera vilken effektnivå som är nödvändig för vissa åtgärder i den här chatten. Effektnivåerna 0, 50 och 100 representerar vanligtvis användare, moderatorer och administratörer, men alla graderingar är möjliga.';

  @override
  String updateInstalled(String version) {
    return '🎉 Uppdatering $version installerad!';
  }

  @override
  String get changelog => 'Ändringslogg';

  @override
  String get sendCanceled => 'Sändningen avbröts';

  @override
  String get loginWithMatrixId => 'Logga in med Matrix-ID';

  @override
  String get discoverHomeservers => 'Upptäck hemmaservrar';

  @override
  String get whatIsAHomeserver => 'Vad är en hemmaserver?';

  @override
  String get homeserverDescription =>
      'All din data lagras på hemmaservern, precis som en e-postleverantör. Du kan välja vilken hemmaserver du vill använda, samtidigt som du fortfarande kan kommunicera med alla. Läs mer på https://matrix.org.';

  @override
  String get doesNotSeemToBeAValidHomeserver =>
      'Verkar inte vara en kompatibel hemmaserver. Fel URL?';

  @override
  String get calculatingFileSize => 'Beräknar filstorlek...';

  @override
  String get prepareSendingAttachment => 'Förbereder att skicka bilaga...';

  @override
  String get sendingAttachment => 'Skickar bilaga...';

  @override
  String get generatingVideoThumbnail => 'Genererar videotumnagel...';

  @override
  String get compressVideo => 'Komprimerar video...';

  @override
  String sendingAttachmentCountOfCount(int index, int length) {
    return 'Skickar bilaga $index med $length...';
  }

  @override
  String serverLimitReached(int seconds) {
    return 'Servergränsen nådd! Väntar $seconds sekunder...';
  }

  @override
  String get yesterday => 'Igår';

  @override
  String get today => 'Today';

  @override
  String get member => 'Member';

  @override
  String get changePowerLevel => 'Change power level';

  @override
  String get canNotChangePowerLevel =>
      'Power level can not be changed because it is not higher than the user whose power level you want to change.';

  @override
  String changePowerLevelForUserToValue(Object user, Object value) {
    return 'Change power level for $user to $value?';
  }

  @override
  String get loginInPleaseWait => 'Logging in, please wait...';

  @override
  String get settingUpApplicationPleaseWait =>
      'Settings up application, please wait ...';

  @override
  String get checkingEncryptionPleaseWait =>
      'Checking encryption, please wait ...';

  @override
  String get settingUpEncryptionPleaseWait =>
      'Setting up encryption, please wait ...';

  @override
  String canonicalAliasInvalidInput(String homeServer) {
    return 'Invalid input, must match #SOMETHING:$homeServer';
  }

  @override
  String canonicalAliasHelperText(String roomName, String homeServer) {
    return 'Example: #\$$roomName:\$$homeServer';
  }

  @override
  String get shareKeysWithAllDevices => 'Share keys with all devices';

  @override
  String get shareKeysWithCrossVerifiedDevices =>
      'Share keys with cross-verified devices';

  @override
  String get shareKeysWithCrossVerifiedDevicesIfEnabled =>
      'Share keys with cross-verified devices (if enabled)';

  @override
  String get shareKeysWithDirectlyVerifiedDevicesOnly =>
      'Share keys with directly verified devices only';

  @override
  String get joinRules => 'Join rules';

  @override
  String get showTheseEventsInTheChat => 'Show these events in the chat';

  @override
  String get playMedia => 'Play media';

  @override
  String get appendToQueue => 'Append to queue';

  @override
  String appendedToQueue(String title) {
    return 'Appended to queue: $title';
  }

  @override
  String get queue => 'Queue';

  @override
  String get clearQueue => 'Clear queue';

  @override
  String get queueCleared => 'Queue cleared';

  @override
  String get radioBrowser => 'Radio browser';

  @override
  String get selectStation => 'Select station';

  @override
  String get noStationFound => 'No station found';

  @override
  String get favorites => 'Favorites';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get favoriteAdded => 'Favorite added';

  @override
  String get favoriteRemoved => 'Favorite removed';

  @override
  String get notSupportedByServer => 'Not supported by server';

  @override
  String get radioStation => 'Radio station';

  @override
  String get radioStations => 'Radio stations';

  @override
  String get noRadioBrowserConnected => 'No Radio Browser connected';

  @override
  String appendMediaToQueueDescription(String title) {
    return '$title is already inside the queue. Do you want to append it to the end of the queue?';
  }

  @override
  String get appendMediaToQueueTitle => 'Append media to queue';

  @override
  String appendMediaToQueue(String title) {
    return 'Append media to queue: $title';
  }

  @override
  String get playNowButton => 'Play now';

  @override
  String get appendMediaToQueueButton => 'Append to queue';

  @override
  String get clipboardNotAvailable => 'Clipboard not available';

  @override
  String get noSupportedFormatFoundInClipboard =>
      'No supported format found in clipboard';

  @override
  String get fileIsTooLarge => 'File is too large';

  @override
  String get notificationRuleContainsUserName => 'Contains User Name';

  @override
  String get notificationRuleMaster => 'Master';

  @override
  String get notificationRuleSuppressNotices => 'Suppress Notices';

  @override
  String get notificationRuleInviteForMe => 'Invitation for me';

  @override
  String get notificationRuleMemberEvent => 'Member Event';

  @override
  String get notificationRuleIsUserMention => 'User Mention';

  @override
  String get notificationRuleContainsDisplayName => 'Contains Display Name';

  @override
  String get notificationRuleIsRoomMention => 'Room Mention';

  @override
  String get notificationRuleRoomnotif => 'Room Notification';

  @override
  String get notificationRuleTombstone => 'Tombstone';

  @override
  String get notificationRuleReaction => 'Reaction';

  @override
  String get notificationRuleRoomServerAcl => 'Room Server ACL';

  @override
  String get notificationRuleSuppressEdits => 'Suppress Edits';

  @override
  String get notificationRuleCall => 'Call';

  @override
  String get notificationRuleEncryptedRoomOneToOne =>
      'Encrypted Room (One-to-One)';

  @override
  String get notificationRuleRoomOneToOne => 'Room (One-to-One)';

  @override
  String get notificationRuleMessage => 'Message';

  @override
  String get notificationRuleEncrypted => 'Encrypted';

  @override
  String get notificationRuleServerAcl => 'Server ACL';

  @override
  String get notificationRuleJitsi => 'Jitsi';

  @override
  String get notificationRuleContainsUserNameDescription =>
      'Username is contained in the content';

  @override
  String get notificationRuleMasterDescription => 'Master notification';

  @override
  String get notificationRuleSuppressNoticesDescription => 'Suppress notices';

  @override
  String get notificationRuleInviteForMeDescription => 'Invitation for me';

  @override
  String get notificationRuleMemberEventDescription => 'Member event';

  @override
  String get notificationRuleIsUserMentionDescription => 'User mention';

  @override
  String get notificationRuleContainsDisplayNameDescription =>
      'Contains display name';

  @override
  String get notificationRuleIsRoomMentionDescription => 'Room mention';

  @override
  String get notificationRuleRoomnotifDescription => 'Room notification';

  @override
  String get notificationRuleTombstoneDescription => 'Tombstone';

  @override
  String get notificationRuleReactionDescription => 'Reaction';

  @override
  String get notificationRuleRoomServerAclDescription => 'Room server ACL';

  @override
  String get notificationRuleSuppressEditsDescription => 'Suppress edits';

  @override
  String get notificationRuleCallDescription => 'Call';

  @override
  String get notificationRuleEncryptedRoomOneToOneDescription =>
      'Encrypted Room (One-to-One)';

  @override
  String get notificationRuleRoomOneToOneDescription => 'Room (One-to-One)';

  @override
  String get notificationRuleMessageDescription => 'Message';

  @override
  String get notificationRuleEncryptedDescription => 'Encrypted';

  @override
  String get notificationRuleServerAclDescription => 'Server ACL';

  @override
  String get notificationRuleJitsiDescription => 'Jitsi';

  @override
  String unknownPushRule(Object ruleId) {
    return 'Custom push rule $ruleId';
  }

  @override
  String get contentNotificationSettings => 'Content notification settings';

  @override
  String get generalNotificationSettings => 'General notification settings';

  @override
  String get roomNotificationSettings => 'Room notification settings';

  @override
  String get userSpecificNotificationSettings =>
      'User-specific notification settings';

  @override
  String get otherNotificationSettings => 'Other notification settings';

  @override
  String deletePushRuleTitle(Object ruleName) {
    return 'Delete push rule $ruleName?';
  }

  @override
  String deletePushRuleDescription(Object ruleName) {
    return 'Do you really want to delete the push rule $ruleName? This action cannot be undone.';
  }

  @override
  String get pusherDevices => 'Pusher Devices';

  @override
  String get syncNow => 'Sync now';

  @override
  String get startAppUpPleaseWait => 'Starting, please wait...';

  @override
  String get retry => 'Retry';

  @override
  String get reportIssue => 'Report issue';

  @override
  String get closeApp => 'Close app';

  @override
  String get creatingRoomPleaseWait => 'Creating room, please wait...';

  @override
  String get creatingSpacePleaseWait => 'Creating space, please wait...';

  @override
  String get joiningRoomPleaseWait => 'Joining room, please wait...';

  @override
  String get leavingRoomPleaseWait => 'Leaving room, please wait...';

  @override
  String get deletingRoomPleaseWait => 'Deleting room, please wait...';

  @override
  String get loadingArchivePleaseWait => 'Loading archive, please wait...';

  @override
  String get clearingArchivePleaseWait => 'Clearing archive, please wait...';

  @override
  String get pleaseSelectAChatRoom => 'Please select a chat room';

  @override
  String get archiveIsEmpty =>
      'There are no archived chats yet. When you leave a chat, you can find it here.';

  @override
  String audioMessageSendFromUser(String user) {
    return 'Audio message from $user';
  }

  @override
  String get startRecordingVoiceMessage => 'Start recording voice message';

  @override
  String get endRecordingVoiceMessage => 'End recording voice message';

  @override
  String get exportFileAs => 'Export file as...';

  @override
  String fileExported(String path) {
    return 'File exported to $path';
  }

  @override
  String get directoryDoesNotExist =>
      'Directory does not exist anymore or is not accessible.';

  @override
  String get thread => 'Thread';

  @override
  String get wipeSecureStorage => 'Wipe secure storage';

  @override
  String get wipeKeyBackup => 'Wipe key backup';

  @override
  String get wipeCrossSigning => 'Wipe cross-signing';

  @override
  String get setupMasterKey => 'Setup master key';

  @override
  String get setupUserSigningKey => 'Setup user-signing key';

  @override
  String get setupSelfSigningKey => 'Setup self-signing key';

  @override
  String get setupOnlineKeyBackup => 'Setup online key backup';

  @override
  String get yourPassphrase => '(Optional) Your passphrase';

  @override
  String get yourPassphraseDescription =>
      'The recovery key is very long and hard to remember. You can optionally set up a passphrase that is easier to remember. The passphrase will be used to encrypt the recovery key. Make sure to choose a strong passphrase and do not forget it, otherwise you will lose access to your encrypted messages when you log out or switch devices.';

  @override
  String get showAddtionalNewCryptoSetupOptions =>
      'Show additional new crypto setup options';

  @override
  String get showAddtionalNewCryptoSetupOptionsWarning =>
      'Warning! These options are only recommended for advanced users. If you are not sure what these options do, it is better to stick with the default setup.';

  @override
  String get resetRecoveryKey => 'Reset recovery key';

  @override
  String get resetRecoveryKeyTitle => 'Reset recovery key and wipe key backup';

  @override
  String get resetRecoveryKeyDescription =>
      'Wipe your key backup, reset your recovery key and generate a new one. You will lose the keys to decrypt the messages that were previously encrypted. Are you sure that you want to reset your recovery key?';

  @override
  String get resetRecoveryKeyConfirmationLabel => 'Yes, Reset recovery key';
}
