// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get alwaysUse24HourFormat => 'false';

  @override
  String get repeatPassword => '重复密码';

  @override
  String get notAnImage => '不是图片文件';

  @override
  String get remove => '删除';

  @override
  String get importNow => '立即导入';

  @override
  String get importEmojis => '导入 Emoji';

  @override
  String get importFromZipFile => '从 .zip 文件导入';

  @override
  String get exportEmotePack => '导出 Emote 包为 .zip';

  @override
  String get replace => '替换';

  @override
  String get about => '关于';

  @override
  String get accept => '接受';

  @override
  String acceptedTheInvitation(String username) {
    return '👍 $username 已接受邀请';
  }

  @override
  String get account => '账户';

  @override
  String activatedEndToEndEncryption(String username) {
    return '🔐 $username 已启用端到端加密';
  }

  @override
  String get addEmail => '添加邮箱';

  @override
  String get confirmMatrixId => '请确认您的 Matrix ID 以删除账户。';

  @override
  String supposedMxid(String mxid) {
    return '这应该是 $mxid';
  }

  @override
  String get addChatDescription => '添加聊天描述...';

  @override
  String get addToSpace => '添加到空间';

  @override
  String get admin => '管理员';

  @override
  String get alias => '别名';

  @override
  String get all => '所有';

  @override
  String get allChats => '所有聊天';

  @override
  String get commandHint_googly => '发送一些 Googly 眼睛';

  @override
  String get commandHint_cuddle => '发送贴贴';

  @override
  String get commandHint_hug => '发送拥抱';

  @override
  String googlyEyesContent(String senderName) {
    return '$senderName 发送了一些 Googly 眼睛';
  }

  @override
  String cuddleContent(String senderName) {
    return '$senderName 贴贴了你';
  }

  @override
  String hugContent(String senderName) {
    return '$senderName 拥抱了你';
  }

  @override
  String answeredTheCall(String senderName) {
    return '$senderName 接听了电话';
  }

  @override
  String get anyoneCanJoin => '任何人都可以加入';

  @override
  String get appLock => '应用程序锁';

  @override
  String get appLockDescription => '当应用程序未在使用时，使用 PIN 码锁定应用程序';

  @override
  String get archive => '归档';

  @override
  String get areGuestsAllowedToJoin => '访客用户是否允许加入';

  @override
  String get areYouSure => '确定吗？';

  @override
  String get areYouSureYouWantToLogout => '确定要注销吗？';

  @override
  String get askSSSSSign => '为了能够签署其他用户，您需要输入您的安全存储密码或恢复密钥。';

  @override
  String askVerificationRequest(String username) {
    return '是否接受 $username 的验证请求？';
  }

  @override
  String get autoplayImages => '自动播放动画贴纸和 Emoji';

  @override
  String badServerLoginTypesException(
    String serverVersions,
    String supportedVersions,
  ) {
    return '服务器支持的登录类型为：\n$serverVersions\n但此应用程序仅支持：\n$supportedVersions';
  }

  @override
  String get sendTypingNotifications => '发送输入通知';

  @override
  String get swipeRightToLeftToReply => '向右滑动以回复';

  @override
  String get sendOnEnter => '按 Enter 键发送';

  @override
  String badServerVersionsException(
    String serverVersions,
    String supportedVersions,
  ) {
    return '服务器支持的 Spec 版本为：\n$serverVersions\n但此应用程序仅支持：\n$supportedVersions';
  }

  @override
  String countChatsAndCountParticipants(String chats, Object participants) {
    return '$chats 个聊天和 $participants 个参与者';
  }

  @override
  String get noMoreChatsFound => '没有更多聊天了...';

  @override
  String get noChatsFoundHere => '这里没有聊天。使用下面的按钮开始与某人聊天。 ⤵️';

  @override
  String get joinedChats => '加入的聊天';

  @override
  String get unread => '未读';

  @override
  String get space => '空间';

  @override
  String get spaces => '空间';

  @override
  String get banFromChat => '从聊天中封禁';

  @override
  String get banned => '已封禁';

  @override
  String bannedUser(String username, String targetName) {
    return '$username 已封禁 $targetName';
  }

  @override
  String get blockDevice => '封禁设备';

  @override
  String get blocked => '已封禁';

  @override
  String get botMessages => '机器人消息';

  @override
  String get cancel => '取消';

  @override
  String cantOpenUri(String uri) {
    return '无法打开 URI $uri';
  }

  @override
  String get changeDeviceName => '更改设备名称';

  @override
  String changedTheChatAvatar(String username) {
    return '$username 已更改聊天头像';
  }

  @override
  String changedTheChatDescriptionTo(String username, String description) {
    return '$username 已将聊天描述更改为：\'$description\'';
  }

  @override
  String changedTheChatNameTo(String username, String chatname) {
    return '$username 已将聊天名称更改为：\'$chatname\'';
  }

  @override
  String changedTheChatPermissions(String username) {
    return '$username 已更改聊天权限';
  }

  @override
  String changedTheDisplaynameTo(String username, String displayname) {
    return '$username 已将显示名称更改为：\'$displayname\'';
  }

  @override
  String changedTheGuestAccessRules(String username) {
    return '$username 已更改访客访问规则';
  }

  @override
  String changedTheGuestAccessRulesTo(String username, String rules) {
    return '$username 已将访客访问规则更改为：$rules';
  }

  @override
  String changedTheHistoryVisibility(String username) {
    return '$username 已更改历史可见性';
  }

  @override
  String changedTheHistoryVisibilityTo(String username, String rules) {
    return '$username 已将历史可见性更改为：$rules';
  }

  @override
  String changedTheJoinRules(String username) {
    return '$username 已更改加入规则';
  }

  @override
  String changedTheJoinRulesTo(String username, String joinRules) {
    return '$username 已将加入规则更改为：$joinRules';
  }

  @override
  String changedTheProfileAvatar(String username) {
    return '$username 已更改头像';
  }

  @override
  String changedTheRoomAliases(String username) {
    return '$username 已更改房间别名';
  }

  @override
  String changedTheRoomInvitationLink(String username) {
    return '$username 已更改邀请链接';
  }

  @override
  String get changePassword => '更改密码';

  @override
  String get changeTheHomeserver => '更改主服务器';

  @override
  String get changeTheme => '更改样式';

  @override
  String get changeTheNameOfTheGroup => '更改组名称';

  @override
  String get changeYourAvatar => '更改您的头像';

  @override
  String get channelCorruptedDecryptError => '加密已损坏';

  @override
  String get chat => '聊天';

  @override
  String get yourChatBackupHasBeenSetUp => '聊天备份已设置';

  @override
  String get chatBackup => '聊天备份';

  @override
  String get chatBackupDescription => '您的旧消息已使用恢复密钥进行加密。请确保不要丢失它。';

  @override
  String get chatDetails => '聊天详情';

  @override
  String get chatHasBeenAddedToThisSpace => '聊天已添加到此空间';

  @override
  String get chats => '聊天';

  @override
  String get chooseAStrongPassword => '请选择一个强密码';

  @override
  String get clearArchive => '清除存档';

  @override
  String get close => '关闭';

  @override
  String get commandHint_markasdm => '将给定的 Matrix ID 标记为直接消息房间';

  @override
  String get commandHint_markasgroup => '标记为群组';

  @override
  String get commandHint_ban => '从该房间封禁给定用户';

  @override
  String get commandHint_clearcache => '清除缓存';

  @override
  String get commandHint_create => '创建一个空的群组聊天\n使用 --no-encryption 禁用加密';

  @override
  String get commandHint_discardsession => '丢弃会话';

  @override
  String get commandHint_dm => '开始直接聊天\n使用 --no-encryption 禁用加密';

  @override
  String get commandHint_html => '发送 HTML 格式化文本';

  @override
  String get commandHint_invite => '邀请特定用户到此房间';

  @override
  String get commandHint_join => '加入特定房间';

  @override
  String get commandHint_kick => '从该房间移除特定用户';

  @override
  String get commandHint_leave => '退出该房间';

  @override
  String get commandHint_me => '描述您自己';

  @override
  String get commandHint_myroomavatar => '设置该房间中您的头像 (使用 mxc-uri)';

  @override
  String get commandHint_myroomnick => '设置该房间中您的显示名称';

  @override
  String get commandHint_op => '将特定用户的权限等级设置为 (默认: 50)';

  @override
  String get commandHint_plain => '发送未格式化的文本';

  @override
  String get commandHint_react => '作为回应发送';

  @override
  String get commandHint_send => '发送文本';

  @override
  String get commandHint_unban => '从该房间解封特定用户';

  @override
  String get commandInvalid => '命令无效';

  @override
  String commandMissing(String command) {
    return '$command 不是命令。';
  }

  @override
  String get compareEmojiMatch => '请对比表情符号';

  @override
  String get compareNumbersMatch => '请对比数字';

  @override
  String get configureChat => '配置聊天';

  @override
  String get confirm => '确认';

  @override
  String get connect => '连接';

  @override
  String get contactHasBeenInvitedToTheGroup => '联系人已邀请至群组';

  @override
  String get containsDisplayName => '包含显示名称';

  @override
  String get containsUserName => '包含用户名';

  @override
  String get contentHasBeenReported => '内容已报告至服务器管理员';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get copy => '复制';

  @override
  String get copyToClipboard => '复制到剪贴板';

  @override
  String couldNotDecryptMessage(String error) {
    return '无法解密消息: $error';
  }

  @override
  String countParticipants(int count) {
    return '$count 个参与者';
  }

  @override
  String get create => '创建';

  @override
  String createdTheChat(String username) {
    return '💬 $username 创建了聊天';
  }

  @override
  String get createGroup => '创建群组';

  @override
  String get createNewSpace => '新空间';

  @override
  String get currentlyActive => '当前活跃';

  @override
  String get darkTheme => '暗黑';

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
  String get deactivateAccountWarning => '这将停用您的用户账户。这不能撤销！您确定吗？';

  @override
  String get defaultPermissionLevel => '新用户的默认权限等级';

  @override
  String get delete => '删除';

  @override
  String get deleteAccount => '删除账户';

  @override
  String get deleteMessage => '删除消息';

  @override
  String get device => '设备';

  @override
  String get deviceId => '设备 ID';

  @override
  String get devices => '设备';

  @override
  String get directChats => '直接聊天';

  @override
  String get allRooms => '所有群组聊天';

  @override
  String get displaynameHasBeenChanged => '显示名称已更改';

  @override
  String get downloadFile => '下载文件';

  @override
  String get edit => '编辑';

  @override
  String get editBlockedServers => '编辑封禁的服务器';

  @override
  String get chatPermissions => '聊天权限';

  @override
  String get editDisplayname => '编辑显示名称';

  @override
  String get editRoomAliases => '编辑房间别名';

  @override
  String get editRoomAvatar => '编辑房间头像';

  @override
  String get emoteExists => '表情符号已存在！';

  @override
  String get emoteInvalid => '表情符号短码无效！';

  @override
  String get emoteKeyboardNoRecents => '最近使用的表情符号将出现在这里...';

  @override
  String get emotePacks => '房间的表情符号包';

  @override
  String get emoteSettings => '表情符号设置';

  @override
  String get globalChatId => '全局聊天 ID';

  @override
  String get accessAndVisibility => '访问和可见性';

  @override
  String get accessAndVisibilityDescription => '谁可以加入此聊天，以及聊天如何被发现。';

  @override
  String get calls => '电话';

  @override
  String get customEmojisAndStickers => '自定义表情符号和贴纸';

  @override
  String get customEmojisAndStickersBody => '添加或分享自定义表情符号或贴纸，可在任何聊天中使用。';

  @override
  String get emoteShortcode => '表情符号短码';

  @override
  String get emoteWarnNeedToPick => '您需要选择一个表情符号短码和一张图片！';

  @override
  String get emptyChat => '空聊天';

  @override
  String get enableEmotesGlobally => '全局启用表情符号包';

  @override
  String get enableEncryption => '启用加密';

  @override
  String get enableEncryptionWarning => '您将无法再禁用加密，确定吗？';

  @override
  String get encrypted => '已加密';

  @override
  String get encryption => '加密';

  @override
  String get encryptionNotEnabled => '加密未启用';

  @override
  String endedTheCall(String senderName) {
    return '$senderName 已结束通话';
  }

  @override
  String get enterAnEmailAddress => '输入电子邮件地址';

  @override
  String get homeserver => 'Homeserver';

  @override
  String get enterYourHomeserver => '输入您的 Homeserver';

  @override
  String errorObtainingLocation(String error) {
    return '获取位置错误：$error';
  }

  @override
  String get everythingReady => '一切就绪！';

  @override
  String get extremeOffensive => '极度冒犯';

  @override
  String get fileName => '文件名';

  @override
  String get nebuchadnezzar => '尼布甲尼撒';

  @override
  String get fontSize => '字体大小';

  @override
  String get forward => '转发';

  @override
  String get fromJoining => 'From joining';

  @override
  String get fromTheInvitation => '来自邀请';

  @override
  String get goToTheNewRoom => '前往新房间';

  @override
  String get group => '群组';

  @override
  String get chatDescription => '聊天描述';

  @override
  String get chatDescriptionHasBeenChanged => '聊天描述已更改';

  @override
  String get groupIsPublic => '群组是公开的';

  @override
  String get groups => '群组';

  @override
  String groupWith(String displayname) {
    return '群组与 $displayname';
  }

  @override
  String get guestsAreForbidden => '禁止访客';

  @override
  String get guestsCanJoin => '访客可加入';

  @override
  String hasWithdrawnTheInvitationFor(String username, String targetName) {
    return '$username 已撤回对 $targetName 的邀请';
  }

  @override
  String get help => '帮助';

  @override
  String get hideRedactedEvents => '隐藏已编辑事件';

  @override
  String get hideRedactedMessages => '隐藏已编辑消息';

  @override
  String get hideRedactedMessagesBody => '如果有人编辑了消息，此消息将不再在聊天中可见。';

  @override
  String get hideInvalidOrUnknownMessageFormats => '隐藏无效或未知消息格式';

  @override
  String get howOffensiveIsThisContent => '此内容有多冒犯？';

  @override
  String get id => 'ID';

  @override
  String get identity => '身份';

  @override
  String get block => '封禁';

  @override
  String get blockedUsers => '封禁的用户';

  @override
  String get blockListDescription => '您可以封禁干扰您的用户。您将无法从个人封禁列表中的用户接收任何消息或房间邀请。';

  @override
  String blockUsername(String username) {
    return '忽略 $username';
  }

  @override
  String get iHaveClickedOnLink => '我已点击链接';

  @override
  String get incorrectPassphraseOrKey => '错误的密码或恢复密钥';

  @override
  String get inoffensive => '不冒犯';

  @override
  String get inviteContact => '邀请联系人';

  @override
  String inviteContactToGroupQuestion(String contact, String groupName) {
    return '您是否要将 $contact 邀请到聊天 \"$groupName\" 中？';
  }

  @override
  String get noChatDescriptionYet => '暂无聊天描述';

  @override
  String get tryAgain => '重试';

  @override
  String get invalidServerName => '无效的服务器名称';

  @override
  String get invited => '已邀请';

  @override
  String get redactMessageDescription =>
      'The message will be redacted for all participants in this conversation. This cannot be undone.';

  @override
  String get optionalRedactReason => '(可选) 编辑此消息的原因...';

  @override
  String invitedUser(String username, String targetName) {
    return '📩 $username 邀请了 $targetName';
  }

  @override
  String get invitedUsersOnly => '仅邀请的用户';

  @override
  String get inviteForMe => '我邀请的';

  @override
  String inviteText(String username, String link) {
    return '$username 邀请您加入尼布甲尼撒。\n1. 访问 https://snapcraft.io/nebuchadnezzar 并安装应用程序\n2. 注册或登录\n3. 打开邀请链接：\n$link';
  }

  @override
  String get isTyping => '正在输入...';

  @override
  String joinedTheChat(String username) {
    return '👋 $username 加入了聊天';
  }

  @override
  String get joinRoom => '加入房间';

  @override
  String kicked(String username, String targetName) {
    return '👞 $username 踢掉了 $targetName';
  }

  @override
  String kickedAndBanned(String username, String targetName) {
    return '🙅 $username 踢掉并封禁了 $targetName';
  }

  @override
  String get kickFromChat => '从聊天中踢掉';

  @override
  String lastActiveAgo(String localizedTimeShort) {
    return '最后活跃时间：$localizedTimeShort';
  }

  @override
  String get leave => '退出';

  @override
  String get leftTheChat => '退出聊天';

  @override
  String get license => '许可证';

  @override
  String get lightTheme => '亮色';

  @override
  String loadCountMoreParticipants(int count) {
    return '加载 $count 个参与者';
  }

  @override
  String get dehydrate => '导出会话并清除设备';

  @override
  String get dehydrateWarning => '此操作无法撤销。请确保安全存储备份文件。';

  @override
  String get dehydrateTor => 'TOR 用户：导出会话';

  @override
  String get dehydrateTorLong => '对于 TOR 用户，建议在关闭窗口之前导出会话。';

  @override
  String get hydrateTor => 'TOR 用户：导入会话';

  @override
  String get hydrateTorLong => '是否上次在 TOR 上导出会话？快速导入并继续聊天。';

  @override
  String get hydrate => '从备份文件恢复';

  @override
  String get loadingPleaseWait => '加载中... 请稍后。';

  @override
  String get loadMore => '加载更多...';

  @override
  String get locationDisabledNotice => '位置服务已禁用。请启用它们才能分享您的位置。';

  @override
  String get locationPermissionDeniedNotice => '位置权限被拒绝。请授予它们才能分享您的位置。';

  @override
  String get login => '登录';

  @override
  String logInTo(String homeserver) {
    return '登录到 $homeserver';
  }

  @override
  String get logout => '退出';

  @override
  String get memberChanges => '成员变更';

  @override
  String get mention => '提及';

  @override
  String get messages => '消息';

  @override
  String get messagesStyle => '消息:';

  @override
  String get moderator => '管理员';

  @override
  String get muteChat => '静音聊天';

  @override
  String get needPantalaimonWarning => '请注意，您需要 Pantalaimon 才能使用端到端加密。';

  @override
  String get newChat => '新聊天';

  @override
  String get newMessageInNebuchadnezzar => '💬 在尼布甲尼撒中开始新聊天';

  @override
  String get newVerificationRequest => '新的验证请求！';

  @override
  String get next => '下一个';

  @override
  String get no => '否';

  @override
  String get noConnectionToTheServer => '没有连接到服务器';

  @override
  String get noEmotesFound => '没有找到表情符号。 😕';

  @override
  String get noEncryptionForPublicRooms => '您只能在房间不再可公开访问时激活端到端加密。';

  @override
  String get noGoogleServicesWarning =>
      'Firebase Cloud Messaging 似乎在您的设备上不可用。为了仍然接收推送通知，我们建议安装 ntfy。使用 ntfy 或其他 Unified Push 提供程序，您可以以数据安全的方式接收推送通知。您可以从 PlayStore 或 F-Droid 下载 ntfy。';

  @override
  String noMatrixServer(String server1, String server2) {
    return '$server1 不是 Matrix 服务器，使用 $server2 代替？';
  }

  @override
  String get shareInviteLink => '分享邀请链接';

  @override
  String get scanQrCode => '扫描二维码';

  @override
  String get none => '无';

  @override
  String get noPasswordRecoveryDescription => '您还没有添加恢复密码的方式。';

  @override
  String get noPermission => '没有权限';

  @override
  String get noRoomsFound => '没有找到房间…';

  @override
  String get notifications => '通知';

  @override
  String get notificationsEnabledForThisAccount => '通知已为此账号启用';

  @override
  String numUsersTyping(int count) {
    return '$count 个用户正在输入...';
  }

  @override
  String get obtainingLocation => '正在获取位置...';

  @override
  String get offensive => '冒犯';

  @override
  String get offline => '离线';

  @override
  String get ok => '好的';

  @override
  String get online => '在线';

  @override
  String get onlineKeyBackupEnabled => '已启用在线密钥备份';

  @override
  String get oopsPushError => '哎呀！很遗憾，设置推送通知时出错。';

  @override
  String get oopsSomethingWentWrong => '哎呀，发生了一些错误。';

  @override
  String get openAppToReadMessages => '打开应用读取消息';

  @override
  String get openCamera => '打开相机';

  @override
  String get openVideoCamera => '打开相机录制视频';

  @override
  String get oneClientLoggedOut => '您的其中一个客户端已注销';

  @override
  String get addAccount => '添加账号';

  @override
  String get editBundlesForAccount => '编辑此账号的捆绑包';

  @override
  String get addToBundle => '添加到捆绑包';

  @override
  String get removeFromBundle => '从此捆绑包中移除';

  @override
  String get bundleName => '捆绑包名称';

  @override
  String get enableMultiAccounts => '(BETA) 启用此设备上的多账号';

  @override
  String get openInMaps => '在地图中打开';

  @override
  String get link => '链接';

  @override
  String get serverRequiresEmail => '此服务器注册时需要验证您的电子邮件地址。';

  @override
  String get or => '或';

  @override
  String get participant => '参与人';

  @override
  String get passphraseOrKey => '恢复密码或恢复密钥';

  @override
  String get password => '密码';

  @override
  String get passwordForgotten => '忘记密码';

  @override
  String get passwordHasBeenChanged => '密码已更改';

  @override
  String get hideMemberChangesInPublicChats => '隐藏公共聊天中的成员变更';

  @override
  String get hideMemberChangesInPublicChatsBody =>
      '在公共聊天中不显示有人加入或离开的变更，以提高可读性。';

  @override
  String get overview => '概览';

  @override
  String get notifyMeFor => '通知我';

  @override
  String get passwordRecoverySettings => '密码恢复设置';

  @override
  String get passwordRecovery => '密码恢复';

  @override
  String get people => '参与人';

  @override
  String get pickImage => '选择图片';

  @override
  String get pin => 'Pin';

  @override
  String play(String fileName) {
    return '播放 $fileName';
  }

  @override
  String get pleaseChoose => '请选择';

  @override
  String get pleaseChooseAPasscode => '请选择一个恢复密码';

  @override
  String get pleaseClickOnLink => '请点击电子邮件中的链接，然后继续。';

  @override
  String get pleaseEnter4Digits => '请输入4位数字，或留空禁用应用程序锁。';

  @override
  String get pleaseEnterRecoveryKey => '请输入恢复密钥:';

  @override
  String get pleaseEnterYourPassword => '请输入您的密码';

  @override
  String get pleaseEnterYourPin => '请输入您的 Pin';

  @override
  String get pleaseEnterYourUsername => '请输入您的用户名';

  @override
  String get pleaseFollowInstructionsOnWeb => '请按照网站上的说明操作，然后点击下一步。';

  @override
  String get privacy => '隐私';

  @override
  String get publicRooms => '公共房间';

  @override
  String get pushRules => '推送规则';

  @override
  String get reason => '原因';

  @override
  String get recording => '录音';

  @override
  String redactedBy(String username) {
    return '由 $username 编辑';
  }

  @override
  String get directChat => '直接聊天';

  @override
  String redactedByBecause(String username, String reason) {
    return '由 $username 编辑，原因： \"$reason\"';
  }

  @override
  String redactedAnEvent(String username) {
    return '$username 编辑了事件';
  }

  @override
  String get redactMessage => '编辑消息';

  @override
  String get register => '注册';

  @override
  String get reject => '拒绝';

  @override
  String rejectedTheInvitation(String username) {
    return '$username 拒绝了邀请';
  }

  @override
  String get rejoin => '重新加入';

  @override
  String get removeAllOtherDevices => '删除所有其他设备';

  @override
  String removedBy(String username) {
    return '由 $username 删除';
  }

  @override
  String get removeDevice => '删除设备';

  @override
  String get unbanFromChat => '从聊天中解封';

  @override
  String get removeYourAvatar => '删除您的头像';

  @override
  String get replaceRoomWithNewerVersion => '用更新版本的房间替换';

  @override
  String get reply => '回复';

  @override
  String get reportMessage => '报告消息';

  @override
  String get requestPermission => '请求权限';

  @override
  String get roomHasBeenUpgraded => '房间已升级';

  @override
  String get roomVersion => '房间版本';

  @override
  String get saveFile => '保存文件';

  @override
  String get search => '搜索';

  @override
  String get security => '安全';

  @override
  String get recoveryKey => '恢复密钥';

  @override
  String get recoveryKeyLost => '恢复密钥丢失?';

  @override
  String seenByUser(String username) {
    return '由 $username 查看';
  }

  @override
  String get send => '发送';

  @override
  String get sendAMessage => '发送消息';

  @override
  String get sendAsText => '以文本发送';

  @override
  String get sendAudio => '发送音频';

  @override
  String get sendFile => '发送文件';

  @override
  String get sendImage => '发送图片';

  @override
  String get sendMessages => '发送消息';

  @override
  String get sendOriginal => '发送原始消息';

  @override
  String get sendSticker => '发送贴纸';

  @override
  String get sendVideo => '发送视频';

  @override
  String sentAFile(String username) {
    return '📁 $username 发送了一个文件';
  }

  @override
  String sentAnAudio(String username) {
    return '🎤 $username 发送了一个音频';
  }

  @override
  String sentAPicture(String username) {
    return '🖼️ $username 发送了一张图片';
  }

  @override
  String sentASticker(String username) {
    return '😊 $username 发送了一个贴纸';
  }

  @override
  String sentAVideo(String username) {
    return '🎥 $username 发送了一个视频';
  }

  @override
  String sentCallInformations(String senderName) {
    return '$senderName 发送了通话信息';
  }

  @override
  String get separateChatTypes => '将直接聊天和群组分开';

  @override
  String get setAsCanonicalAlias => '设置为主别名';

  @override
  String get setCustomEmotes => '设置自定义表情';

  @override
  String get setChatDescription => '设置聊天描述';

  @override
  String get setInvitationLink => '设置邀请链接';

  @override
  String get setPermissionsLevel => '设置权限级别';

  @override
  String get setStatus => '设置状态';

  @override
  String get settings => '设置';

  @override
  String get share => '分享';

  @override
  String sharedTheLocation(String username) {
    return '$username 分享了他的位置';
  }

  @override
  String get shareLocation => '分享位置';

  @override
  String get showPassword => '显示密码';

  @override
  String get presenceStyle => 'Presence:';

  @override
  String get presencesToggle => '显示其他用户的状态消息';

  @override
  String get singlesignon => '单点登录';

  @override
  String get skip => '跳过';

  @override
  String get sourceCode => '源代码';

  @override
  String get spaceIsPublic => '空间是公开的';

  @override
  String get spaceName => '空间名称';

  @override
  String startedACall(String senderName) {
    return '$senderName 发起通话';
  }

  @override
  String get startFirstChat => '开始你的第一个聊天';

  @override
  String get status => '状态';

  @override
  String get statusExampleMessage => '你好吗？';

  @override
  String get submit => '提交';

  @override
  String get synchronizingPleaseWait => '同步中... 请稍后';

  @override
  String get systemTheme => '系统';

  @override
  String get theyDontMatch => '他们不匹配';

  @override
  String get theyMatch => '他们匹配';

  @override
  String get title => '尼布甲尼撒';

  @override
  String get toggleFavorite => '切换收藏';

  @override
  String get toggleMuted => '切换静音';

  @override
  String get toggleUnread => '切换未读/已读';

  @override
  String get tooManyRequestsWarning => '请求过多，请稍后重试！';

  @override
  String get transferFromAnotherDevice => '从另一个设备传输';

  @override
  String get tryToSendAgain => '重新发送';

  @override
  String get unavailable => '不可用';

  @override
  String unbannedUser(String username, String targetName) {
    return '$username 已取消对 $targetName 的封禁';
  }

  @override
  String get unblockDevice => '取消封禁设备';

  @override
  String get unknownDevice => '未知设备';

  @override
  String get unknownEncryptionAlgorithm => '未知加密算法';

  @override
  String unknownEvent(String type) {
    return '未知事件 \'$type\'';
  }

  @override
  String get unmuteChat => '取消静音聊天';

  @override
  String get unpin => '取消置顶';

  @override
  String unreadChats(int unreadCount) {
    String _temp0 = intl.Intl.pluralLogic(
      unreadCount,
      locale: localeName,
      other: '$unreadCount 条未读消息',
      one: '1 条未读消息',
    );
    return '$_temp0';
  }

  @override
  String userAndOthersAreTyping(String username, int count) {
    return '$username 和 $count 个其他用户正在输入...';
  }

  @override
  String userAndUserAreTyping(String username, String username2) {
    return '$username 和 $username2 正在输入...';
  }

  @override
  String userIsTyping(String username) {
    return '$username 正在输入...';
  }

  @override
  String userLeftTheChat(String username) {
    return '🚪 $username 已退出聊天';
  }

  @override
  String get username => '用户名';

  @override
  String userSentUnknownEvent(String username, String type) {
    return '$username 发送了 $type 事件';
  }

  @override
  String get unverified => '未验证';

  @override
  String get verified => '已验证';

  @override
  String get verify => '验证';

  @override
  String get verifyStart => '开始验证';

  @override
  String get verifySuccess => '验证成功！';

  @override
  String get verifyTitle => '验证其他账号';

  @override
  String get videoCall => '视频通话';

  @override
  String get visibilityOfTheChatHistory => '聊天历史可见性';

  @override
  String get visibleForAllParticipants => '对所有参与者可见';

  @override
  String get visibleForEveryone => '对所有人可见';

  @override
  String get voiceMessage => '语音消息';

  @override
  String get waitingPartnerAcceptRequest => '等待对方接受请求...';

  @override
  String get waitingPartnerEmoji => '等待对方接受表情...';

  @override
  String get waitingPartnerNumbers => '等待对方接受数字...';

  @override
  String get wallpaper => '壁纸:';

  @override
  String get warning => '警告！';

  @override
  String get weSentYouAnEmail => '我们已发送您一封电子邮件';

  @override
  String get whoCanPerformWhichAction => '谁可以执行哪些操作';

  @override
  String get whoIsAllowedToJoinThisGroup => '谁可以加入此群组';

  @override
  String get whyDoYouWantToReportThis => '为什么要报告此消息？';

  @override
  String get wipeChatBackup => '是否要清除聊天备份以创建新的恢复密钥？';

  @override
  String get withTheseAddressesRecoveryDescription => '使用这些地址可以恢复您的密码。';

  @override
  String get writeAMessage => '输入消息...';

  @override
  String get yes => '是';

  @override
  String get you => '您';

  @override
  String get youAreNoLongerParticipatingInThisChat => '您已不再参与此聊天';

  @override
  String get youHaveBeenBannedFromThisChat => '您已被此聊天禁止';

  @override
  String get yourPublicKey => '您的公钥';

  @override
  String get messageInfo => '消息信息';

  @override
  String get time => 'Time';

  @override
  String get messageType => '消息类型';

  @override
  String get sender => 'Sender';

  @override
  String get openGallery => '打开相册';

  @override
  String get removeFromSpace => '从空间移除';

  @override
  String get addToSpaceDescription => '选择一个空间将此聊天添加到其中。';

  @override
  String get start => 'Start';

  @override
  String get pleaseEnterRecoveryKeyDescription =>
      '要解锁您旧的消息，请输入在之前会话中生成的恢复密钥。您的恢复密钥不是您的密码。';

  @override
  String get publish => '发布';

  @override
  String videoWithSize(String size) {
    return '视频 ($size)';
  }

  @override
  String get openChat => '打开聊天';

  @override
  String get markAsRead => '标记为已读';

  @override
  String get reportUser => '报告用户';

  @override
  String get dismiss => '解散';

  @override
  String reactedWith(String sender, String reaction) {
    return '$sender 用 $reaction 作出了反应';
  }

  @override
  String get pinMessage => '固定到房间';

  @override
  String get confirmEventUnpin => '确定要永久取消固定事件吗？';

  @override
  String get emojis => '表情符号';

  @override
  String get placeCall => '拨打电话';

  @override
  String get voiceCall => '语音通话';

  @override
  String get unsupportedAndroidVersion => '不支持的 Android 版本';

  @override
  String get unsupportedAndroidVersionLong =>
      '此功能需要更新的 Android 版本。请检查是否有更新或 Lineage OS 支持。';

  @override
  String get videoCallsBetaWarning =>
      '请注意，视频通话当前处于测试阶段。它们可能无法按预期工作或在所有平台上都无法正常工作。';

  @override
  String get experimentalVideoCalls => '实验性视频通话';

  @override
  String get emailOrUsername => '邮箱或用户名';

  @override
  String get indexedDbErrorTitle => '隐私模式问题';

  @override
  String get indexedDbErrorLong =>
      '消息存储默认情况下在隐私模式下未启用。\n请访问\n - about:config\n - 设置 dom.indexedDB.privateBrowsing.enabled 为 true\n否则，尼布甲尼撒将无法运行。';

  @override
  String switchToAccount(int number) {
    return '切换到账号 $number';
  }

  @override
  String get nextAccount => '下一个账号';

  @override
  String get previousAccount => '上一个账号';

  @override
  String get addWidget => '添加小部件';

  @override
  String get widgetVideo => '视频';

  @override
  String get widgetEtherpad => '文本笔记';

  @override
  String get widgetJitsi => 'Jitsi Meet';

  @override
  String get widgetCustom => '自定义';

  @override
  String get widgetName => '名称';

  @override
  String get widgetUrlError => '这不是一个有效的 URL。';

  @override
  String get widgetNameError => '请提供显示名称。';

  @override
  String get errorAddingWidget => '添加小部件时出错。';

  @override
  String get youRejectedTheInvitation => '您拒绝了邀请';

  @override
  String get youJoinedTheChat => '您加入了聊天';

  @override
  String get youAcceptedTheInvitation => '👍 您接受了邀请';

  @override
  String youBannedUser(String user) {
    return '您禁止了 $user';
  }

  @override
  String youHaveWithdrawnTheInvitationFor(String user) {
    return '您已撤回对 $user 的邀请';
  }

  @override
  String youInvitedToBy(String alias) {
    return '📩 您已通过链接邀请到:\n$alias';
  }

  @override
  String youInvitedBy(String user) {
    return '📩 $user 邀请了您';
  }

  @override
  String invitedBy(String user) {
    return '📩 邀请人 $user';
  }

  @override
  String youInvitedUser(String user) {
    return '📩 您邀请了 $user';
  }

  @override
  String youKicked(String user) {
    return '👞 您踢掉了 $user';
  }

  @override
  String youKickedAndBanned(String user) {
    return '🙅 您踢掉并禁止了 $user';
  }

  @override
  String youUnbannedUser(String user) {
    return '您已取消禁止 $user';
  }

  @override
  String hasKnocked(String user) {
    return '🚪 $user 已敲门';
  }

  @override
  String get usersMustKnock => '用户必须敲门';

  @override
  String get noOneCanJoin => '没有人可以加入';

  @override
  String userWouldLikeToChangeTheChat(String user) {
    return '$user 想加入聊天';
  }

  @override
  String get noPublicLinkHasBeenCreatedYet => '暂无公共链接';

  @override
  String get knock => '敲门';

  @override
  String get users => '用户';

  @override
  String get unlockOldMessages => '解锁旧消息';

  @override
  String get storeInSecureStorageDescription => '将恢复密钥存储在该设备的安全存储中。';

  @override
  String get saveKeyManuallyDescription => '手动保存此密钥，方法是触发系统分享对话框或剪贴板。';

  @override
  String get storeInAndroidKeystore => '存储在 Android KeyStore 中';

  @override
  String get storeInAppleKeyChain => '存储在 Apple KeyChain 中';

  @override
  String get storeSecurlyOnThisDevice => '在该设备上安全存储';

  @override
  String countFiles(int count) {
    return '$count 文件';
  }

  @override
  String get user => '用户';

  @override
  String get custom => '自定义';

  @override
  String get foregroundServiceRunning => '当前台服务运行时，此通知会出现。';

  @override
  String get screenSharingTitle => '屏幕分享';

  @override
  String get screenSharingDetail => '您正在 FuffyChat 中分享屏幕';

  @override
  String get callingPermissions => '调用权限';

  @override
  String get callingAccount => '调用账户';

  @override
  String get callingAccountDetails => '允许尼布甲尼撒使用原生Android拨号器应用';

  @override
  String get appearOnTop => '在顶部显示';

  @override
  String get appearOnTopDetails =>
      '允许应用在顶部显示（如果您已经将 Fluffychat 设置为调用账户，则无需此权限）';

  @override
  String get otherCallingPermissions => '相机和其他尼布甲尼撒权限';

  @override
  String get whyIsThisMessageEncrypted => '为什么此消息不可读？';

  @override
  String get noKeyForThisMessage =>
      '如果在您登录到此设备上的帐户之前发送了邮件，则可能会发生这种情况。\n\n也可能是发件人阻止了您的设备或网络连接出现问题。\n\n您可以在另一个会话中读取消息吗？然后您可以从中传输消息！转到“设置”>“设备”，并确保您的设备已相互验证。当您下次打开房间并且两个会话都在前台时，密钥将自动传输。\n\n是否不希望在注销或切换设备时丢失密钥？确保已在设置中启用聊天室备份。';

  @override
  String get newGroup => '新群组';

  @override
  String get newSpace => '新空间';

  @override
  String get enterSpace => '进入空间';

  @override
  String get enterRoom => '进入房间';

  @override
  String get allSpaces => '所有空间';

  @override
  String numChats(int number) {
    return '$number 条聊天记录';
  }

  @override
  String get hideUnimportantStateEvents => '隐藏不重要的状态事件';

  @override
  String get hidePresences => '隐藏状态列表？';

  @override
  String get doNotShowAgain => '不再显示';

  @override
  String wasDirectChatDisplayName(String oldDisplayName) {
    return '空聊天（之前显示为 $oldDisplayName）';
  }

  @override
  String get newSpaceDescription => '空间允许您整合您的聊天记录并构建私有或公共社区。';

  @override
  String get encryptThisChat => '加密此聊天';

  @override
  String get disableEncryptionWarning => '出于安全考虑，您不能在已启用加密的聊天中禁用加密。';

  @override
  String get sorryThatsNotPossible => '抱歉... 这是不可能的';

  @override
  String get deviceKeys => '设备密钥:';

  @override
  String get reopenChat => '重新打开聊天';

  @override
  String get noBackupWarning => '警告！如果未启用聊天备份，您将无法访问加密的消息。强烈建议在注销之前先启用聊天备份。';

  @override
  String get noOtherDevicesFound => '未找到其他设备';

  @override
  String fileIsTooBigForServer(int max) {
    return '无法发送！服务器支持的附件大小上限为 $max。';
  }

  @override
  String fileHasBeenSavedAt(String path) {
    return '文件已保存至 $path';
  }

  @override
  String get jumpToLastReadMessage => '跳转到最后读取的消息';

  @override
  String get readUpToHere => '读取到此处';

  @override
  String get jump => '跳转';

  @override
  String get openLinkInBrowser => '在浏览器中打开链接';

  @override
  String get reportErrorDescription => '😭 哦不。出了点问题。您可以考虑将此错误报告给开发人员。';

  @override
  String get report => '报告';

  @override
  String get signInWithPassword => '使用密码登录';

  @override
  String get pleaseTryAgainLaterOrChooseDifferentServer => '请稍后重试或选择其他服务器。';

  @override
  String signInWith(String provider) {
    return '使用 $provider 登录';
  }

  @override
  String get profileNotFound => '用户在服务器上未找到。可能是连接问题或用户不存在。';

  @override
  String get setTheme => '设置主题:';

  @override
  String get setColorTheme => '设置颜色主题:';

  @override
  String get invite => 'Invite';

  @override
  String get inviteGroupChat => '📨 邀请群组聊天';

  @override
  String get invitePrivateChat => '📨 邀请私人聊天';

  @override
  String get invalidInput => '无效输入！';

  @override
  String wrongPinEntered(int seconds) {
    return '错误的 PIN 码！请在 $seconds 秒后重试...';
  }

  @override
  String get pleaseEnterANumber => '请输入大于 0 的数字';

  @override
  String get archiveRoomDescription => '聊天将被移动到存档。其他用户将能够看到您已退出聊天。';

  @override
  String get roomUpgradeDescription =>
      '聊天将被重新创建为新的房间版本。所有参与者都将被通知切换到新的聊天。您可以在 https://spec.matrix.org/latest/rooms/ 了解更多关于房间版本的信息。';

  @override
  String get removeDevicesDescription => '您将从该设备注销，无法接收消息。';

  @override
  String get banUserDescription => '该用户将被禁止加入聊天，直到被取消禁止。';

  @override
  String get unbanUserDescription => '用户将能够再次加入聊天，如果他们尝试。';

  @override
  String get kickUserDescription => '该用户被踢出聊天，但未被禁止。在公共聊天中，用户可以随时重新加入。';

  @override
  String get makeAdminDescription => '一旦您将此用户设为管理员，您可能无法撤销此操作，因为他们将具有与您相同的权限。';

  @override
  String get pushNotificationsNotAvailable => '推送通知不可用';

  @override
  String get learnMore => '了解更多';

  @override
  String get yourGlobalUserIdIs => '您的全局用户 ID 为: ';

  @override
  String noUsersFoundWithQuery(String query) {
    return '不幸的是，没有用户能够使用 \"$query\" 进行搜索。请检查是否拼写错误。';
  }

  @override
  String get knocking => '敲门';

  @override
  String chatCanBeDiscoveredViaSearchOnServer(String server) {
    return '聊天可以通过在 $server 上搜索来发现';
  }

  @override
  String get searchChatsRooms => '搜索 #chats, @users...';

  @override
  String get nothingFound => '未找到...';

  @override
  String get groupName => '群组名称';

  @override
  String get createGroupAndInviteUsers => '创建群组并邀请用户';

  @override
  String get groupCanBeFoundViaSearch => '群组可以通过搜索来发现';

  @override
  String get wrongRecoveryKey => '抱歉... 这似乎不是正确的恢复密钥。';

  @override
  String get startConversation => '开始对话';

  @override
  String get commandHint_sendraw => '发送原始 JSON';

  @override
  String get databaseMigrationTitle => '数据库已优化';

  @override
  String get databaseMigrationBody => '请稍等。这可能需要一些时间。';

  @override
  String get leaveEmptyToClearStatus => '留空以清除您的状态。';

  @override
  String get select => '选择';

  @override
  String get searchForUsers => '搜索 @users...';

  @override
  String get pleaseEnterYourCurrentPassword => '请输入您当前的密码';

  @override
  String get newPassword => '新密码';

  @override
  String get pleaseChooseAStrongPassword => '请选择一个强密码';

  @override
  String get passwordsDoNotMatch => '密码不匹配';

  @override
  String get passwordIsWrong => '您输入的密码错误';

  @override
  String get publicLink => '公共链接';

  @override
  String get publicChatAddresses => '公共聊天地址';

  @override
  String get createNewAddress => '创建新地址';

  @override
  String get joinSpace => '加入空间';

  @override
  String get publicSpaces => '公共空间';

  @override
  String get addChatOrSubSpace => '添加聊天或子空间';

  @override
  String get subspace => '子空间';

  @override
  String get decline => '拒绝';

  @override
  String get thisDevice => '此设备:';

  @override
  String get initAppError => '初始化应用时出错';

  @override
  String get userRole => '用户角色';

  @override
  String minimumPowerLevel(int level) {
    return '$level 是最低权限等级。';
  }

  @override
  String searchIn(String chat) {
    return '在聊天 \"$chat\" 中搜索...';
  }

  @override
  String get searchMore => '搜索更多...';

  @override
  String get gallery => '相册';

  @override
  String get files => '文件';

  @override
  String databaseBuildErrorBody(String url, String error) {
    return '无法构建 SQlite 数据库。应用程序目前尝试使用旧版数据库。请将此错误报告给开发人员 $url。错误消息为: $error';
  }

  @override
  String sessionLostBody(String url, String error) {
    return '您的会话已丢失。请将此错误报告给开发人员 $url。错误消息为: $error';
  }

  @override
  String restoreSessionBody(String url, String error) {
    return '应用程序现在尝试从备份中恢复您的会话。请将此错误报告给开发人员 $url。错误消息为: $error';
  }

  @override
  String forwardMessageTo(String roomName) {
    return '将消息转发到 $roomName？';
  }

  @override
  String get sendReadReceipts => '发送已读回执';

  @override
  String get sendTypingNotificationsDescription => '其他聊天参与者可以看到您是否正在输入新消息。';

  @override
  String get sendReadReceiptsDescription => '其他聊天参与者可以看到您是否已读取消息。';

  @override
  String get formattedMessages => '格式化消息';

  @override
  String get formattedMessagesDescription => '使用 markdown 显示丰富的消息内容，例如加粗文本。';

  @override
  String get verifyOtherUser => '🔐 验证其他用户';

  @override
  String get verifyOtherUserDescription =>
      'If you verify another user, you can be sure that you know who you are really writing to. 💪\n\nWhen you start a verification, you and the other user will see a popup in the app. There you will then see a series of emojis or numbers that you have to compare with each other.\n\nThe best way to do this is to meet up or start a video call. 👭';

  @override
  String get verifyOtherDevice => '🔐 验证其他设备';

  @override
  String get verifyOtherDeviceDescription =>
      'When you verify another device, those devices can exchange keys, increasing your overall security. 💪 When you start a verification, a popup will appear in the app on both devices. There you will then see a series of emojis or numbers that you have to compare with each other. It\'s best to have both devices handy before you start the verification. 🤳';

  @override
  String acceptedKeyVerification(String sender) {
    return '$sender 已接受密钥验证';
  }

  @override
  String canceledKeyVerification(String sender) {
    return '$sender 已取消密钥验证';
  }

  @override
  String completedKeyVerification(String sender) {
    return '$sender 已完成密钥验证';
  }

  @override
  String isReadyForKeyVerification(String sender) {
    return '$sender 已准备好密钥验证';
  }

  @override
  String requestedKeyVerification(String sender) {
    return '$sender 请求密钥验证';
  }

  @override
  String startedKeyVerification(String sender) {
    return '$sender 已开始密钥验证';
  }

  @override
  String get transparent => '透明';

  @override
  String get incomingMessages => '入站消息';

  @override
  String get stickers => '贴纸';

  @override
  String get discover => '发现';

  @override
  String get commandHint_ignore => '忽略给定的 Matrix ID';

  @override
  String get commandHint_unignore => '取消忽略给定的 Matrix ID';

  @override
  String unreadChatsInApp(String appname, String unread) {
    return '$appname: $unread 未读聊天';
  }

  @override
  String get noDatabaseEncryption => '数据库加密在该平台上不支持';

  @override
  String thereAreCountUsersBlocked(Object count) {
    return '当前有 $count 个用户被阻塞。';
  }

  @override
  String get restricted => '受限';

  @override
  String get knockRestricted => 'Knock restricted';

  @override
  String goToSpace(Object space) {
    return '前往空间: $space';
  }

  @override
  String get markAsUnread => '标记为未读';

  @override
  String userLevel(int level) {
    return '$level - 用户';
  }

  @override
  String moderatorLevel(int level) {
    return '$level - 主持人';
  }

  @override
  String adminLevel(int level) {
    return '$level - 管理员';
  }

  @override
  String get changeGeneralChatSettings => '更改一般聊天设置';

  @override
  String get inviteOtherUsers => '邀请其他用户加入此聊天';

  @override
  String get changeTheChatPermissions => '更改聊天权限';

  @override
  String get changeTheVisibilityOfChatHistory => '更改聊天历史记录的可见性';

  @override
  String get changeTheCanonicalRoomAlias => '更改主要公共聊天地址';

  @override
  String get sendRoomNotifications => '发送 @room 通知';

  @override
  String get changeTheDescriptionOfTheGroup => '更改聊天描述';

  @override
  String get chatPermissionsDescription =>
      '定义在该聊天中需要哪些权限等级才能执行某些操作。权限等级 0、50 和 100 通常代表用户、主持人和管理员，但任何等级都可能。';

  @override
  String updateInstalled(String version) {
    return '🎉 更新 $version 已安装！';
  }

  @override
  String get changelog => '更新日志';

  @override
  String get sendCanceled => '发送已取消';

  @override
  String get loginWithMatrixId => '使用 Matrix-ID 登录';

  @override
  String get discoverHomeservers => '发现 homeserver';

  @override
  String get whatIsAHomeserver => '什么是 homeserver？';

  @override
  String get homeserverDescription =>
      '所有您的数据都存储在 homeserver 上，就像电子邮件提供程序一样。您可以选择使用哪个 homeserver，同时仍然可以与每个人通信。更多信息请访问 https://matrix.org。';

  @override
  String get doesNotSeemToBeAValidHomeserver => '似乎不是兼容的 homeserver。URL 错误？';

  @override
  String get calculatingFileSize => '计算文件大小...';

  @override
  String get prepareSendingAttachment => '准备发送附件...';

  @override
  String get sendingAttachment => '发送附件...';

  @override
  String get generatingVideoThumbnail => '生成视频缩略图...';

  @override
  String get compressVideo => '压缩视频...';

  @override
  String sendingAttachmentCountOfCount(int index, int length) {
    return '发送附件 $index 中的 $length...';
  }

  @override
  String serverLimitReached(int seconds) {
    return '已达服务器上限！等待 $seconds 秒...';
  }

  @override
  String get yesterday => '昨天';

  @override
  String get today => '今天';

  @override
  String get member => '成员';

  @override
  String get changePowerLevel => '更改权限等级';

  @override
  String get canNotChangePowerLevel => '权限等级不能低于您要更改的用户的权限等级。';

  @override
  String changePowerLevelForUserToValue(Object user, Object value) {
    return '将 $user 的权限等级更改为 $value？';
  }

  @override
  String get loginInPleaseWait => '登录中，请稍后...';

  @override
  String get settingUpApplicationPleaseWait => '设置应用程序，请稍后...';

  @override
  String get checkingEncryptionPleaseWait => '检查加密，请稍后...';

  @override
  String get settingUpEncryptionPleaseWait => '设置加密，请稍后...';

  @override
  String canonicalAliasInvalidInput(String homeServer) {
    return '无效输入，必须匹配 #SOMETHING:$homeServer';
  }

  @override
  String canonicalAliasHelperText(String roomName, String homeServer) {
    return '示例: #\$$roomName:\$$homeServer';
  }

  @override
  String get shareKeysWithAllDevices => '分享密钥到所有设备';

  @override
  String get shareKeysWithCrossVerifiedDevices => '分享密钥到已验证设备';

  @override
  String get shareKeysWithCrossVerifiedDevicesIfEnabled => '分享密钥到已验证设备（如果已启用）';

  @override
  String get shareKeysWithDirectlyVerifiedDevicesOnly => '分享密钥到直接验证设备';

  @override
  String get joinRules => '加入规则';

  @override
  String get showTheseEventsInTheChat => '显示这些事件在聊天中';

  @override
  String get playMedia => '播放媒体';

  @override
  String get appendToQueue => '添加到队列';

  @override
  String appendedToQueue(String title) {
    return '已添加到队列: $title';
  }

  @override
  String get queue => '队列';

  @override
  String get clearQueue => '清除队列';

  @override
  String get queueCleared => '队列已清除';

  @override
  String get radioBrowser => '广播浏览器';

  @override
  String get selectStation => '选择电台';

  @override
  String get noStationFound => '未找到电台';

  @override
  String get favorites => '收藏';

  @override
  String get addToFavorites => '添加到收藏';

  @override
  String get removeFromFavorites => '从收藏中移除';

  @override
  String get favoriteAdded => '已添加到收藏';

  @override
  String get favoriteRemoved => '已从收藏中移除';

  @override
  String get notSupportedByServer => '服务器不支持此操作';

  @override
  String get radioStation => '广播电台';

  @override
  String get radioStations => '广播电台';

  @override
  String get noRadioBrowserConnected => '未连接广播浏览器';

  @override
  String appendMediaToQueueDescription(String title) {
    return '$title 已在队列中。是否要将其添加到队列末尾？';
  }

  @override
  String get appendMediaToQueueTitle => '添加媒体到队列';

  @override
  String appendMediaToQueue(String title) {
    return '添加到队列: $title';
  }

  @override
  String get playNowButton => '立即播放';

  @override
  String get appendMediaToQueueButton => '添加到队列';

  @override
  String get clipboardNotAvailable => '剪贴板不可用';

  @override
  String get noSupportedFormatFoundInClipboard => '剪贴板中未找到支持的格式';

  @override
  String get fileIsTooLarge => '文件太大';

  @override
  String get notificationRuleContainsUserName => '包含用户名';

  @override
  String get notificationRuleMaster => '主规则';

  @override
  String get notificationRuleSuppressNotices => '抑制通知';

  @override
  String get notificationRuleInviteForMe => '我邀请的';

  @override
  String get notificationRuleMemberEvent => '成员事件';

  @override
  String get notificationRuleIsUserMention => '用户提及';

  @override
  String get notificationRuleContainsDisplayName => '包含显示名';

  @override
  String get notificationRuleIsRoomMention => '房间提及';

  @override
  String get notificationRuleRoomnotif => '房间通知';

  @override
  String get notificationRuleTombstone => '墓碑';

  @override
  String get notificationRuleReaction => '反应';

  @override
  String get notificationRuleRoomServerAcl => '房间服务器 ACL';

  @override
  String get notificationRuleSuppressEdits => '抑制编辑';

  @override
  String get notificationRuleCall => '电话';

  @override
  String get notificationRuleEncryptedRoomOneToOne => '加密房间（一对一）';

  @override
  String get notificationRuleRoomOneToOne => '房间（一对一）';

  @override
  String get notificationRuleMessage => '消息';

  @override
  String get notificationRuleEncrypted => '加密';

  @override
  String get notificationRuleServerAcl => '服务器 ACL';

  @override
  String get notificationRuleJitsi => 'Jitsi';

  @override
  String get notificationRuleContainsUserNameDescription => '用户名包含在内容中';

  @override
  String get notificationRuleMasterDescription => '主通知';

  @override
  String get notificationRuleSuppressNoticesDescription => '抑制通知';

  @override
  String get notificationRuleInviteForMeDescription => '我邀请的';

  @override
  String get notificationRuleMemberEventDescription => '成员事件';

  @override
  String get notificationRuleIsUserMentionDescription => '用户提及';

  @override
  String get notificationRuleContainsDisplayNameDescription => '包含显示名';

  @override
  String get notificationRuleIsRoomMentionDescription => '房间提及';

  @override
  String get notificationRuleRoomnotifDescription => '房间通知';

  @override
  String get notificationRuleTombstoneDescription => '墓碑';

  @override
  String get notificationRuleReactionDescription => '反应';

  @override
  String get notificationRuleRoomServerAclDescription => '房间服务器 ACL';

  @override
  String get notificationRuleSuppressEditsDescription => '抑制编辑';

  @override
  String get notificationRuleCallDescription => '电话';

  @override
  String get notificationRuleEncryptedRoomOneToOneDescription => '加密房间（一对一）';

  @override
  String get notificationRuleRoomOneToOneDescription => '房间（一对一）';

  @override
  String get notificationRuleMessageDescription => '消息';

  @override
  String get notificationRuleEncryptedDescription => '加密';

  @override
  String get notificationRuleServerAclDescription => '服务器 ACL';

  @override
  String get notificationRuleJitsiDescription => 'Jitsi';

  @override
  String unknownPushRule(Object ruleId) {
    return '自定义推送规则 $ruleId';
  }

  @override
  String get contentNotificationSettings => '内容通知设置';

  @override
  String get generalNotificationSettings => '一般通知设置';

  @override
  String get roomNotificationSettings => '房间通知设置';

  @override
  String get userSpecificNotificationSettings => '用户特定通知设置';

  @override
  String get otherNotificationSettings => '其他通知设置';

  @override
  String deletePushRuleTitle(Object ruleName) {
    return '删除推送规则 $ruleName？';
  }

  @override
  String deletePushRuleDescription(Object ruleName) {
    return '确定要删除推送规则 $ruleName 吗？此操作无法撤销。';
  }

  @override
  String get pusherDevices => '推送设备';

  @override
  String get syncNow => '立即同步';

  @override
  String get startAppUpPleaseWait => '启动中，请等待...';

  @override
  String get retry => '重试';

  @override
  String get reportIssue => '报告问题';

  @override
  String get closeApp => '关闭应用';

  @override
  String get creatingRoomPleaseWait => '创建房间，正在等待...';

  @override
  String get creatingSpacePleaseWait => '创建空间，正在等待...';

  @override
  String get joiningRoomPleaseWait => '加入房间，正在等待...';

  @override
  String get leavingRoomPleaseWait => '离开房间，正在等待...';

  @override
  String get deletingRoomPleaseWait => '删除房间，正在等待...';

  @override
  String get loadingArchivePleaseWait => '加载归档，正在等待...';

  @override
  String get clearingArchivePleaseWait => '清除归档，正在等待...';

  @override
  String get pleaseSelectAChatRoom => '请选择一个聊天房间';

  @override
  String get archiveIsEmpty => '归档中没有聊天记录。当您离开聊天时，您可以在这里找到它。';

  @override
  String audioMessageSendFromUser(String user) {
    return '音频消息来自 $user';
  }

  @override
  String get startRecordingVoiceMessage => '开始录音';

  @override
  String get endRecordingVoiceMessage => '结束录音';

  @override
  String get exportFileAs => '导出文件为...';

  @override
  String fileExported(String path) {
    return '文件已导出到 $path';
  }

  @override
  String get directoryDoesNotExist => '目录不存在或无法访问。';

  @override
  String get thread => '线程';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get alwaysUse24HourFormat => 'false';

  @override
  String get repeatPassword => '重复密码';

  @override
  String get notAnImage => '不是图片文件';

  @override
  String get remove => '删除';

  @override
  String get importNow => '立即导入';

  @override
  String get importEmojis => '导入 Emoji';

  @override
  String get importFromZipFile => '从 .zip 文件导入';

  @override
  String get exportEmotePack => '导出 Emote 包为 .zip';

  @override
  String get replace => '替换';

  @override
  String get about => '关于';

  @override
  String get accept => '接受';

  @override
  String acceptedTheInvitation(String username) {
    return '👍 $username 已接受邀请';
  }

  @override
  String get account => '账户';

  @override
  String activatedEndToEndEncryption(String username) {
    return '🔐 $username 已启用端到端加密';
  }

  @override
  String get addEmail => '添加邮箱';

  @override
  String get confirmMatrixId => '请确认您的 Matrix ID 以删除账户。';

  @override
  String supposedMxid(String mxid) {
    return '这应该是 $mxid';
  }

  @override
  String get addChatDescription => '添加聊天描述...';

  @override
  String get addToSpace => '添加到空间';

  @override
  String get admin => '管理员';

  @override
  String get alias => '别名';

  @override
  String get all => '所有';

  @override
  String get allChats => '所有聊天';

  @override
  String get commandHint_googly => '发送一些 Googly 眼睛';

  @override
  String get commandHint_cuddle => '发送贴贴';

  @override
  String get commandHint_hug => '发送拥抱';

  @override
  String googlyEyesContent(String senderName) {
    return '$senderName 发送了一些 Googly 眼睛';
  }

  @override
  String cuddleContent(String senderName) {
    return '$senderName 贴贴了你';
  }

  @override
  String hugContent(String senderName) {
    return '$senderName 拥抱了你';
  }

  @override
  String answeredTheCall(String senderName) {
    return '$senderName 接听了电话';
  }

  @override
  String get anyoneCanJoin => '任何人都可以加入';

  @override
  String get appLock => '应用程序锁';

  @override
  String get appLockDescription => '当应用程序未在使用时，使用 PIN 码锁定应用程序';

  @override
  String get archive => '归档';

  @override
  String get areGuestsAllowedToJoin => '访客用户是否允许加入';

  @override
  String get areYouSure => '确定吗？';

  @override
  String get areYouSureYouWantToLogout => '确定要注销吗？';

  @override
  String get askSSSSSign => '为了能够签署其他用户，您需要输入您的安全存储密码或恢复密钥。';

  @override
  String askVerificationRequest(String username) {
    return '是否接受 $username 的验证请求？';
  }

  @override
  String get autoplayImages => '自动播放动画贴纸和 Emoji';

  @override
  String badServerLoginTypesException(
    String serverVersions,
    String supportedVersions,
  ) {
    return '服务器支持的登录类型为：\n$serverVersions\n但此应用程序仅支持：\n$supportedVersions';
  }

  @override
  String get sendTypingNotifications => '发送输入通知';

  @override
  String get swipeRightToLeftToReply => '向右滑动以回复';

  @override
  String get sendOnEnter => '按 Enter 键发送';

  @override
  String badServerVersionsException(
    String serverVersions,
    String supportedVersions,
  ) {
    return '服务器支持的 Spec 版本为：\n$serverVersions\n但此应用程序仅支持：\n$supportedVersions';
  }

  @override
  String countChatsAndCountParticipants(String chats, Object participants) {
    return '$chats 个聊天和 $participants 个参与者';
  }

  @override
  String get noMoreChatsFound => '没有更多聊天了...';

  @override
  String get noChatsFoundHere => '这里没有聊天。使用下面的按钮开始与某人聊天。 ⤵️';

  @override
  String get joinedChats => '加入的聊天';

  @override
  String get unread => '未读';

  @override
  String get space => '空间';

  @override
  String get spaces => '空间';

  @override
  String get banFromChat => '从聊天中封禁';

  @override
  String get banned => '已封禁';

  @override
  String bannedUser(String username, String targetName) {
    return '$username 已封禁 $targetName';
  }

  @override
  String get blockDevice => '封禁设备';

  @override
  String get blocked => '已封禁';

  @override
  String get botMessages => '机器人消息';

  @override
  String get cancel => '取消';

  @override
  String cantOpenUri(String uri) {
    return '无法打开 URI $uri';
  }

  @override
  String get changeDeviceName => '更改设备名称';

  @override
  String changedTheChatAvatar(String username) {
    return '$username 已更改聊天头像';
  }

  @override
  String changedTheChatDescriptionTo(String username, String description) {
    return '$username 已将聊天描述更改为：\'$description\'';
  }

  @override
  String changedTheChatNameTo(String username, String chatname) {
    return '$username 已将聊天名称更改为：\'$chatname\'';
  }

  @override
  String changedTheChatPermissions(String username) {
    return '$username 已更改聊天权限';
  }

  @override
  String changedTheDisplaynameTo(String username, String displayname) {
    return '$username 已将显示名称更改为：\'$displayname\'';
  }

  @override
  String changedTheGuestAccessRules(String username) {
    return '$username 已更改访客访问规则';
  }

  @override
  String changedTheGuestAccessRulesTo(String username, String rules) {
    return '$username 已将访客访问规则更改为：$rules';
  }

  @override
  String changedTheHistoryVisibility(String username) {
    return '$username 已更改历史可见性';
  }

  @override
  String changedTheHistoryVisibilityTo(String username, String rules) {
    return '$username 已将历史可见性更改为：$rules';
  }

  @override
  String changedTheJoinRules(String username) {
    return '$username 已更改加入规则';
  }

  @override
  String changedTheJoinRulesTo(String username, String joinRules) {
    return '$username 已将加入规则更改为：$joinRules';
  }

  @override
  String changedTheProfileAvatar(String username) {
    return '$username 已更改头像';
  }

  @override
  String changedTheRoomAliases(String username) {
    return '$username 已更改房间别名';
  }

  @override
  String changedTheRoomInvitationLink(String username) {
    return '$username 已更改邀请链接';
  }

  @override
  String get changePassword => '更改密码';

  @override
  String get changeTheHomeserver => '更改主服务器';

  @override
  String get changeTheme => '更改样式';

  @override
  String get changeTheNameOfTheGroup => '更改组名称';

  @override
  String get changeYourAvatar => '更改您的头像';

  @override
  String get channelCorruptedDecryptError => '加密已损坏';

  @override
  String get chat => '聊天';

  @override
  String get yourChatBackupHasBeenSetUp => '聊天备份已设置';

  @override
  String get chatBackup => '聊天备份';

  @override
  String get chatBackupDescription => '您的旧消息已使用恢复密钥进行加密。请确保不要丢失它。';

  @override
  String get chatDetails => '聊天详情';

  @override
  String get chatHasBeenAddedToThisSpace => '聊天已添加到此空间';

  @override
  String get chats => '聊天';

  @override
  String get chooseAStrongPassword => '请选择一个强密码';

  @override
  String get clearArchive => '清除存档';

  @override
  String get close => '关闭';

  @override
  String get commandHint_markasdm => '将给定的 Matrix ID 标记为直接消息房间';

  @override
  String get commandHint_markasgroup => '标记为群组';

  @override
  String get commandHint_ban => '从该房间封禁给定用户';

  @override
  String get commandHint_clearcache => '清除缓存';

  @override
  String get commandHint_create => '创建一个空的群组聊天\n使用 --no-encryption 禁用加密';

  @override
  String get commandHint_discardsession => '丢弃会话';

  @override
  String get commandHint_dm => '开始直接聊天\n使用 --no-encryption 禁用加密';

  @override
  String get commandHint_html => '发送 HTML 格式化文本';

  @override
  String get commandHint_invite => '邀请特定用户到此房间';

  @override
  String get commandHint_join => '加入特定房间';

  @override
  String get commandHint_kick => '从该房间移除特定用户';

  @override
  String get commandHint_leave => '退出该房间';

  @override
  String get commandHint_me => '描述您自己';

  @override
  String get commandHint_myroomavatar => '设置该房间中您的头像 (使用 mxc-uri)';

  @override
  String get commandHint_myroomnick => '设置该房间中您的显示名称';

  @override
  String get commandHint_op => '将特定用户的权限等级设置为 (默认: 50)';

  @override
  String get commandHint_plain => '发送未格式化的文本';

  @override
  String get commandHint_react => '作为回应发送';

  @override
  String get commandHint_send => '发送文本';

  @override
  String get commandHint_unban => '从该房间解封特定用户';

  @override
  String get commandInvalid => '命令无效';

  @override
  String commandMissing(String command) {
    return '$command 不是命令。';
  }

  @override
  String get compareEmojiMatch => '请对比表情符号';

  @override
  String get compareNumbersMatch => '请对比数字';

  @override
  String get configureChat => '配置聊天';

  @override
  String get confirm => '确认';

  @override
  String get connect => '连接';

  @override
  String get contactHasBeenInvitedToTheGroup => '联系人已邀请至群组';

  @override
  String get containsDisplayName => '包含显示名称';

  @override
  String get containsUserName => '包含用户名';

  @override
  String get contentHasBeenReported => '内容已报告至服务器管理员';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get copy => '复制';

  @override
  String get copyToClipboard => '复制到剪贴板';

  @override
  String couldNotDecryptMessage(String error) {
    return '无法解密消息: $error';
  }

  @override
  String countParticipants(int count) {
    return '$count 个参与者';
  }

  @override
  String get create => '创建';

  @override
  String createdTheChat(String username) {
    return '💬 $username 创建了聊天';
  }

  @override
  String get createGroup => '创建群组';

  @override
  String get createNewSpace => '新空间';

  @override
  String get currentlyActive => '当前活跃';

  @override
  String get darkTheme => '暗黑';

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
  String get deactivateAccountWarning => '这将停用您的用户账户。这不能撤销！您确定吗？';

  @override
  String get defaultPermissionLevel => '新用户的默认权限等级';

  @override
  String get delete => '删除';

  @override
  String get deleteAccount => '删除账户';

  @override
  String get deleteMessage => '删除消息';

  @override
  String get device => '设备';

  @override
  String get deviceId => '设备 ID';

  @override
  String get devices => '设备';

  @override
  String get directChats => '直接聊天';

  @override
  String get allRooms => '所有群组聊天';

  @override
  String get displaynameHasBeenChanged => '显示名称已更改';

  @override
  String get downloadFile => '下载文件';

  @override
  String get edit => '编辑';

  @override
  String get editBlockedServers => '编辑封禁的服务器';

  @override
  String get chatPermissions => '聊天权限';

  @override
  String get editDisplayname => '编辑显示名称';

  @override
  String get editRoomAliases => '编辑房间别名';

  @override
  String get editRoomAvatar => '编辑房间头像';

  @override
  String get emoteExists => '表情符号已存在！';

  @override
  String get emoteInvalid => '表情符号短码无效！';

  @override
  String get emoteKeyboardNoRecents => '最近使用的表情符号将出现在这里...';

  @override
  String get emotePacks => '房间的表情符号包';

  @override
  String get emoteSettings => '表情符号设置';

  @override
  String get globalChatId => '全局聊天 ID';

  @override
  String get accessAndVisibility => '访问和可见性';

  @override
  String get accessAndVisibilityDescription => '谁可以加入此聊天，以及聊天如何被发现。';

  @override
  String get calls => '电话';

  @override
  String get customEmojisAndStickers => '自定义表情符号和贴纸';

  @override
  String get customEmojisAndStickersBody => '添加或分享自定义表情符号或贴纸，可在任何聊天中使用。';

  @override
  String get emoteShortcode => '表情符号短码';

  @override
  String get emoteWarnNeedToPick => '您需要选择一个表情符号短码和一张图片！';

  @override
  String get emptyChat => '空聊天';

  @override
  String get enableEmotesGlobally => '全局启用表情符号包';

  @override
  String get enableEncryption => '启用加密';

  @override
  String get enableEncryptionWarning => '您将无法再禁用加密，确定吗？';

  @override
  String get encrypted => '已加密';

  @override
  String get encryption => '加密';

  @override
  String get encryptionNotEnabled => '加密未启用';

  @override
  String endedTheCall(String senderName) {
    return '$senderName 已结束通话';
  }

  @override
  String get enterAnEmailAddress => '输入电子邮件地址';

  @override
  String get homeserver => 'Homeserver';

  @override
  String get enterYourHomeserver => '输入您的 Homeserver';

  @override
  String errorObtainingLocation(String error) {
    return '获取位置错误：$error';
  }

  @override
  String get everythingReady => '一切就绪！';

  @override
  String get extremeOffensive => '极度冒犯';

  @override
  String get fileName => '文件名';

  @override
  String get nebuchadnezzar => '尼布甲尼撒';

  @override
  String get fontSize => '字体大小';

  @override
  String get forward => '转发';

  @override
  String get fromJoining => 'From joining';

  @override
  String get fromTheInvitation => '来自邀请';

  @override
  String get goToTheNewRoom => '前往新房间';

  @override
  String get group => '群组';

  @override
  String get chatDescription => '聊天描述';

  @override
  String get chatDescriptionHasBeenChanged => '聊天描述已更改';

  @override
  String get groupIsPublic => '群组是公开的';

  @override
  String get groups => '群组';

  @override
  String groupWith(String displayname) {
    return '群组与 $displayname';
  }

  @override
  String get guestsAreForbidden => '禁止访客';

  @override
  String get guestsCanJoin => '访客可加入';

  @override
  String hasWithdrawnTheInvitationFor(String username, String targetName) {
    return '$username 已撤回对 $targetName 的邀请';
  }

  @override
  String get help => '帮助';

  @override
  String get hideRedactedEvents => '隐藏已编辑事件';

  @override
  String get hideRedactedMessages => '隐藏已编辑消息';

  @override
  String get hideRedactedMessagesBody => '如果有人编辑了消息，此消息将不再在聊天中可见。';

  @override
  String get hideInvalidOrUnknownMessageFormats => '隐藏无效或未知消息格式';

  @override
  String get howOffensiveIsThisContent => '此内容有多冒犯？';

  @override
  String get id => 'ID';

  @override
  String get identity => '身份';

  @override
  String get block => '封禁';

  @override
  String get blockedUsers => '封禁的用户';

  @override
  String get blockListDescription => '您可以封禁干扰您的用户。您将无法从个人封禁列表中的用户接收任何消息或房间邀请。';

  @override
  String blockUsername(String username) {
    return '忽略 $username';
  }

  @override
  String get iHaveClickedOnLink => '我已点击链接';

  @override
  String get incorrectPassphraseOrKey => '错误的密码或恢复密钥';

  @override
  String get inoffensive => '不冒犯';

  @override
  String get inviteContact => '邀请联系人';

  @override
  String inviteContactToGroupQuestion(String contact, String groupName) {
    return '您是否要将 $contact 邀请到聊天 \"$groupName\" 中？';
  }

  @override
  String get noChatDescriptionYet => '暂无聊天描述';

  @override
  String get tryAgain => '重试';

  @override
  String get invalidServerName => '无效的服务器名称';

  @override
  String get invited => '已邀请';

  @override
  String get redactMessageDescription =>
      'The message will be redacted for all participants in this conversation. This cannot be undone.';

  @override
  String get optionalRedactReason => '(可选) 编辑此消息的原因...';

  @override
  String invitedUser(String username, String targetName) {
    return '📩 $username 邀请了 $targetName';
  }

  @override
  String get invitedUsersOnly => '仅邀请的用户';

  @override
  String get inviteForMe => '我邀请的';

  @override
  String inviteText(String username, String link) {
    return '$username 邀请您加入尼布甲尼撒。\n1. 访问 https://snapcraft.io/nebuchadnezzar 并安装应用程序\n2. 注册或登录\n3. 打开邀请链接：\n$link';
  }

  @override
  String get isTyping => '正在输入...';

  @override
  String joinedTheChat(String username) {
    return '👋 $username 加入了聊天';
  }

  @override
  String get joinRoom => '加入房间';

  @override
  String kicked(String username, String targetName) {
    return '👞 $username 踢掉了 $targetName';
  }

  @override
  String kickedAndBanned(String username, String targetName) {
    return '🙅 $username 踢掉并封禁了 $targetName';
  }

  @override
  String get kickFromChat => '从聊天中踢掉';

  @override
  String lastActiveAgo(String localizedTimeShort) {
    return '最后活跃时间：$localizedTimeShort';
  }

  @override
  String get leave => '退出';

  @override
  String get leftTheChat => '退出聊天';

  @override
  String get license => '许可证';

  @override
  String get lightTheme => '亮色';

  @override
  String loadCountMoreParticipants(int count) {
    return '加载 $count 个参与者';
  }

  @override
  String get dehydrate => '导出会话并清除设备';

  @override
  String get dehydrateWarning => '此操作无法撤销。请确保安全存储备份文件。';

  @override
  String get dehydrateTor => 'TOR 用户：导出会话';

  @override
  String get dehydrateTorLong => '对于 TOR 用户，建议在关闭窗口之前导出会话。';

  @override
  String get hydrateTor => 'TOR 用户：导入会话';

  @override
  String get hydrateTorLong => '是否上次在 TOR 上导出会话？快速导入并继续聊天。';

  @override
  String get hydrate => '从备份文件恢复';

  @override
  String get loadingPleaseWait => '加载中... 请稍后。';

  @override
  String get loadMore => '加载更多...';

  @override
  String get locationDisabledNotice => '位置服务已禁用。请启用它们才能分享您的位置。';

  @override
  String get locationPermissionDeniedNotice => '位置权限被拒绝。请授予它们才能分享您的位置。';

  @override
  String get login => '登录';

  @override
  String logInTo(String homeserver) {
    return '登录到 $homeserver';
  }

  @override
  String get logout => '退出';

  @override
  String get memberChanges => '成员变更';

  @override
  String get mention => '提及';

  @override
  String get messages => '消息';

  @override
  String get messagesStyle => '消息:';

  @override
  String get moderator => '管理员';

  @override
  String get muteChat => '静音聊天';

  @override
  String get needPantalaimonWarning => '请注意，您需要 Pantalaimon 才能使用端到端加密。';

  @override
  String get newChat => '新聊天';

  @override
  String get newMessageInNebuchadnezzar => '💬 在尼布甲尼撒中开始新聊天';

  @override
  String get newVerificationRequest => '新的验证请求！';

  @override
  String get next => '下一个';

  @override
  String get no => '否';

  @override
  String get noConnectionToTheServer => '没有连接到服务器';

  @override
  String get noEmotesFound => '没有找到表情符号。 😕';

  @override
  String get noEncryptionForPublicRooms => '您只能在房间不再可公开访问时激活端到端加密。';

  @override
  String get noGoogleServicesWarning =>
      'Firebase Cloud Messaging 似乎在您的设备上不可用。为了仍然接收推送通知，我们建议安装 ntfy。使用 ntfy 或其他 Unified Push 提供程序，您可以以数据安全的方式接收推送通知。您可以从 PlayStore 或 F-Droid 下载 ntfy。';

  @override
  String noMatrixServer(String server1, String server2) {
    return '$server1 不是 Matrix 服务器，使用 $server2 代替？';
  }

  @override
  String get shareInviteLink => '分享邀请链接';

  @override
  String get scanQrCode => '扫描二维码';

  @override
  String get none => '无';

  @override
  String get noPasswordRecoveryDescription => '您还没有添加恢复密码的方式。';

  @override
  String get noPermission => '没有权限';

  @override
  String get noRoomsFound => '没有找到房间…';

  @override
  String get notifications => '通知';

  @override
  String get notificationsEnabledForThisAccount => '通知已为此账号启用';

  @override
  String numUsersTyping(int count) {
    return '$count 个用户正在输入...';
  }

  @override
  String get obtainingLocation => '正在获取位置...';

  @override
  String get offensive => '冒犯';

  @override
  String get offline => '离线';

  @override
  String get ok => '好的';

  @override
  String get online => '在线';

  @override
  String get onlineKeyBackupEnabled => '已启用在线密钥备份';

  @override
  String get oopsPushError => '哎呀！很遗憾，设置推送通知时出错。';

  @override
  String get oopsSomethingWentWrong => '哎呀，发生了一些错误。';

  @override
  String get openAppToReadMessages => '打开应用读取消息';

  @override
  String get openCamera => '打开相机';

  @override
  String get openVideoCamera => '打开相机录制视频';

  @override
  String get oneClientLoggedOut => '您的其中一个客户端已注销';

  @override
  String get addAccount => '添加账号';

  @override
  String get editBundlesForAccount => '编辑此账号的捆绑包';

  @override
  String get addToBundle => '添加到捆绑包';

  @override
  String get removeFromBundle => '从此捆绑包中移除';

  @override
  String get bundleName => '捆绑包名称';

  @override
  String get enableMultiAccounts => '(BETA) 启用此设备上的多账号';

  @override
  String get openInMaps => '在地图中打开';

  @override
  String get link => '链接';

  @override
  String get serverRequiresEmail => '此服务器注册时需要验证您的电子邮件地址。';

  @override
  String get or => '或';

  @override
  String get participant => '参与人';

  @override
  String get passphraseOrKey => '恢复密码或恢复密钥';

  @override
  String get password => '密码';

  @override
  String get passwordForgotten => '忘记密码';

  @override
  String get passwordHasBeenChanged => '密码已更改';

  @override
  String get hideMemberChangesInPublicChats => '隐藏公共聊天中的成员变更';

  @override
  String get hideMemberChangesInPublicChatsBody =>
      '在公共聊天中不显示有人加入或离开的变更，以提高可读性。';

  @override
  String get overview => '概览';

  @override
  String get notifyMeFor => '通知我';

  @override
  String get passwordRecoverySettings => '密码恢复设置';

  @override
  String get passwordRecovery => '密码恢复';

  @override
  String get people => '参与人';

  @override
  String get pickImage => '选择图片';

  @override
  String get pin => 'Pin';

  @override
  String play(String fileName) {
    return '播放 $fileName';
  }

  @override
  String get pleaseChoose => '请选择';

  @override
  String get pleaseChooseAPasscode => '请选择一个恢复密码';

  @override
  String get pleaseClickOnLink => '请点击电子邮件中的链接，然后继续。';

  @override
  String get pleaseEnter4Digits => '请输入4位数字，或留空禁用应用程序锁。';

  @override
  String get pleaseEnterRecoveryKey => '请输入恢复密钥:';

  @override
  String get pleaseEnterYourPassword => '请输入您的密码';

  @override
  String get pleaseEnterYourPin => '请输入您的 Pin';

  @override
  String get pleaseEnterYourUsername => '请输入您的用户名';

  @override
  String get pleaseFollowInstructionsOnWeb => '请按照网站上的说明操作，然后点击下一步。';

  @override
  String get privacy => '隐私';

  @override
  String get publicRooms => '公共房间';

  @override
  String get pushRules => '推送规则';

  @override
  String get reason => '原因';

  @override
  String get recording => '录音';

  @override
  String redactedBy(String username) {
    return '由 $username 编辑';
  }

  @override
  String get directChat => '直接聊天';

  @override
  String redactedByBecause(String username, String reason) {
    return '由 $username 编辑，原因： \"$reason\"';
  }

  @override
  String redactedAnEvent(String username) {
    return '$username 编辑了事件';
  }

  @override
  String get redactMessage => '编辑消息';

  @override
  String get register => '注册';

  @override
  String get reject => '拒绝';

  @override
  String rejectedTheInvitation(String username) {
    return '$username 拒绝了邀请';
  }

  @override
  String get rejoin => '重新加入';

  @override
  String get removeAllOtherDevices => '删除所有其他设备';

  @override
  String removedBy(String username) {
    return '由 $username 删除';
  }

  @override
  String get removeDevice => '删除设备';

  @override
  String get unbanFromChat => '从聊天中解封';

  @override
  String get removeYourAvatar => '删除您的头像';

  @override
  String get replaceRoomWithNewerVersion => '用更新版本的房间替换';

  @override
  String get reply => '回复';

  @override
  String get reportMessage => '报告消息';

  @override
  String get requestPermission => '请求权限';

  @override
  String get roomHasBeenUpgraded => '房间已升级';

  @override
  String get roomVersion => '房间版本';

  @override
  String get saveFile => '保存文件';

  @override
  String get search => '搜索';

  @override
  String get security => '安全';

  @override
  String get recoveryKey => '恢复密钥';

  @override
  String get recoveryKeyLost => '恢复密钥丢失?';

  @override
  String seenByUser(String username) {
    return '由 $username 查看';
  }

  @override
  String get send => '发送';

  @override
  String get sendAMessage => '发送消息';

  @override
  String get sendAsText => '以文本发送';

  @override
  String get sendAudio => '发送音频';

  @override
  String get sendFile => '发送文件';

  @override
  String get sendImage => '发送图片';

  @override
  String get sendMessages => '发送消息';

  @override
  String get sendOriginal => '发送原始消息';

  @override
  String get sendSticker => '发送贴纸';

  @override
  String get sendVideo => '发送视频';

  @override
  String sentAFile(String username) {
    return '📁 $username 发送了一个文件';
  }

  @override
  String sentAnAudio(String username) {
    return '🎤 $username 发送了一个音频';
  }

  @override
  String sentAPicture(String username) {
    return '🖼️ $username 发送了一张图片';
  }

  @override
  String sentASticker(String username) {
    return '😊 $username 发送了一个贴纸';
  }

  @override
  String sentAVideo(String username) {
    return '🎥 $username 发送了一个视频';
  }

  @override
  String sentCallInformations(String senderName) {
    return '$senderName 发送了通话信息';
  }

  @override
  String get separateChatTypes => '将直接聊天和群组分开';

  @override
  String get setAsCanonicalAlias => '设置为主别名';

  @override
  String get setCustomEmotes => '设置自定义表情';

  @override
  String get setChatDescription => '设置聊天描述';

  @override
  String get setInvitationLink => '设置邀请链接';

  @override
  String get setPermissionsLevel => '设置权限级别';

  @override
  String get setStatus => '设置状态';

  @override
  String get settings => '设置';

  @override
  String get share => '分享';

  @override
  String sharedTheLocation(String username) {
    return '$username 分享了他的位置';
  }

  @override
  String get shareLocation => '分享位置';

  @override
  String get showPassword => '显示密码';

  @override
  String get presenceStyle => 'Presence:';

  @override
  String get presencesToggle => '显示其他用户的状态消息';

  @override
  String get singlesignon => '单点登录';

  @override
  String get skip => '跳过';

  @override
  String get sourceCode => '源代码';

  @override
  String get spaceIsPublic => '空间是公开的';

  @override
  String get spaceName => '空间名称';

  @override
  String startedACall(String senderName) {
    return '$senderName 发起通话';
  }

  @override
  String get startFirstChat => '开始你的第一个聊天';

  @override
  String get status => '状态';

  @override
  String get statusExampleMessage => '你好吗？';

  @override
  String get submit => '提交';

  @override
  String get synchronizingPleaseWait => '同步中... 请稍后';

  @override
  String get systemTheme => '系统';

  @override
  String get theyDontMatch => '他们不匹配';

  @override
  String get theyMatch => '他们匹配';

  @override
  String get title => '尼布甲尼撒';

  @override
  String get toggleFavorite => '切换收藏';

  @override
  String get toggleMuted => '切换静音';

  @override
  String get toggleUnread => '切换未读/已读';

  @override
  String get tooManyRequestsWarning => '请求过多，请稍后重试！';

  @override
  String get transferFromAnotherDevice => '从另一个设备传输';

  @override
  String get tryToSendAgain => '重新发送';

  @override
  String get unavailable => '不可用';

  @override
  String unbannedUser(String username, String targetName) {
    return '$username 已取消对 $targetName 的封禁';
  }

  @override
  String get unblockDevice => '取消封禁设备';

  @override
  String get unknownDevice => '未知设备';

  @override
  String get unknownEncryptionAlgorithm => '未知加密算法';

  @override
  String unknownEvent(String type) {
    return '未知事件 \'$type\'';
  }

  @override
  String get unmuteChat => '取消静音聊天';

  @override
  String get unpin => '取消置顶';

  @override
  String unreadChats(int unreadCount) {
    String _temp0 = intl.Intl.pluralLogic(
      unreadCount,
      locale: localeName,
      other: '$unreadCount 条未读消息',
      one: '1 条未读消息',
    );
    return '$_temp0';
  }

  @override
  String userAndOthersAreTyping(String username, int count) {
    return '$username 和 $count 个其他用户正在输入...';
  }

  @override
  String userAndUserAreTyping(String username, String username2) {
    return '$username 和 $username2 正在输入...';
  }

  @override
  String userIsTyping(String username) {
    return '$username 正在输入...';
  }

  @override
  String userLeftTheChat(String username) {
    return '🚪 $username 已退出聊天';
  }

  @override
  String get username => '用户名';

  @override
  String userSentUnknownEvent(String username, String type) {
    return '$username 发送了 $type 事件';
  }

  @override
  String get unverified => '未验证';

  @override
  String get verified => '已验证';

  @override
  String get verify => '验证';

  @override
  String get verifyStart => '开始验证';

  @override
  String get verifySuccess => '验证成功！';

  @override
  String get verifyTitle => '验证其他账号';

  @override
  String get videoCall => '视频通话';

  @override
  String get visibilityOfTheChatHistory => '聊天历史可见性';

  @override
  String get visibleForAllParticipants => '对所有参与者可见';

  @override
  String get visibleForEveryone => '对所有人可见';

  @override
  String get voiceMessage => '语音消息';

  @override
  String get waitingPartnerAcceptRequest => '等待对方接受请求...';

  @override
  String get waitingPartnerEmoji => '等待对方接受表情...';

  @override
  String get waitingPartnerNumbers => '等待对方接受数字...';

  @override
  String get wallpaper => '壁纸:';

  @override
  String get warning => '警告！';

  @override
  String get weSentYouAnEmail => '我们已发送您一封电子邮件';

  @override
  String get whoCanPerformWhichAction => '谁可以执行哪些操作';

  @override
  String get whoIsAllowedToJoinThisGroup => '谁可以加入此群组';

  @override
  String get whyDoYouWantToReportThis => '为什么要报告此消息？';

  @override
  String get wipeChatBackup => '是否要清除聊天备份以创建新的恢复密钥？';

  @override
  String get withTheseAddressesRecoveryDescription => '使用这些地址可以恢复您的密码。';

  @override
  String get writeAMessage => '输入消息...';

  @override
  String get yes => '是';

  @override
  String get you => '您';

  @override
  String get youAreNoLongerParticipatingInThisChat => '您已不再参与此聊天';

  @override
  String get youHaveBeenBannedFromThisChat => '您已被此聊天禁止';

  @override
  String get yourPublicKey => '您的公钥';

  @override
  String get messageInfo => '消息信息';

  @override
  String get time => 'Time';

  @override
  String get messageType => '消息类型';

  @override
  String get sender => 'Sender';

  @override
  String get openGallery => '打开相册';

  @override
  String get removeFromSpace => '从空间移除';

  @override
  String get addToSpaceDescription => '选择一个空间将此聊天添加到其中。';

  @override
  String get start => 'Start';

  @override
  String get pleaseEnterRecoveryKeyDescription =>
      '要解锁您旧的消息，请输入在之前会话中生成的恢复密钥。您的恢复密钥不是您的密码。';

  @override
  String get publish => '发布';

  @override
  String videoWithSize(String size) {
    return '视频 ($size)';
  }

  @override
  String get openChat => '打开聊天';

  @override
  String get markAsRead => '标记为已读';

  @override
  String get reportUser => '报告用户';

  @override
  String get dismiss => '解散';

  @override
  String reactedWith(String sender, String reaction) {
    return '$sender 用 $reaction 作出了反应';
  }

  @override
  String get pinMessage => '固定到房间';

  @override
  String get confirmEventUnpin => '确定要永久取消固定事件吗？';

  @override
  String get emojis => '表情符号';

  @override
  String get placeCall => '拨打电话';

  @override
  String get voiceCall => '语音通话';

  @override
  String get unsupportedAndroidVersion => '不支持的 Android 版本';

  @override
  String get unsupportedAndroidVersionLong =>
      '此功能需要更新的 Android 版本。请检查是否有更新或 Lineage OS 支持。';

  @override
  String get videoCallsBetaWarning =>
      '请注意，视频通话当前处于测试阶段。它们可能无法按预期工作或在所有平台上都无法正常工作。';

  @override
  String get experimentalVideoCalls => '实验性视频通话';

  @override
  String get emailOrUsername => '邮箱或用户名';

  @override
  String get indexedDbErrorTitle => '隐私模式问题';

  @override
  String get indexedDbErrorLong =>
      '消息存储默认情况下在隐私模式下未启用。\n请访问\n - about:config\n - 设置 dom.indexedDB.privateBrowsing.enabled 为 true\n否则，尼布甲尼撒将无法运行。';

  @override
  String switchToAccount(int number) {
    return '切换到账号 $number';
  }

  @override
  String get nextAccount => '下一个账号';

  @override
  String get previousAccount => '上一个账号';

  @override
  String get addWidget => '添加小部件';

  @override
  String get widgetVideo => '视频';

  @override
  String get widgetEtherpad => '文本笔记';

  @override
  String get widgetJitsi => 'Jitsi Meet';

  @override
  String get widgetCustom => '自定义';

  @override
  String get widgetName => '名称';

  @override
  String get widgetUrlError => '这不是一个有效的 URL。';

  @override
  String get widgetNameError => '请提供显示名称。';

  @override
  String get errorAddingWidget => '添加小部件时出错。';

  @override
  String get youRejectedTheInvitation => '您拒绝了邀请';

  @override
  String get youJoinedTheChat => '您加入了聊天';

  @override
  String get youAcceptedTheInvitation => '👍 您接受了邀请';

  @override
  String youBannedUser(String user) {
    return '您禁止了 $user';
  }

  @override
  String youHaveWithdrawnTheInvitationFor(String user) {
    return '您已撤回对 $user 的邀请';
  }

  @override
  String youInvitedToBy(String alias) {
    return '📩 您已通过链接邀请到:\n$alias';
  }

  @override
  String youInvitedBy(String user) {
    return '📩 $user 邀请了您';
  }

  @override
  String invitedBy(String user) {
    return '📩 邀请人 $user';
  }

  @override
  String youInvitedUser(String user) {
    return '📩 您邀请了 $user';
  }

  @override
  String youKicked(String user) {
    return '👞 您踢掉了 $user';
  }

  @override
  String youKickedAndBanned(String user) {
    return '🙅 您踢掉并禁止了 $user';
  }

  @override
  String youUnbannedUser(String user) {
    return '您已取消禁止 $user';
  }

  @override
  String hasKnocked(String user) {
    return '🚪 $user 已敲门';
  }

  @override
  String get usersMustKnock => '用户必须敲门';

  @override
  String get noOneCanJoin => '没有人可以加入';

  @override
  String userWouldLikeToChangeTheChat(String user) {
    return '$user 想加入聊天';
  }

  @override
  String get noPublicLinkHasBeenCreatedYet => '暂无公共链接';

  @override
  String get knock => '敲门';

  @override
  String get users => '用户';

  @override
  String get unlockOldMessages => '解锁旧消息';

  @override
  String get storeInSecureStorageDescription => '将恢复密钥存储在该设备的安全存储中。';

  @override
  String get saveKeyManuallyDescription => '手动保存此密钥，方法是触发系统分享对话框或剪贴板。';

  @override
  String get storeInAndroidKeystore => '存储在 Android KeyStore 中';

  @override
  String get storeInAppleKeyChain => '存储在 Apple KeyChain 中';

  @override
  String get storeSecurlyOnThisDevice => '在该设备上安全存储';

  @override
  String countFiles(int count) {
    return '$count 文件';
  }

  @override
  String get user => '用户';

  @override
  String get custom => '自定义';

  @override
  String get foregroundServiceRunning => '当前台服务运行时，此通知会出现。';

  @override
  String get screenSharingTitle => '屏幕分享';

  @override
  String get screenSharingDetail => '您正在 FuffyChat 中分享屏幕';

  @override
  String get callingPermissions => '调用权限';

  @override
  String get callingAccount => '调用账户';

  @override
  String get callingAccountDetails => '允许尼布甲尼撒使用原生Android拨号器应用';

  @override
  String get appearOnTop => '在顶部显示';

  @override
  String get appearOnTopDetails =>
      '允许应用在顶部显示（如果您已经将 Fluffychat 设置为调用账户，则无需此权限）';

  @override
  String get otherCallingPermissions => '相机和其他尼布甲尼撒权限';

  @override
  String get whyIsThisMessageEncrypted => '为什么此消息不可读？';

  @override
  String get noKeyForThisMessage =>
      '如果在您登录到此设备上的帐户之前发送了邮件，则可能会发生这种情况。\n\n也可能是发件人阻止了您的设备或网络连接出现问题。\n\n您可以在另一个会话中读取消息吗？然后您可以从中传输消息！转到“设置”>“设备”，并确保您的设备已相互验证。当您下次打开房间并且两个会话都在前台时，密钥将自动传输。\n\n是否不希望在注销或切换设备时丢失密钥？确保已在设置中启用聊天室备份。';

  @override
  String get newGroup => '新群组';

  @override
  String get newSpace => '新空间';

  @override
  String get enterSpace => '进入空间';

  @override
  String get enterRoom => '进入房间';

  @override
  String get allSpaces => '所有空间';

  @override
  String numChats(int number) {
    return '$number 条聊天记录';
  }

  @override
  String get hideUnimportantStateEvents => '隐藏不重要的状态事件';

  @override
  String get hidePresences => '隐藏状态列表？';

  @override
  String get doNotShowAgain => '不再显示';

  @override
  String wasDirectChatDisplayName(String oldDisplayName) {
    return '空聊天（之前显示为 $oldDisplayName）';
  }

  @override
  String get newSpaceDescription => '空间允许您整合您的聊天记录并构建私有或公共社区。';

  @override
  String get encryptThisChat => '加密此聊天';

  @override
  String get disableEncryptionWarning => '出于安全考虑，您不能在已启用加密的聊天中禁用加密。';

  @override
  String get sorryThatsNotPossible => '抱歉... 这是不可能的';

  @override
  String get deviceKeys => '设备密钥:';

  @override
  String get reopenChat => '重新打开聊天';

  @override
  String get noBackupWarning => '警告！如果未启用聊天备份，您将无法访问加密的消息。强烈建议在注销之前先启用聊天备份。';

  @override
  String get noOtherDevicesFound => '未找到其他设备';

  @override
  String fileIsTooBigForServer(int max) {
    return '无法发送！服务器支持的附件大小上限为 $max。';
  }

  @override
  String fileHasBeenSavedAt(String path) {
    return '文件已保存至 $path';
  }

  @override
  String get jumpToLastReadMessage => '跳转到最后读取的消息';

  @override
  String get readUpToHere => '读取到此处';

  @override
  String get jump => '跳转';

  @override
  String get openLinkInBrowser => '在浏览器中打开链接';

  @override
  String get reportErrorDescription => '😭 哦不。出了点问题。您可以考虑将此错误报告给开发人员。';

  @override
  String get report => '报告';

  @override
  String get signInWithPassword => '使用密码登录';

  @override
  String get pleaseTryAgainLaterOrChooseDifferentServer => '请稍后重试或选择其他服务器。';

  @override
  String signInWith(String provider) {
    return '使用 $provider 登录';
  }

  @override
  String get profileNotFound => '用户在服务器上未找到。可能是连接问题或用户不存在。';

  @override
  String get setTheme => '设置主题:';

  @override
  String get setColorTheme => '设置颜色主题:';

  @override
  String get invite => 'Invite';

  @override
  String get inviteGroupChat => '📨 邀请群组聊天';

  @override
  String get invitePrivateChat => '📨 邀请私人聊天';

  @override
  String get invalidInput => '无效输入！';

  @override
  String wrongPinEntered(int seconds) {
    return '错误的 PIN 码！请在 $seconds 秒后重试...';
  }

  @override
  String get pleaseEnterANumber => '请输入大于 0 的数字';

  @override
  String get archiveRoomDescription => '聊天将被移动到存档。其他用户将能够看到您已退出聊天。';

  @override
  String get roomUpgradeDescription =>
      '聊天将被重新创建为新的房间版本。所有参与者都将被通知切换到新的聊天。您可以在 https://spec.matrix.org/latest/rooms/ 了解更多关于房间版本的信息。';

  @override
  String get removeDevicesDescription => '您将从该设备注销，无法接收消息。';

  @override
  String get banUserDescription => '该用户将被禁止加入聊天，直到被取消禁止。';

  @override
  String get unbanUserDescription => '用户将能够再次加入聊天，如果他们尝试。';

  @override
  String get kickUserDescription => '该用户被踢出聊天，但未被禁止。在公共聊天中，用户可以随时重新加入。';

  @override
  String get makeAdminDescription => '一旦您将此用户设为管理员，您可能无法撤销此操作，因为他们将具有与您相同的权限。';

  @override
  String get pushNotificationsNotAvailable => '推送通知不可用';

  @override
  String get learnMore => '了解更多';

  @override
  String get yourGlobalUserIdIs => '您的全局用户 ID 为: ';

  @override
  String noUsersFoundWithQuery(String query) {
    return '不幸的是，没有用户能够使用 \"$query\" 进行搜索。请检查是否拼写错误。';
  }

  @override
  String get knocking => '敲门';

  @override
  String chatCanBeDiscoveredViaSearchOnServer(String server) {
    return '聊天可以通过在 $server 上搜索来发现';
  }

  @override
  String get searchChatsRooms => '搜索 #chats, @users...';

  @override
  String get nothingFound => '未找到...';

  @override
  String get groupName => '群组名称';

  @override
  String get createGroupAndInviteUsers => '创建群组并邀请用户';

  @override
  String get groupCanBeFoundViaSearch => '群组可以通过搜索来发现';

  @override
  String get wrongRecoveryKey => '抱歉... 这似乎不是正确的恢复密钥。';

  @override
  String get startConversation => '开始对话';

  @override
  String get commandHint_sendraw => '发送原始 JSON';

  @override
  String get databaseMigrationTitle => '数据库已优化';

  @override
  String get databaseMigrationBody => '请稍等。这可能需要一些时间。';

  @override
  String get leaveEmptyToClearStatus => '留空以清除您的状态。';

  @override
  String get select => '选择';

  @override
  String get searchForUsers => '搜索 @users...';

  @override
  String get pleaseEnterYourCurrentPassword => '请输入您当前的密码';

  @override
  String get newPassword => '新密码';

  @override
  String get pleaseChooseAStrongPassword => '请选择一个强密码';

  @override
  String get passwordsDoNotMatch => '密码不匹配';

  @override
  String get passwordIsWrong => '您输入的密码错误';

  @override
  String get publicLink => '公共链接';

  @override
  String get publicChatAddresses => '公共聊天地址';

  @override
  String get createNewAddress => '创建新地址';

  @override
  String get joinSpace => '加入空间';

  @override
  String get publicSpaces => '公共空间';

  @override
  String get addChatOrSubSpace => '添加聊天或子空间';

  @override
  String get subspace => '子空间';

  @override
  String get decline => '拒绝';

  @override
  String get thisDevice => '此设备:';

  @override
  String get initAppError => '初始化应用时出错';

  @override
  String get userRole => '用户角色';

  @override
  String minimumPowerLevel(int level) {
    return '$level 是最低权限等级。';
  }

  @override
  String searchIn(String chat) {
    return '在聊天 \"$chat\" 中搜索...';
  }

  @override
  String get searchMore => '搜索更多...';

  @override
  String get gallery => '相册';

  @override
  String get files => '文件';

  @override
  String databaseBuildErrorBody(String url, String error) {
    return '无法构建 SQlite 数据库。应用程序目前尝试使用旧版数据库。请将此错误报告给开发人员 $url。错误消息为: $error';
  }

  @override
  String sessionLostBody(String url, String error) {
    return '您的会话已丢失。请将此错误报告给开发人员 $url。错误消息为: $error';
  }

  @override
  String restoreSessionBody(String url, String error) {
    return '应用程序现在尝试从备份中恢复您的会话。请将此错误报告给开发人员 $url。错误消息为: $error';
  }

  @override
  String forwardMessageTo(String roomName) {
    return '将消息转发到 $roomName？';
  }

  @override
  String get sendReadReceipts => '发送已读回执';

  @override
  String get sendTypingNotificationsDescription => '其他聊天参与者可以看到您是否正在输入新消息。';

  @override
  String get sendReadReceiptsDescription => '其他聊天参与者可以看到您是否已读取消息。';

  @override
  String get formattedMessages => '格式化消息';

  @override
  String get formattedMessagesDescription => '使用 markdown 显示丰富的消息内容，例如加粗文本。';

  @override
  String get verifyOtherUser => '🔐 验证其他用户';

  @override
  String get verifyOtherUserDescription =>
      'If you verify another user, you can be sure that you know who you are really writing to. 💪\n\nWhen you start a verification, you and the other user will see a popup in the app. There you will then see a series of emojis or numbers that you have to compare with each other.\n\nThe best way to do this is to meet up or start a video call. 👭';

  @override
  String get verifyOtherDevice => '🔐 验证其他设备';

  @override
  String get verifyOtherDeviceDescription =>
      'When you verify another device, those devices can exchange keys, increasing your overall security. 💪 When you start a verification, a popup will appear in the app on both devices. There you will then see a series of emojis or numbers that you have to compare with each other. It\'s best to have both devices handy before you start the verification. 🤳';

  @override
  String acceptedKeyVerification(String sender) {
    return '$sender 已接受密钥验证';
  }

  @override
  String canceledKeyVerification(String sender) {
    return '$sender 已取消密钥验证';
  }

  @override
  String completedKeyVerification(String sender) {
    return '$sender 已完成密钥验证';
  }

  @override
  String isReadyForKeyVerification(String sender) {
    return '$sender 已准备好密钥验证';
  }

  @override
  String requestedKeyVerification(String sender) {
    return '$sender 请求密钥验证';
  }

  @override
  String startedKeyVerification(String sender) {
    return '$sender 已开始密钥验证';
  }

  @override
  String get transparent => '透明';

  @override
  String get incomingMessages => '入站消息';

  @override
  String get stickers => '贴纸';

  @override
  String get discover => '发现';

  @override
  String get commandHint_ignore => '忽略给定的 Matrix ID';

  @override
  String get commandHint_unignore => '取消忽略给定的 Matrix ID';

  @override
  String unreadChatsInApp(String appname, String unread) {
    return '$appname: $unread 未读聊天';
  }

  @override
  String get noDatabaseEncryption => '数据库加密在该平台上不支持';

  @override
  String thereAreCountUsersBlocked(Object count) {
    return '当前有 $count 个用户被阻塞。';
  }

  @override
  String get restricted => '受限';

  @override
  String get knockRestricted => 'Knock restricted';

  @override
  String goToSpace(Object space) {
    return '前往空间: $space';
  }

  @override
  String get markAsUnread => '标记为未读';

  @override
  String userLevel(int level) {
    return '$level - 用户';
  }

  @override
  String moderatorLevel(int level) {
    return '$level - 主持人';
  }

  @override
  String adminLevel(int level) {
    return '$level - 管理员';
  }

  @override
  String get changeGeneralChatSettings => '更改一般聊天设置';

  @override
  String get inviteOtherUsers => '邀请其他用户加入此聊天';

  @override
  String get changeTheChatPermissions => '更改聊天权限';

  @override
  String get changeTheVisibilityOfChatHistory => '更改聊天历史记录的可见性';

  @override
  String get changeTheCanonicalRoomAlias => '更改主要公共聊天地址';

  @override
  String get sendRoomNotifications => '发送 @room 通知';

  @override
  String get changeTheDescriptionOfTheGroup => '更改聊天描述';

  @override
  String get chatPermissionsDescription =>
      '定义在该聊天中需要哪些权限等级才能执行某些操作。权限等级 0、50 和 100 通常代表用户、主持人和管理员，但任何等级都可能。';

  @override
  String updateInstalled(String version) {
    return '🎉 更新 $version 已安装！';
  }

  @override
  String get changelog => '更新日志';

  @override
  String get sendCanceled => '发送已取消';

  @override
  String get loginWithMatrixId => '使用 Matrix-ID 登录';

  @override
  String get discoverHomeservers => '发现 homeserver';

  @override
  String get whatIsAHomeserver => '什么是 homeserver？';

  @override
  String get homeserverDescription =>
      '所有您的数据都存储在 homeserver 上，就像电子邮件提供程序一样。您可以选择使用哪个 homeserver，同时仍然可以与每个人通信。更多信息请访问 https://matrix.org。';

  @override
  String get doesNotSeemToBeAValidHomeserver => '似乎不是兼容的 homeserver。URL 错误？';

  @override
  String get calculatingFileSize => '计算文件大小...';

  @override
  String get prepareSendingAttachment => '准备发送附件...';

  @override
  String get sendingAttachment => '发送附件...';

  @override
  String get generatingVideoThumbnail => '生成视频缩略图...';

  @override
  String get compressVideo => '压缩视频...';

  @override
  String sendingAttachmentCountOfCount(int index, int length) {
    return '发送附件 $index 中的 $length...';
  }

  @override
  String serverLimitReached(int seconds) {
    return '已达服务器上限！等待 $seconds 秒...';
  }

  @override
  String get yesterday => '昨天';

  @override
  String get today => '今天';

  @override
  String get member => '成员';

  @override
  String get changePowerLevel => '更改权限等级';

  @override
  String get canNotChangePowerLevel => '权限等级不能低于您要更改的用户的权限等级。';

  @override
  String changePowerLevelForUserToValue(Object user, Object value) {
    return '将 $user 的权限等级更改为 $value？';
  }

  @override
  String get loginInPleaseWait => '登录中，请稍后...';

  @override
  String get settingUpApplicationPleaseWait => '设置应用程序，请稍后...';

  @override
  String get checkingEncryptionPleaseWait => '检查加密，请稍后...';

  @override
  String get settingUpEncryptionPleaseWait => '设置加密，请稍后...';

  @override
  String canonicalAliasInvalidInput(String homeServer) {
    return '无效输入，必须匹配 #SOMETHING:$homeServer';
  }

  @override
  String canonicalAliasHelperText(String roomName, String homeServer) {
    return '示例: #\$$roomName:\$$homeServer';
  }

  @override
  String get shareKeysWithAllDevices => '分享密钥到所有设备';

  @override
  String get shareKeysWithCrossVerifiedDevices => '分享密钥到已验证设备';

  @override
  String get shareKeysWithCrossVerifiedDevicesIfEnabled => '分享密钥到已验证设备（如果已启用）';

  @override
  String get shareKeysWithDirectlyVerifiedDevicesOnly => '分享密钥到直接验证设备';

  @override
  String get joinRules => '加入规则';

  @override
  String get showTheseEventsInTheChat => '显示这些事件在聊天中';

  @override
  String get playMedia => '播放媒体';

  @override
  String get appendToQueue => '添加到队列';

  @override
  String appendedToQueue(String title) {
    return '已添加到队列: $title';
  }

  @override
  String get queue => '队列';

  @override
  String get clearQueue => '清除队列';

  @override
  String get queueCleared => '队列已清除';

  @override
  String get radioBrowser => '广播浏览器';

  @override
  String get selectStation => '选择电台';

  @override
  String get noStationFound => '未找到电台';

  @override
  String get favorites => '收藏';

  @override
  String get addToFavorites => '添加到收藏';

  @override
  String get removeFromFavorites => '从收藏中移除';

  @override
  String get favoriteAdded => '已添加到收藏';

  @override
  String get favoriteRemoved => '已从收藏中移除';

  @override
  String get notSupportedByServer => '服务器不支持此操作';

  @override
  String get radioStation => '广播电台';

  @override
  String get radioStations => '广播电台';

  @override
  String get noRadioBrowserConnected => '未连接广播浏览器';

  @override
  String appendMediaToQueueDescription(String title) {
    return '$title 已在队列中。是否要将其添加到队列末尾？';
  }

  @override
  String get appendMediaToQueueTitle => '添加媒体到队列';

  @override
  String appendMediaToQueue(String title) {
    return '添加到队列: $title';
  }

  @override
  String get playNowButton => '立即播放';

  @override
  String get appendMediaToQueueButton => '添加到队列';

  @override
  String get clipboardNotAvailable => '剪贴板不可用';

  @override
  String get noSupportedFormatFoundInClipboard => '剪贴板中未找到支持的格式';

  @override
  String get fileIsTooLarge => '文件太大';

  @override
  String get notificationRuleContainsUserName => '包含用户名';

  @override
  String get notificationRuleMaster => '主规则';

  @override
  String get notificationRuleSuppressNotices => '抑制通知';

  @override
  String get notificationRuleInviteForMe => '我邀请的';

  @override
  String get notificationRuleMemberEvent => '成员事件';

  @override
  String get notificationRuleIsUserMention => '用户提及';

  @override
  String get notificationRuleContainsDisplayName => '包含显示名';

  @override
  String get notificationRuleIsRoomMention => '房间提及';

  @override
  String get notificationRuleRoomnotif => '房间通知';

  @override
  String get notificationRuleTombstone => '墓碑';

  @override
  String get notificationRuleReaction => '反应';

  @override
  String get notificationRuleRoomServerAcl => '房间服务器 ACL';

  @override
  String get notificationRuleSuppressEdits => '抑制编辑';

  @override
  String get notificationRuleCall => '电话';

  @override
  String get notificationRuleEncryptedRoomOneToOne => '加密房间（一对一）';

  @override
  String get notificationRuleRoomOneToOne => '房间（一对一）';

  @override
  String get notificationRuleMessage => '消息';

  @override
  String get notificationRuleEncrypted => '加密';

  @override
  String get notificationRuleServerAcl => '服务器 ACL';

  @override
  String get notificationRuleJitsi => 'Jitsi';

  @override
  String get notificationRuleContainsUserNameDescription => '用户名包含在内容中';

  @override
  String get notificationRuleMasterDescription => '主通知';

  @override
  String get notificationRuleSuppressNoticesDescription => '抑制通知';

  @override
  String get notificationRuleInviteForMeDescription => '我邀请的';

  @override
  String get notificationRuleMemberEventDescription => '成员事件';

  @override
  String get notificationRuleIsUserMentionDescription => '用户提及';

  @override
  String get notificationRuleContainsDisplayNameDescription => '包含显示名';

  @override
  String get notificationRuleIsRoomMentionDescription => '房间提及';

  @override
  String get notificationRuleRoomnotifDescription => '房间通知';

  @override
  String get notificationRuleTombstoneDescription => '墓碑';

  @override
  String get notificationRuleReactionDescription => '反应';

  @override
  String get notificationRuleRoomServerAclDescription => '房间服务器 ACL';

  @override
  String get notificationRuleSuppressEditsDescription => '抑制编辑';

  @override
  String get notificationRuleCallDescription => '电话';

  @override
  String get notificationRuleEncryptedRoomOneToOneDescription => '加密房间（一对一）';

  @override
  String get notificationRuleRoomOneToOneDescription => '房间（一对一）';

  @override
  String get notificationRuleMessageDescription => '消息';

  @override
  String get notificationRuleEncryptedDescription => '加密';

  @override
  String get notificationRuleServerAclDescription => '服务器 ACL';

  @override
  String get notificationRuleJitsiDescription => 'Jitsi';

  @override
  String unknownPushRule(Object ruleId) {
    return '自定义推送规则 $ruleId';
  }

  @override
  String get contentNotificationSettings => '内容通知设置';

  @override
  String get generalNotificationSettings => '一般通知设置';

  @override
  String get roomNotificationSettings => '房间通知设置';

  @override
  String get userSpecificNotificationSettings => '用户特定通知设置';

  @override
  String get otherNotificationSettings => '其他通知设置';

  @override
  String deletePushRuleTitle(Object ruleName) {
    return '删除推送规则 $ruleName？';
  }

  @override
  String deletePushRuleDescription(Object ruleName) {
    return '确定要删除推送规则 $ruleName 吗？此操作无法撤销。';
  }

  @override
  String get pusherDevices => '推送设备';

  @override
  String get syncNow => '立即同步';

  @override
  String get startAppUpPleaseWait => '启动中，请等待...';

  @override
  String get retry => '重试';

  @override
  String get reportIssue => '报告问题';

  @override
  String get closeApp => '关闭应用';

  @override
  String get creatingRoomPleaseWait => '创建房间，正在等待...';

  @override
  String get creatingSpacePleaseWait => '创建空间，正在等待...';

  @override
  String get joiningRoomPleaseWait => '加入房间，正在等待...';

  @override
  String get leavingRoomPleaseWait => '离开房间，正在等待...';

  @override
  String get deletingRoomPleaseWait => '删除房间，正在等待...';

  @override
  String get loadingArchivePleaseWait => '加载归档，正在等待...';

  @override
  String get clearingArchivePleaseWait => '清除归档，正在等待...';

  @override
  String get pleaseSelectAChatRoom => '请选择一个聊天房间';

  @override
  String get archiveIsEmpty => '归档中没有聊天记录。当您离开聊天时，您可以在这里找到它。';

  @override
  String audioMessageSendFromUser(String user) {
    return '音频消息来自 $user';
  }

  @override
  String get startRecordingVoiceMessage => '开始录音';

  @override
  String get endRecordingVoiceMessage => '结束录音';

  @override
  String get exportFileAs => '导出文件为...';

  @override
  String fileExported(String path) {
    return '文件已导出到 $path';
  }

  @override
  String get directoryDoesNotExist => '目录不存在或无法访问。';

  @override
  String get thread => '线程';
}

/// The translations for Chinese, as used in Taiwan, using the Han script (`zh_Hant_TW`).
class AppLocalizationsZhHantTw extends AppLocalizationsZh {
  AppLocalizationsZhHantTw() : super('zh_Hant_TW');

  @override
  String get alwaysUse24HourFormat => 'false';

  @override
  String get repeatPassword => '重複密碼';

  @override
  String get notAnImage => '不是圖片檔案';

  @override
  String get remove => '刪除';

  @override
  String get importNow => '立即匯入';

  @override
  String get importEmojis => '匯入 Emoji';

  @override
  String get importFromZipFile => '從 .zip 檔案匯入';

  @override
  String get exportEmotePack => '匯出 Emote 包為 .zip';

  @override
  String get replace => '替換';

  @override
  String get about => '關於';

  @override
  String get accept => '接受';

  @override
  String acceptedTheInvitation(String username) {
    return '👍 $username 已接受邀請';
  }

  @override
  String get account => '賬戶';

  @override
  String activatedEndToEndEncryption(String username) {
    return '🔐 $username 已啟用端到端加密';
  }

  @override
  String get addEmail => '新增郵箱';

  @override
  String get confirmMatrixId => '請確認您的 Matrix ID 以刪除賬戶。';

  @override
  String supposedMxid(String mxid) {
    return '這應該是 $mxid';
  }

  @override
  String get addChatDescription => '新增聊天描述...';

  @override
  String get addToSpace => '新增到空間';

  @override
  String get admin => '管理員';

  @override
  String get alias => '別名';

  @override
  String get all => '所有';

  @override
  String get allChats => '所有聊天';

  @override
  String get commandHint_googly => '傳送一些 Googly 眼睛';

  @override
  String get commandHint_cuddle => '傳送貼貼';

  @override
  String get commandHint_hug => '傳送擁抱';

  @override
  String googlyEyesContent(String senderName) {
    return '$senderName 傳送了一些 Googly 眼睛';
  }

  @override
  String cuddleContent(String senderName) {
    return '$senderName 貼貼了你';
  }

  @override
  String hugContent(String senderName) {
    return '$senderName 擁抱了你';
  }

  @override
  String answeredTheCall(String senderName) {
    return '$senderName 接聽了電話';
  }

  @override
  String get anyoneCanJoin => '任何人都可以加入';

  @override
  String get appLock => '應用程式鎖';

  @override
  String get appLockDescription => '當應用程式未在使用時，使用 PIN 碼鎖定應用程式';

  @override
  String get archive => '歸檔';

  @override
  String get areGuestsAllowedToJoin => '訪客使用者是否允許加入';

  @override
  String get areYouSure => '確定嗎？';

  @override
  String get areYouSureYouWantToLogout => '確定要登出嗎？';

  @override
  String get askSSSSSign => '為了能夠簽署其他使用者，您需要輸入您的安全儲存密碼或恢復金鑰。';

  @override
  String askVerificationRequest(String username) {
    return '是否接受 $username 的驗證請求？';
  }

  @override
  String get autoplayImages => '自動播放動畫貼紙和 Emoji';

  @override
  String badServerLoginTypesException(
    String serverVersions,
    String supportedVersions,
  ) {
    return '伺服器支援的登入型別為：\n$serverVersions\n但此應用程式僅支援：\n$supportedVersions';
  }

  @override
  String get sendTypingNotifications => '傳送輸入通知';

  @override
  String get swipeRightToLeftToReply => '向右滑動以回覆';

  @override
  String get sendOnEnter => '按 Enter 鍵傳送';

  @override
  String badServerVersionsException(
    String serverVersions,
    String supportedVersions,
  ) {
    return '伺服器支援的 Spec 版本為：\n$serverVersions\n但此應用程式僅支援：\n$supportedVersions';
  }

  @override
  String countChatsAndCountParticipants(String chats, Object participants) {
    return '$chats 個聊天和 $participants 個參與者';
  }

  @override
  String get noMoreChatsFound => '沒有更多聊天了...';

  @override
  String get noChatsFoundHere => '這裡沒有聊天。使用下面的按鈕開始與某人聊天。 ⤵️';

  @override
  String get joinedChats => '加入的聊天';

  @override
  String get unread => '未讀';

  @override
  String get space => '空間';

  @override
  String get spaces => '空間';

  @override
  String get banFromChat => '從聊天中封禁';

  @override
  String get banned => '已封禁';

  @override
  String bannedUser(String username, String targetName) {
    return '$username 已封禁 $targetName';
  }

  @override
  String get blockDevice => '封禁裝置';

  @override
  String get blocked => '已封禁';

  @override
  String get botMessages => '機器人訊息';

  @override
  String get cancel => '取消';

  @override
  String cantOpenUri(String uri) {
    return '無法開啟 URI $uri';
  }

  @override
  String get changeDeviceName => '更改裝置名稱';

  @override
  String changedTheChatAvatar(String username) {
    return '$username 已更改聊天頭像';
  }

  @override
  String changedTheChatDescriptionTo(String username, String description) {
    return '$username 已將聊天描述更改為：\'$description\'';
  }

  @override
  String changedTheChatNameTo(String username, String chatname) {
    return '$username 已將聊天名稱更改為：\'$chatname\'';
  }

  @override
  String changedTheChatPermissions(String username) {
    return '$username 已更改聊天許可權';
  }

  @override
  String changedTheDisplaynameTo(String username, String displayname) {
    return '$username 已將顯示名稱更改為：\'$displayname\'';
  }

  @override
  String changedTheGuestAccessRules(String username) {
    return '$username 已更改訪客訪問規則';
  }

  @override
  String changedTheGuestAccessRulesTo(String username, String rules) {
    return '$username 已將訪客訪問規則更改為：$rules';
  }

  @override
  String changedTheHistoryVisibility(String username) {
    return '$username 已更改歷史可見性';
  }

  @override
  String changedTheHistoryVisibilityTo(String username, String rules) {
    return '$username 已將歷史可見性更改為：$rules';
  }

  @override
  String changedTheJoinRules(String username) {
    return '$username 已更改加入規則';
  }

  @override
  String changedTheJoinRulesTo(String username, String joinRules) {
    return '$username 已將加入規則更改為：$joinRules';
  }

  @override
  String changedTheProfileAvatar(String username) {
    return '$username 已更改頭像';
  }

  @override
  String changedTheRoomAliases(String username) {
    return '$username 已更改房間別名';
  }

  @override
  String changedTheRoomInvitationLink(String username) {
    return '$username 已更改邀請連結';
  }

  @override
  String get changePassword => '更改密碼';

  @override
  String get changeTheHomeserver => '更改主伺服器';

  @override
  String get changeTheme => '更改樣式';

  @override
  String get changeTheNameOfTheGroup => '更改組名稱';

  @override
  String get changeYourAvatar => '更改您的頭像';

  @override
  String get channelCorruptedDecryptError => '加密已損壞';

  @override
  String get chat => '聊天';

  @override
  String get yourChatBackupHasBeenSetUp => '聊天備份已設定';

  @override
  String get chatBackup => '聊天備份';

  @override
  String get chatBackupDescription => '您的舊訊息已使用恢復金鑰進行加密。請確保不要丟失它。';

  @override
  String get chatDetails => '聊天詳情';

  @override
  String get chatHasBeenAddedToThisSpace => '聊天已新增到此空間';

  @override
  String get chats => '聊天';

  @override
  String get chooseAStrongPassword => '請選擇一個強密碼';

  @override
  String get clearArchive => '清除存檔';

  @override
  String get close => '關閉';

  @override
  String get commandHint_markasdm => '將給定的 Matrix ID 標記為直接訊息房間';

  @override
  String get commandHint_markasgroup => '標記為群組';

  @override
  String get commandHint_ban => '從該房間封禁給定使用者';

  @override
  String get commandHint_clearcache => '清除快取';

  @override
  String get commandHint_create => '建立一個空的群組聊天\n使用 --no-encryption 停用加密';

  @override
  String get commandHint_discardsession => '丟棄會話';

  @override
  String get commandHint_dm => '開始直接聊天\n使用 --no-encryption 停用加密';

  @override
  String get commandHint_html => '傳送 HTML 格式化文字';

  @override
  String get commandHint_invite => '邀請特定使用者到此房間';

  @override
  String get commandHint_join => '加入特定房間';

  @override
  String get commandHint_kick => '從該房間移除特定使用者';

  @override
  String get commandHint_leave => '退出該房間';

  @override
  String get commandHint_me => '描述您自己';

  @override
  String get commandHint_myroomavatar => '設定該房間中您的頭像 (使用 mxc-uri)';

  @override
  String get commandHint_myroomnick => '設定該房間中您的顯示名稱';

  @override
  String get commandHint_op => '將特定使用者的許可權等級設定為 (預設: 50)';

  @override
  String get commandHint_plain => '傳送未格式化的文字';

  @override
  String get commandHint_react => '作為回應傳送';

  @override
  String get commandHint_send => '傳送文字';

  @override
  String get commandHint_unban => '從該房間解封特定使用者';

  @override
  String get commandInvalid => '命令無效';

  @override
  String commandMissing(String command) {
    return '$command 不是命令。';
  }

  @override
  String get compareEmojiMatch => '請對比表情符號';

  @override
  String get compareNumbersMatch => '請對比數字';

  @override
  String get configureChat => '配置聊天';

  @override
  String get confirm => '確認';

  @override
  String get connect => '連線';

  @override
  String get contactHasBeenInvitedToTheGroup => '聯絡人已邀請至群組';

  @override
  String get containsDisplayName => '包含顯示名稱';

  @override
  String get containsUserName => '包含使用者名稱';

  @override
  String get contentHasBeenReported => '內容已報告至伺服器管理員';

  @override
  String get copiedToClipboard => '已複製到剪貼簿';

  @override
  String get copy => '複製';

  @override
  String get copyToClipboard => '複製到剪貼簿';

  @override
  String couldNotDecryptMessage(String error) {
    return '無法解密訊息: $error';
  }

  @override
  String countParticipants(int count) {
    return '$count 個參與者';
  }

  @override
  String get create => '建立';

  @override
  String createdTheChat(String username) {
    return '💬 $username 建立了聊天';
  }

  @override
  String get createGroup => '建立群組';

  @override
  String get createNewSpace => '新空間';

  @override
  String get currentlyActive => '當前活躍';

  @override
  String get darkTheme => '暗黑';

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
  String get deactivateAccountWarning => '這將停用您的使用者賬戶。這不能撤銷！您確定嗎？';

  @override
  String get defaultPermissionLevel => '新使用者的預設許可權等級';

  @override
  String get delete => '刪除';

  @override
  String get deleteAccount => '刪除賬戶';

  @override
  String get deleteMessage => '刪除訊息';

  @override
  String get device => '裝置';

  @override
  String get deviceId => '裝置 ID';

  @override
  String get devices => '裝置';

  @override
  String get directChats => '直接聊天';

  @override
  String get allRooms => '所有群組聊天';

  @override
  String get displaynameHasBeenChanged => '顯示名稱已更改';

  @override
  String get downloadFile => '下載檔案';

  @override
  String get edit => '編輯';

  @override
  String get editBlockedServers => '編輯封禁的伺服器';

  @override
  String get chatPermissions => '聊天許可權';

  @override
  String get editDisplayname => '編輯顯示名稱';

  @override
  String get editRoomAliases => '編輯房間別名';

  @override
  String get editRoomAvatar => '編輯房間頭像';

  @override
  String get emoteExists => '表情符號已存在！';

  @override
  String get emoteInvalid => '表情符號短碼無效！';

  @override
  String get emoteKeyboardNoRecents => '最近使用的表情符號將出現在這裡...';

  @override
  String get emotePacks => '房間的表情符號包';

  @override
  String get emoteSettings => '表情符號設定';

  @override
  String get globalChatId => '全域性聊天 ID';

  @override
  String get accessAndVisibility => '訪問和可見性';

  @override
  String get accessAndVisibilityDescription => '誰可以加入此聊天，以及聊天如何被發現。';

  @override
  String get calls => '電話';

  @override
  String get customEmojisAndStickers => '自定義表情符號和貼紙';

  @override
  String get customEmojisAndStickersBody => '新增或分享自定義表情符號或貼紙，可在任何聊天中使用。';

  @override
  String get emoteShortcode => '表情符號短碼';

  @override
  String get emoteWarnNeedToPick => '您需要選擇一個表情符號短碼和一張圖片！';

  @override
  String get emptyChat => '空聊天';

  @override
  String get enableEmotesGlobally => '全域性啟用表情符號包';

  @override
  String get enableEncryption => '啟用加密';

  @override
  String get enableEncryptionWarning => '您將無法再停用加密，確定嗎？';

  @override
  String get encrypted => '已加密';

  @override
  String get encryption => '加密';

  @override
  String get encryptionNotEnabled => '加密未啟用';

  @override
  String endedTheCall(String senderName) {
    return '$senderName 已結束通話';
  }

  @override
  String get enterAnEmailAddress => '輸入電子郵件地址';

  @override
  String get homeserver => 'Homeserver';

  @override
  String get enterYourHomeserver => '輸入您的 Homeserver';

  @override
  String errorObtainingLocation(String error) {
    return '獲取位置錯誤：$error';
  }

  @override
  String get everythingReady => '一切就緒！';

  @override
  String get extremeOffensive => '極度冒犯';

  @override
  String get fileName => '檔名';

  @override
  String get nebuchadnezzar => '尼布甲尼撒';

  @override
  String get fontSize => '字型大小';

  @override
  String get forward => '轉發';

  @override
  String get fromJoining => 'From joining';

  @override
  String get fromTheInvitation => '來自邀請';

  @override
  String get goToTheNewRoom => '前往新房間';

  @override
  String get group => '群組';

  @override
  String get chatDescription => '聊天描述';

  @override
  String get chatDescriptionHasBeenChanged => '聊天描述已更改';

  @override
  String get groupIsPublic => '群組是公開的';

  @override
  String get groups => '群組';

  @override
  String groupWith(String displayname) {
    return '群組與 $displayname';
  }

  @override
  String get guestsAreForbidden => '禁止訪客';

  @override
  String get guestsCanJoin => '訪客可加入';

  @override
  String hasWithdrawnTheInvitationFor(String username, String targetName) {
    return '$username 已撤回對 $targetName 的邀請';
  }

  @override
  String get help => '幫助';

  @override
  String get hideRedactedEvents => '隱藏已編輯事件';

  @override
  String get hideRedactedMessages => '隱藏已編輯訊息';

  @override
  String get hideRedactedMessagesBody => '如果有人編輯了訊息，此訊息將不再在聊天中可見。';

  @override
  String get hideInvalidOrUnknownMessageFormats => '隱藏無效或未知訊息格式';

  @override
  String get howOffensiveIsThisContent => '此內容有多冒犯？';

  @override
  String get id => 'ID';

  @override
  String get identity => '身份';

  @override
  String get block => '封禁';

  @override
  String get blockedUsers => '封禁的使用者';

  @override
  String get blockListDescription =>
      '您可以封禁干擾您的使用者。您將無法從個人封禁列表中的使用者接收任何訊息或房間邀請。';

  @override
  String blockUsername(String username) {
    return '忽略 $username';
  }

  @override
  String get iHaveClickedOnLink => '我已點選連結';

  @override
  String get incorrectPassphraseOrKey => '錯誤的密碼或恢復金鑰';

  @override
  String get inoffensive => '不冒犯';

  @override
  String get inviteContact => '邀請聯絡人';

  @override
  String inviteContactToGroupQuestion(String contact, String groupName) {
    return '您是否要將 $contact 邀請到聊天 \"$groupName\" 中？';
  }

  @override
  String get noChatDescriptionYet => '暫無聊天描述';

  @override
  String get tryAgain => '重試';

  @override
  String get invalidServerName => '無效的伺服器名稱';

  @override
  String get invited => '已邀請';

  @override
  String get redactMessageDescription =>
      'The message will be redacted for all participants in this conversation. This cannot be undone.';

  @override
  String get optionalRedactReason => '(可選) 編輯此訊息的原因...';

  @override
  String invitedUser(String username, String targetName) {
    return '📩 $username 邀請了 $targetName';
  }

  @override
  String get invitedUsersOnly => '僅邀請的使用者';

  @override
  String get inviteForMe => '我邀請的';

  @override
  String inviteText(String username, String link) {
    return '$username 邀請您加入尼布甲尼撒。\n1. 訪問 https://snapcraft.io/nebuchadnezzar 並安裝應用程式\n2. 註冊或登入\n3. 開啟邀請連結：\n$link';
  }

  @override
  String get isTyping => '正在輸入...';

  @override
  String joinedTheChat(String username) {
    return '👋 $username 加入了聊天';
  }

  @override
  String get joinRoom => '加入房間';

  @override
  String kicked(String username, String targetName) {
    return '👞 $username 踢掉了 $targetName';
  }

  @override
  String kickedAndBanned(String username, String targetName) {
    return '🙅 $username 踢掉並封禁了 $targetName';
  }

  @override
  String get kickFromChat => '從聊天中踢掉';

  @override
  String lastActiveAgo(String localizedTimeShort) {
    return '最後活躍時間：$localizedTimeShort';
  }

  @override
  String get leave => '退出';

  @override
  String get leftTheChat => '退出聊天';

  @override
  String get license => '許可證';

  @override
  String get lightTheme => '亮色';

  @override
  String loadCountMoreParticipants(int count) {
    return '載入 $count 個參與者';
  }

  @override
  String get dehydrate => '匯出會話並清除裝置';

  @override
  String get dehydrateWarning => '此操作無法撤銷。請確保安全儲存備份檔案。';

  @override
  String get dehydrateTor => 'TOR 使用者：匯出會話';

  @override
  String get dehydrateTorLong => '對於 TOR 使用者，建議在關閉視窗之前匯出會話。';

  @override
  String get hydrateTor => 'TOR 使用者：匯入會話';

  @override
  String get hydrateTorLong => '是否上次在 TOR 上匯出會話？快速匯入並繼續聊天。';

  @override
  String get hydrate => '從備份檔案恢復';

  @override
  String get loadingPleaseWait => '載入中... 請稍後。';

  @override
  String get loadMore => '載入更多...';

  @override
  String get locationDisabledNotice => '位置服務已停用。請啟用它們才能分享您的位置。';

  @override
  String get locationPermissionDeniedNotice => '位置許可權被拒絕。請授予它們才能分享您的位置。';

  @override
  String get login => '登入';

  @override
  String logInTo(String homeserver) {
    return '登入到 $homeserver';
  }

  @override
  String get logout => '退出';

  @override
  String get memberChanges => '成員變更';

  @override
  String get mention => '提及';

  @override
  String get messages => '訊息';

  @override
  String get messagesStyle => '訊息:';

  @override
  String get moderator => '管理員';

  @override
  String get muteChat => '靜音聊天';

  @override
  String get needPantalaimonWarning => '請注意，您需要 Pantalaimon 才能使用端到端加密。';

  @override
  String get newChat => '新聊天';

  @override
  String get newMessageInNebuchadnezzar => '💬 在尼布甲尼撒中開始新聊天';

  @override
  String get newVerificationRequest => '新的驗證請求！';

  @override
  String get next => '下一個';

  @override
  String get no => '否';

  @override
  String get noConnectionToTheServer => '沒有連線到伺服器';

  @override
  String get noEmotesFound => '沒有找到表情符號。 😕';

  @override
  String get noEncryptionForPublicRooms => '您只能在房間不再可公開訪問時啟用端到端加密。';

  @override
  String get noGoogleServicesWarning =>
      'Firebase Cloud Messaging 似乎在您的裝置上不可用。為了仍然接收推送通知，我們建議安裝 ntfy。使用 ntfy 或其他 Unified Push 提供程式，您可以以資料安全的方式接收推送通知。您可以從 PlayStore 或 F-Droid 下載 ntfy。';

  @override
  String noMatrixServer(String server1, String server2) {
    return '$server1 不是 Matrix 伺服器，使用 $server2 代替？';
  }

  @override
  String get shareInviteLink => '分享邀請連結';

  @override
  String get scanQrCode => '掃描二維碼';

  @override
  String get none => '無';

  @override
  String get noPasswordRecoveryDescription => '您還沒有新增恢復密碼的方式。';

  @override
  String get noPermission => '沒有許可權';

  @override
  String get noRoomsFound => '沒有找到房間…';

  @override
  String get notifications => '通知';

  @override
  String get notificationsEnabledForThisAccount => '通知已為此賬號啟用';

  @override
  String numUsersTyping(int count) {
    return '$count 個使用者正在輸入...';
  }

  @override
  String get obtainingLocation => '正在獲取位置...';

  @override
  String get offensive => '冒犯';

  @override
  String get offline => '離線';

  @override
  String get ok => '好的';

  @override
  String get online => '線上';

  @override
  String get onlineKeyBackupEnabled => '已啟用線上金鑰備份';

  @override
  String get oopsPushError => '哎呀！很遺憾，設定推送通知時出錯。';

  @override
  String get oopsSomethingWentWrong => '哎呀，發生了一些錯誤。';

  @override
  String get openAppToReadMessages => '開啟應用讀取訊息';

  @override
  String get openCamera => '開啟相機';

  @override
  String get openVideoCamera => '開啟相機錄製影片';

  @override
  String get oneClientLoggedOut => '您的其中一個客戶端已登出';

  @override
  String get addAccount => '新增賬號';

  @override
  String get editBundlesForAccount => '編輯此賬號的捆綁包';

  @override
  String get addToBundle => '新增到捆綁包';

  @override
  String get removeFromBundle => '從此捆綁包中移除';

  @override
  String get bundleName => '捆綁包名稱';

  @override
  String get enableMultiAccounts => '(BETA) 啟用此裝置上的多賬號';

  @override
  String get openInMaps => '在地圖中開啟';

  @override
  String get link => '連結';

  @override
  String get serverRequiresEmail => '此伺服器註冊時需要驗證您的電子郵件地址。';

  @override
  String get or => '或';

  @override
  String get participant => '參與人';

  @override
  String get passphraseOrKey => '恢復密碼或恢復金鑰';

  @override
  String get password => '密碼';

  @override
  String get passwordForgotten => '忘記密碼';

  @override
  String get passwordHasBeenChanged => '密碼已更改';

  @override
  String get hideMemberChangesInPublicChats => '隱藏公共聊天中的成員變更';

  @override
  String get hideMemberChangesInPublicChatsBody =>
      '在公共聊天中不顯示有人加入或離開的變更，以提高可讀性。';

  @override
  String get overview => '概覽';

  @override
  String get notifyMeFor => '通知我';

  @override
  String get passwordRecoverySettings => '密碼恢復設定';

  @override
  String get passwordRecovery => '密碼恢復';

  @override
  String get people => '參與人';

  @override
  String get pickImage => '選擇圖片';

  @override
  String get pin => 'Pin';

  @override
  String play(String fileName) {
    return '播放 $fileName';
  }

  @override
  String get pleaseChoose => '請選擇';

  @override
  String get pleaseChooseAPasscode => '請選擇一個恢復密碼';

  @override
  String get pleaseClickOnLink => '請點選電子郵件中的連結，然後繼續。';

  @override
  String get pleaseEnter4Digits => '請輸入4位數字，或留空停用應用程式鎖。';

  @override
  String get pleaseEnterRecoveryKey => '請輸入恢復金鑰:';

  @override
  String get pleaseEnterYourPassword => '請輸入您的密碼';

  @override
  String get pleaseEnterYourPin => '請輸入您的 Pin';

  @override
  String get pleaseEnterYourUsername => '請輸入您的使用者名稱';

  @override
  String get pleaseFollowInstructionsOnWeb => '請按照網站上的說明操作，然後點選下一步。';

  @override
  String get privacy => '隱私';

  @override
  String get publicRooms => '公共房間';

  @override
  String get pushRules => '推送規則';

  @override
  String get reason => '原因';

  @override
  String get recording => '錄音';

  @override
  String redactedBy(String username) {
    return '由 $username 編輯';
  }

  @override
  String get directChat => '直接聊天';

  @override
  String redactedByBecause(String username, String reason) {
    return '由 $username 編輯，原因： \"$reason\"';
  }

  @override
  String redactedAnEvent(String username) {
    return '$username 編輯了事件';
  }

  @override
  String get redactMessage => '編輯訊息';

  @override
  String get register => '註冊';

  @override
  String get reject => '拒絕';

  @override
  String rejectedTheInvitation(String username) {
    return '$username 拒絕了邀請';
  }

  @override
  String get rejoin => '重新加入';

  @override
  String get removeAllOtherDevices => '刪除所有其他裝置';

  @override
  String removedBy(String username) {
    return '由 $username 刪除';
  }

  @override
  String get removeDevice => '刪除裝置';

  @override
  String get unbanFromChat => '從聊天中解封';

  @override
  String get removeYourAvatar => '刪除您的頭像';

  @override
  String get replaceRoomWithNewerVersion => '用更新版本的房間替換';

  @override
  String get reply => '回覆';

  @override
  String get reportMessage => '報告訊息';

  @override
  String get requestPermission => '請求許可權';

  @override
  String get roomHasBeenUpgraded => '房間已升級';

  @override
  String get roomVersion => '房間版本';

  @override
  String get saveFile => '儲存檔案';

  @override
  String get search => '搜尋';

  @override
  String get security => '安全';

  @override
  String get recoveryKey => '恢復金鑰';

  @override
  String get recoveryKeyLost => '恢復金鑰丟失?';

  @override
  String seenByUser(String username) {
    return '由 $username 檢視';
  }

  @override
  String get send => '傳送';

  @override
  String get sendAMessage => '傳送訊息';

  @override
  String get sendAsText => '以文字傳送';

  @override
  String get sendAudio => '傳送音訊';

  @override
  String get sendFile => '傳送檔案';

  @override
  String get sendImage => '傳送圖片';

  @override
  String get sendMessages => '傳送訊息';

  @override
  String get sendOriginal => '傳送原始訊息';

  @override
  String get sendSticker => '傳送貼紙';

  @override
  String get sendVideo => '傳送影片';

  @override
  String sentAFile(String username) {
    return '📁 $username 傳送了一個檔案';
  }

  @override
  String sentAnAudio(String username) {
    return '🎤 $username 傳送了一個音訊';
  }

  @override
  String sentAPicture(String username) {
    return '🖼️ $username 傳送了一張圖片';
  }

  @override
  String sentASticker(String username) {
    return '😊 $username 傳送了一個貼紙';
  }

  @override
  String sentAVideo(String username) {
    return '🎥 $username 傳送了一個影片';
  }

  @override
  String sentCallInformations(String senderName) {
    return '$senderName 傳送了通話資訊';
  }

  @override
  String get separateChatTypes => '將直接聊天和群組分開';

  @override
  String get setAsCanonicalAlias => '設定為主別名';

  @override
  String get setCustomEmotes => '設定自定義表情';

  @override
  String get setChatDescription => '設定聊天描述';

  @override
  String get setInvitationLink => '設定邀請連結';

  @override
  String get setPermissionsLevel => '設定許可權級別';

  @override
  String get setStatus => '設定狀態';

  @override
  String get settings => '設定';

  @override
  String get share => '分享';

  @override
  String sharedTheLocation(String username) {
    return '$username 分享了他的位置';
  }

  @override
  String get shareLocation => '分享位置';

  @override
  String get showPassword => '顯示密碼';

  @override
  String get presenceStyle => 'Presence:';

  @override
  String get presencesToggle => '顯示其他使用者的狀態訊息';

  @override
  String get singlesignon => '單點登入';

  @override
  String get skip => '跳過';

  @override
  String get sourceCode => '原始碼';

  @override
  String get spaceIsPublic => '空間是公開的';

  @override
  String get spaceName => '空間名稱';

  @override
  String startedACall(String senderName) {
    return '$senderName 發起通話';
  }

  @override
  String get startFirstChat => '開始你的第一個聊天';

  @override
  String get status => '狀態';

  @override
  String get statusExampleMessage => '你好嗎？';

  @override
  String get submit => '提交';

  @override
  String get synchronizingPleaseWait => '同步中... 請稍後';

  @override
  String get systemTheme => '系統';

  @override
  String get theyDontMatch => '他們不匹配';

  @override
  String get theyMatch => '他們匹配';

  @override
  String get title => '尼布甲尼撒';

  @override
  String get toggleFavorite => '切換收藏';

  @override
  String get toggleMuted => '切換靜音';

  @override
  String get toggleUnread => '切換未讀/已讀';

  @override
  String get tooManyRequestsWarning => '請求過多，請稍後重試！';

  @override
  String get transferFromAnotherDevice => '從另一個裝置傳輸';

  @override
  String get tryToSendAgain => '重新發送';

  @override
  String get unavailable => '不可用';

  @override
  String unbannedUser(String username, String targetName) {
    return '$username 已取消對 $targetName 的封禁';
  }

  @override
  String get unblockDevice => '取消封禁裝置';

  @override
  String get unknownDevice => '未知裝置';

  @override
  String get unknownEncryptionAlgorithm => '未知加密演算法';

  @override
  String unknownEvent(String type) {
    return '未知事件 \'$type\'';
  }

  @override
  String get unmuteChat => '取消靜音聊天';

  @override
  String get unpin => '取消置頂';

  @override
  String unreadChats(int unreadCount) {
    String _temp0 = intl.Intl.pluralLogic(
      unreadCount,
      locale: localeName,
      other: '$unreadCount 條未讀訊息',
      one: '1 條未讀訊息',
    );
    return '$_temp0';
  }

  @override
  String userAndOthersAreTyping(String username, int count) {
    return '$username 和 $count 個其他使用者正在輸入...';
  }

  @override
  String userAndUserAreTyping(String username, String username2) {
    return '$username 和 $username2 正在輸入...';
  }

  @override
  String userIsTyping(String username) {
    return '$username 正在輸入...';
  }

  @override
  String userLeftTheChat(String username) {
    return '🚪 $username 已退出聊天';
  }

  @override
  String get username => '使用者名稱';

  @override
  String userSentUnknownEvent(String username, String type) {
    return '$username 傳送了 $type 事件';
  }

  @override
  String get unverified => '未驗證';

  @override
  String get verified => '已驗證';

  @override
  String get verify => '驗證';

  @override
  String get verifyStart => '開始驗證';

  @override
  String get verifySuccess => '驗證成功！';

  @override
  String get verifyTitle => '驗證其他賬號';

  @override
  String get videoCall => '視訊通話';

  @override
  String get visibilityOfTheChatHistory => '聊天曆史可見性';

  @override
  String get visibleForAllParticipants => '對所有參與者可見';

  @override
  String get visibleForEveryone => '對所有人可見';

  @override
  String get voiceMessage => '語音訊息';

  @override
  String get waitingPartnerAcceptRequest => '等待對方接受請求...';

  @override
  String get waitingPartnerEmoji => '等待對方接受表情...';

  @override
  String get waitingPartnerNumbers => '等待對方接受數字...';

  @override
  String get wallpaper => '桌布:';

  @override
  String get warning => '警告！';

  @override
  String get weSentYouAnEmail => '我們已傳送您一封電子郵件';

  @override
  String get whoCanPerformWhichAction => '誰可以執行哪些操作';

  @override
  String get whoIsAllowedToJoinThisGroup => '誰可以加入此群組';

  @override
  String get whyDoYouWantToReportThis => '為什麼要報告此訊息？';

  @override
  String get wipeChatBackup => '是否要清除聊天備份以建立新的恢復金鑰？';

  @override
  String get withTheseAddressesRecoveryDescription => '使用這些地址可以恢復您的密碼。';

  @override
  String get writeAMessage => '輸入訊息...';

  @override
  String get yes => '是';

  @override
  String get you => '您';

  @override
  String get youAreNoLongerParticipatingInThisChat => '您已不再參與此聊天';

  @override
  String get youHaveBeenBannedFromThisChat => '您已被此聊天禁止';

  @override
  String get yourPublicKey => '您的公鑰';

  @override
  String get messageInfo => '訊息資訊';

  @override
  String get time => 'Time';

  @override
  String get messageType => '訊息型別';

  @override
  String get sender => 'Sender';

  @override
  String get openGallery => '開啟相簿';

  @override
  String get removeFromSpace => '從空間移除';

  @override
  String get addToSpaceDescription => '選擇一個空間將此聊天新增到其中。';

  @override
  String get start => 'Start';

  @override
  String get pleaseEnterRecoveryKeyDescription =>
      '要解鎖您舊的訊息，請輸入在之前會話中生成的恢復金鑰。您的恢復金鑰不是您的密碼。';

  @override
  String get publish => '釋出';

  @override
  String videoWithSize(String size) {
    return '影片 ($size)';
  }

  @override
  String get openChat => '開啟聊天';

  @override
  String get markAsRead => '標記為已讀';

  @override
  String get reportUser => '報告使用者';

  @override
  String get dismiss => '解散';

  @override
  String reactedWith(String sender, String reaction) {
    return '$sender 用 $reaction 作出了反應';
  }

  @override
  String get pinMessage => '固定到房間';

  @override
  String get confirmEventUnpin => '確定要永久取消固定事件嗎？';

  @override
  String get emojis => '表情符號';

  @override
  String get placeCall => '撥打電話';

  @override
  String get voiceCall => '語音通話';

  @override
  String get unsupportedAndroidVersion => '不支援的 Android 版本';

  @override
  String get unsupportedAndroidVersionLong =>
      '此功能需要更新的 Android 版本。請檢查是否有更新或 Lineage OS 支援。';

  @override
  String get videoCallsBetaWarning =>
      '請注意，視訊通話當前處於測試階段。它們可能無法按預期工作或在所有平臺上都無法正常工作。';

  @override
  String get experimentalVideoCalls => '實驗性視訊通話';

  @override
  String get emailOrUsername => '郵箱或使用者名稱';

  @override
  String get indexedDbErrorTitle => '隱私模式問題';

  @override
  String get indexedDbErrorLong =>
      '訊息儲存預設情況下在隱私模式下未啟用。\n請訪問\n - about:config\n - 設定 dom.indexedDB.privateBrowsing.enabled 為 true\n否則，尼布甲尼撒將無法執行。';

  @override
  String switchToAccount(int number) {
    return '切換到賬號 $number';
  }

  @override
  String get nextAccount => '下一個賬號';

  @override
  String get previousAccount => '上一個賬號';

  @override
  String get addWidget => '新增小部件';

  @override
  String get widgetVideo => '影片';

  @override
  String get widgetEtherpad => '文字筆記';

  @override
  String get widgetJitsi => 'Jitsi Meet';

  @override
  String get widgetCustom => '自定義';

  @override
  String get widgetName => '名稱';

  @override
  String get widgetUrlError => '這不是一個有效的 URL。';

  @override
  String get widgetNameError => '請提供顯示名稱。';

  @override
  String get errorAddingWidget => '新增小部件時出錯。';

  @override
  String get youRejectedTheInvitation => '您拒絕了邀請';

  @override
  String get youJoinedTheChat => '您加入了聊天';

  @override
  String get youAcceptedTheInvitation => '👍 您接受了邀請';

  @override
  String youBannedUser(String user) {
    return '您禁止了 $user';
  }

  @override
  String youHaveWithdrawnTheInvitationFor(String user) {
    return '您已撤回對 $user 的邀請';
  }

  @override
  String youInvitedToBy(String alias) {
    return '📩 您已透過連結邀請到:\n$alias';
  }

  @override
  String youInvitedBy(String user) {
    return '📩 $user 邀請了您';
  }

  @override
  String invitedBy(String user) {
    return '📩 邀請人 $user';
  }

  @override
  String youInvitedUser(String user) {
    return '📩 您邀請了 $user';
  }

  @override
  String youKicked(String user) {
    return '👞 您踢掉了 $user';
  }

  @override
  String youKickedAndBanned(String user) {
    return '🙅 您踢掉並禁止了 $user';
  }

  @override
  String youUnbannedUser(String user) {
    return '您已取消禁止 $user';
  }

  @override
  String hasKnocked(String user) {
    return '🚪 $user 已敲門';
  }

  @override
  String get usersMustKnock => '使用者必須敲門';

  @override
  String get noOneCanJoin => '沒有人可以加入';

  @override
  String userWouldLikeToChangeTheChat(String user) {
    return '$user 想加入聊天';
  }

  @override
  String get noPublicLinkHasBeenCreatedYet => '暫無公共連結';

  @override
  String get knock => '敲門';

  @override
  String get users => '使用者';

  @override
  String get unlockOldMessages => '解鎖舊訊息';

  @override
  String get storeInSecureStorageDescription => '將恢復金鑰儲存在該裝置的安全儲存中。';

  @override
  String get saveKeyManuallyDescription => '手動儲存此金鑰，方法是觸發系統分享對話方塊或剪貼簿。';

  @override
  String get storeInAndroidKeystore => '儲存在 Android KeyStore 中';

  @override
  String get storeInAppleKeyChain => '儲存在 Apple KeyChain 中';

  @override
  String get storeSecurlyOnThisDevice => '在該裝置上安全儲存';

  @override
  String countFiles(int count) {
    return '$count 檔案';
  }

  @override
  String get user => '使用者';

  @override
  String get custom => '自定義';

  @override
  String get foregroundServiceRunning => '當前臺服務執行時，此通知會出現。';

  @override
  String get screenSharingTitle => '螢幕分享';

  @override
  String get screenSharingDetail => '您正在 FuffyChat 中分享螢幕';

  @override
  String get callingPermissions => '呼叫許可權';

  @override
  String get callingAccount => '呼叫賬戶';

  @override
  String get callingAccountDetails => '允許尼布甲尼撒使用原生Android撥號器應用';

  @override
  String get appearOnTop => '在頂部顯示';

  @override
  String get appearOnTopDetails =>
      '允許應用在頂部顯示（如果您已經將 Fluffychat 設定為呼叫賬戶，則無需此許可權）';

  @override
  String get otherCallingPermissions => '相機和其他尼布甲尼撒許可權';

  @override
  String get whyIsThisMessageEncrypted => '為什麼此訊息不可讀？';

  @override
  String get noKeyForThisMessage =>
      '如果在您登入到此裝置上的帳戶之前傳送了郵件，則可能會發生這種情況。\n\n也可能是發件人阻止了您的裝置或網路連接出現問題。\n\n您可以在另一個會話中讀取訊息嗎？然後您可以從中傳輸訊息！轉到“設定”>“裝置”，並確保您的裝置已相互驗證。當您下次開啟房間並且兩個會話都在前臺時，金鑰將自動傳輸。\n\n是否不希望在登出或切換裝置時丟失金鑰？確保已在設定中啟用聊天室備份。';

  @override
  String get newGroup => '新群組';

  @override
  String get newSpace => '新空間';

  @override
  String get enterSpace => '進入空間';

  @override
  String get enterRoom => '進入房間';

  @override
  String get allSpaces => '所有空間';

  @override
  String numChats(int number) {
    return '$number 條聊天記錄';
  }

  @override
  String get hideUnimportantStateEvents => '隱藏不重要的狀態事件';

  @override
  String get hidePresences => '隱藏狀態列表？';

  @override
  String get doNotShowAgain => '不再顯示';

  @override
  String wasDirectChatDisplayName(String oldDisplayName) {
    return '空聊天（之前顯示為 $oldDisplayName）';
  }

  @override
  String get newSpaceDescription => '空間允許您整合您的聊天記錄並構建私有或公共社群。';

  @override
  String get encryptThisChat => '加密此聊天';

  @override
  String get disableEncryptionWarning => '出於安全考慮，您不能在已啟用加密的聊天中停用加密。';

  @override
  String get sorryThatsNotPossible => '抱歉... 這是不可能的';

  @override
  String get deviceKeys => '裝置金鑰:';

  @override
  String get reopenChat => '重新開啟聊天';

  @override
  String get noBackupWarning => '警告！如果未啟用聊天備份，您將無法訪問加密的訊息。強烈建議在登出之前先啟用聊天備份。';

  @override
  String get noOtherDevicesFound => '未找到其他裝置';

  @override
  String fileIsTooBigForServer(int max) {
    return '無法傳送！伺服器支援的附件大小上限為 $max。';
  }

  @override
  String fileHasBeenSavedAt(String path) {
    return '檔案已儲存至 $path';
  }

  @override
  String get jumpToLastReadMessage => '跳轉到最後讀取的訊息';

  @override
  String get readUpToHere => '讀取到此處';

  @override
  String get jump => '跳轉';

  @override
  String get openLinkInBrowser => '在瀏覽器中開啟連結';

  @override
  String get reportErrorDescription => '😭 哦不。出了點問題。您可以考慮將此錯誤報告給開發人員。';

  @override
  String get report => '報告';

  @override
  String get signInWithPassword => '使用密碼登入';

  @override
  String get pleaseTryAgainLaterOrChooseDifferentServer => '請稍後重試或選擇其他伺服器。';

  @override
  String signInWith(String provider) {
    return '使用 $provider 登入';
  }

  @override
  String get profileNotFound => '使用者在伺服器上未找到。可能是連線問題或使用者不存在。';

  @override
  String get setTheme => '設定主題:';

  @override
  String get setColorTheme => '設定顏色主題:';

  @override
  String get invite => 'Invite';

  @override
  String get inviteGroupChat => '📨 邀請群組聊天';

  @override
  String get invitePrivateChat => '📨 邀請私人聊天';

  @override
  String get invalidInput => '無效輸入！';

  @override
  String wrongPinEntered(int seconds) {
    return '錯誤的 PIN 碼！請在 $seconds 秒後重試...';
  }

  @override
  String get pleaseEnterANumber => '請輸入大於 0 的數字';

  @override
  String get archiveRoomDescription => '聊天將被移動到存檔。其他使用者將能夠看到您已退出聊天。';

  @override
  String get roomUpgradeDescription =>
      '聊天將被重新建立為新的房間版本。所有參與者都將被通知切換到新的聊天。您可以在 https://spec.matrix.org/latest/rooms/ 瞭解更多關於房間版本的資訊。';

  @override
  String get removeDevicesDescription => '您將從該設備註銷，無法接收訊息。';

  @override
  String get banUserDescription => '該使用者將被禁止加入聊天，直到被取消禁止。';

  @override
  String get unbanUserDescription => '使用者將能夠再次加入聊天，如果他們嘗試。';

  @override
  String get kickUserDescription => '該使用者被踢出聊天，但未被禁止。在公共聊天中，使用者可以隨時重新加入。';

  @override
  String get makeAdminDescription =>
      '一旦您將此使用者設為管理員，您可能無法撤銷此操作，因為他們將具有與您相同的許可權。';

  @override
  String get pushNotificationsNotAvailable => '推送通知不可用';

  @override
  String get learnMore => '瞭解更多';

  @override
  String get yourGlobalUserIdIs => '您的全域性使用者 ID 為: ';

  @override
  String noUsersFoundWithQuery(String query) {
    return '不幸的是，沒有使用者能夠使用 \"$query\" 進行搜尋。請檢查是否拼寫錯誤。';
  }

  @override
  String get knocking => '敲門';

  @override
  String chatCanBeDiscoveredViaSearchOnServer(String server) {
    return '聊天可以透過在 $server 上搜索來發現';
  }

  @override
  String get searchChatsRooms => '搜尋 #chats, @users...';

  @override
  String get nothingFound => '未找到...';

  @override
  String get groupName => '群組名稱';

  @override
  String get createGroupAndInviteUsers => '建立群組並邀請使用者';

  @override
  String get groupCanBeFoundViaSearch => '群組可以透過搜尋來發現';

  @override
  String get wrongRecoveryKey => '抱歉... 這似乎不是正確的恢復金鑰。';

  @override
  String get startConversation => '開始對話';

  @override
  String get commandHint_sendraw => '傳送原始 JSON';

  @override
  String get databaseMigrationTitle => '資料庫已最佳化';

  @override
  String get databaseMigrationBody => '請稍等。這可能需要一些時間。';

  @override
  String get leaveEmptyToClearStatus => '留空以清除您的狀態。';

  @override
  String get select => '選擇';

  @override
  String get searchForUsers => '搜尋 @users...';

  @override
  String get pleaseEnterYourCurrentPassword => '請輸入您當前的密碼';

  @override
  String get newPassword => '新密碼';

  @override
  String get pleaseChooseAStrongPassword => '請選擇一個強密碼';

  @override
  String get passwordsDoNotMatch => '密碼不匹配';

  @override
  String get passwordIsWrong => '您輸入的密碼錯誤';

  @override
  String get publicLink => '公共連結';

  @override
  String get publicChatAddresses => '公共聊天地址';

  @override
  String get createNewAddress => '建立新地址';

  @override
  String get joinSpace => '加入空間';

  @override
  String get publicSpaces => '公共空間';

  @override
  String get addChatOrSubSpace => '新增聊天或子空間';

  @override
  String get subspace => '子空間';

  @override
  String get decline => '拒絕';

  @override
  String get thisDevice => '此裝置:';

  @override
  String get initAppError => '初始化應用時出錯';

  @override
  String get userRole => '使用者角色';

  @override
  String minimumPowerLevel(int level) {
    return '$level 是最低許可權等級。';
  }

  @override
  String searchIn(String chat) {
    return '在聊天 \"$chat\" 中搜索...';
  }

  @override
  String get searchMore => '搜尋更多...';

  @override
  String get gallery => '相簿';

  @override
  String get files => '檔案';

  @override
  String databaseBuildErrorBody(String url, String error) {
    return '無法構建 SQlite 資料庫。應用程式目前嘗試使用舊版資料庫。請將此錯誤報告給開發人員 $url。錯誤訊息為: $error';
  }

  @override
  String sessionLostBody(String url, String error) {
    return '您的會話已丟失。請將此錯誤報告給開發人員 $url。錯誤訊息為: $error';
  }

  @override
  String restoreSessionBody(String url, String error) {
    return '應用程式現在嘗試從備份中恢復您的會話。請將此錯誤報告給開發人員 $url。錯誤訊息為: $error';
  }

  @override
  String forwardMessageTo(String roomName) {
    return '將訊息轉發到 $roomName？';
  }

  @override
  String get sendReadReceipts => '傳送已讀回執';

  @override
  String get sendTypingNotificationsDescription => '其他聊天參與者可以看到您是否正在輸入新訊息。';

  @override
  String get sendReadReceiptsDescription => '其他聊天參與者可以看到您是否已讀取訊息。';

  @override
  String get formattedMessages => '格式化訊息';

  @override
  String get formattedMessagesDescription => '使用 markdown 顯示豐富的訊息內容，例如加粗文字。';

  @override
  String get verifyOtherUser => '🔐 驗證其他使用者';

  @override
  String get verifyOtherUserDescription =>
      'If you verify another user, you can be sure that you know who you are really writing to. 💪\n\nWhen you start a verification, you and the other user will see a popup in the app. There you will then see a series of emojis or numbers that you have to compare with each other.\n\nThe best way to do this is to meet up or start a video call. 👭';

  @override
  String get verifyOtherDevice => '🔐 驗證其他裝置';

  @override
  String get verifyOtherDeviceDescription =>
      'When you verify another device, those devices can exchange keys, increasing your overall security. 💪 When you start a verification, a popup will appear in the app on both devices. There you will then see a series of emojis or numbers that you have to compare with each other. It\'s best to have both devices handy before you start the verification. 🤳';

  @override
  String acceptedKeyVerification(String sender) {
    return '$sender 已接受金鑰驗證';
  }

  @override
  String canceledKeyVerification(String sender) {
    return '$sender 已取消金鑰驗證';
  }

  @override
  String completedKeyVerification(String sender) {
    return '$sender 已完成金鑰驗證';
  }

  @override
  String isReadyForKeyVerification(String sender) {
    return '$sender 已準備好金鑰驗證';
  }

  @override
  String requestedKeyVerification(String sender) {
    return '$sender 請求金鑰驗證';
  }

  @override
  String startedKeyVerification(String sender) {
    return '$sender 已開始金鑰驗證';
  }

  @override
  String get transparent => '透明';

  @override
  String get incomingMessages => '入站訊息';

  @override
  String get stickers => '貼紙';

  @override
  String get discover => '發現';

  @override
  String get commandHint_ignore => '忽略給定的 Matrix ID';

  @override
  String get commandHint_unignore => '取消忽略給定的 Matrix ID';

  @override
  String unreadChatsInApp(String appname, String unread) {
    return '$appname: $unread 未讀聊天';
  }

  @override
  String get noDatabaseEncryption => '資料庫加密在該平臺上不支援';

  @override
  String thereAreCountUsersBlocked(Object count) {
    return '當前有 $count 個使用者被阻塞。';
  }

  @override
  String get restricted => '受限';

  @override
  String get knockRestricted => 'Knock restricted';

  @override
  String goToSpace(Object space) {
    return '前往空間: $space';
  }

  @override
  String get markAsUnread => '標記為未讀';

  @override
  String userLevel(int level) {
    return '$level - 使用者';
  }

  @override
  String moderatorLevel(int level) {
    return '$level - 主持人';
  }

  @override
  String adminLevel(int level) {
    return '$level - 管理員';
  }

  @override
  String get changeGeneralChatSettings => '更改一般聊天設定';

  @override
  String get inviteOtherUsers => '邀請其他使用者加入此聊天';

  @override
  String get changeTheChatPermissions => '更改聊天許可權';

  @override
  String get changeTheVisibilityOfChatHistory => '更改聊天曆史記錄的可見性';

  @override
  String get changeTheCanonicalRoomAlias => '更改主要公共聊天地址';

  @override
  String get sendRoomNotifications => '傳送 @room 通知';

  @override
  String get changeTheDescriptionOfTheGroup => '更改聊天描述';

  @override
  String get chatPermissionsDescription =>
      '定義在該聊天中需要哪些許可權等級才能執行某些操作。許可權等級 0、50 和 100 通常代表使用者、主持人和管理員，但任何等級都可能。';

  @override
  String updateInstalled(String version) {
    return '🎉 更新 $version 已安裝！';
  }

  @override
  String get changelog => '更新日誌';

  @override
  String get sendCanceled => '傳送已取消';

  @override
  String get loginWithMatrixId => '使用 Matrix-ID 登入';

  @override
  String get discoverHomeservers => '發現 homeserver';

  @override
  String get whatIsAHomeserver => '什麼是 homeserver？';

  @override
  String get homeserverDescription =>
      '所有您的資料都儲存在 homeserver 上，就像電子郵件提供程式一樣。您可以選擇使用哪個 homeserver，同時仍然可以與每個人通訊。更多資訊請訪問 https://matrix.org。';

  @override
  String get doesNotSeemToBeAValidHomeserver => '似乎不是相容的 homeserver。URL 錯誤？';

  @override
  String get calculatingFileSize => '計算檔案大小...';

  @override
  String get prepareSendingAttachment => '準備傳送附件...';

  @override
  String get sendingAttachment => '傳送附件...';

  @override
  String get generatingVideoThumbnail => '生成影片縮圖...';

  @override
  String get compressVideo => '壓縮影片...';

  @override
  String sendingAttachmentCountOfCount(int index, int length) {
    return '傳送附件 $index 中的 $length...';
  }

  @override
  String serverLimitReached(int seconds) {
    return '已達伺服器上限！等待 $seconds 秒...';
  }

  @override
  String get yesterday => '昨天';

  @override
  String get today => '今天';

  @override
  String get member => '成員';

  @override
  String get changePowerLevel => '更改許可權等級';

  @override
  String get canNotChangePowerLevel => '許可權等級不能低於您要更改的使用者的許可權等級。';

  @override
  String changePowerLevelForUserToValue(Object user, Object value) {
    return '將 $user 的許可權等級更改為 $value？';
  }

  @override
  String get loginInPleaseWait => '登入中，請稍後...';

  @override
  String get settingUpApplicationPleaseWait => '設定應用程式，請稍後...';

  @override
  String get checkingEncryptionPleaseWait => '檢查加密，請稍後...';

  @override
  String get settingUpEncryptionPleaseWait => '設定加密，請稍後...';

  @override
  String canonicalAliasInvalidInput(String homeServer) {
    return '無效輸入，必須匹配 #SOMETHING:$homeServer';
  }

  @override
  String canonicalAliasHelperText(String roomName, String homeServer) {
    return '示例: #\$$roomName:\$$homeServer';
  }

  @override
  String get shareKeysWithAllDevices => '分享金鑰到所有裝置';

  @override
  String get shareKeysWithCrossVerifiedDevices => '分享金鑰到已驗證裝置';

  @override
  String get shareKeysWithCrossVerifiedDevicesIfEnabled => '分享金鑰到已驗證裝置（如果已啟用）';

  @override
  String get shareKeysWithDirectlyVerifiedDevicesOnly => '分享金鑰到直接驗證裝置';

  @override
  String get joinRules => '加入規則';

  @override
  String get showTheseEventsInTheChat => '顯示這些事件在聊天中';

  @override
  String get playMedia => '播放媒體';

  @override
  String get appendToQueue => '新增到佇列';

  @override
  String appendedToQueue(String title) {
    return '已新增到佇列: $title';
  }

  @override
  String get queue => '佇列';

  @override
  String get clearQueue => '清除佇列';

  @override
  String get queueCleared => '佇列已清除';

  @override
  String get radioBrowser => '廣播瀏覽器';

  @override
  String get selectStation => '選擇電臺';

  @override
  String get noStationFound => '未找到電臺';

  @override
  String get favorites => '收藏';

  @override
  String get addToFavorites => '新增到收藏';

  @override
  String get removeFromFavorites => '從收藏中移除';

  @override
  String get favoriteAdded => '已新增到收藏';

  @override
  String get favoriteRemoved => '已從收藏中移除';

  @override
  String get notSupportedByServer => '伺服器不支援此操作';

  @override
  String get radioStation => '廣播電臺';

  @override
  String get radioStations => '廣播電臺';

  @override
  String get noRadioBrowserConnected => '未連線廣播瀏覽器';

  @override
  String appendMediaToQueueDescription(String title) {
    return '$title 已在佇列中。是否要將其新增到佇列末尾？';
  }

  @override
  String get appendMediaToQueueTitle => '新增媒體到佇列';

  @override
  String appendMediaToQueue(String title) {
    return '新增到佇列: $title';
  }

  @override
  String get playNowButton => '立即播放';

  @override
  String get appendMediaToQueueButton => '新增到佇列';

  @override
  String get clipboardNotAvailable => '剪貼簿不可用';

  @override
  String get noSupportedFormatFoundInClipboard => '剪貼簿中未找到支援的格式';

  @override
  String get fileIsTooLarge => '檔案太大';

  @override
  String get notificationRuleContainsUserName => '包含使用者名稱';

  @override
  String get notificationRuleMaster => '主規則';

  @override
  String get notificationRuleSuppressNotices => '抑制通知';

  @override
  String get notificationRuleInviteForMe => '我邀請的';

  @override
  String get notificationRuleMemberEvent => '成員事件';

  @override
  String get notificationRuleIsUserMention => '使用者提及';

  @override
  String get notificationRuleContainsDisplayName => '包含顯示名';

  @override
  String get notificationRuleIsRoomMention => '房間提及';

  @override
  String get notificationRuleRoomnotif => '房間通知';

  @override
  String get notificationRuleTombstone => '墓碑';

  @override
  String get notificationRuleReaction => '反應';

  @override
  String get notificationRuleRoomServerAcl => '房間伺服器 ACL';

  @override
  String get notificationRuleSuppressEdits => '抑制編輯';

  @override
  String get notificationRuleCall => '電話';

  @override
  String get notificationRuleEncryptedRoomOneToOne => '加密房間（一對一）';

  @override
  String get notificationRuleRoomOneToOne => '房間（一對一）';

  @override
  String get notificationRuleMessage => '訊息';

  @override
  String get notificationRuleEncrypted => '加密';

  @override
  String get notificationRuleServerAcl => '伺服器 ACL';

  @override
  String get notificationRuleJitsi => 'Jitsi';

  @override
  String get notificationRuleContainsUserNameDescription => '使用者名稱包含在內容中';

  @override
  String get notificationRuleMasterDescription => '主通知';

  @override
  String get notificationRuleSuppressNoticesDescription => '抑制通知';

  @override
  String get notificationRuleInviteForMeDescription => '我邀請的';

  @override
  String get notificationRuleMemberEventDescription => '成員事件';

  @override
  String get notificationRuleIsUserMentionDescription => '使用者提及';

  @override
  String get notificationRuleContainsDisplayNameDescription => '包含顯示名';

  @override
  String get notificationRuleIsRoomMentionDescription => '房間提及';

  @override
  String get notificationRuleRoomnotifDescription => '房間通知';

  @override
  String get notificationRuleTombstoneDescription => '墓碑';

  @override
  String get notificationRuleReactionDescription => '反應';

  @override
  String get notificationRuleRoomServerAclDescription => '房間伺服器 ACL';

  @override
  String get notificationRuleSuppressEditsDescription => '抑制編輯';

  @override
  String get notificationRuleCallDescription => '電話';

  @override
  String get notificationRuleEncryptedRoomOneToOneDescription => '加密房間（一對一）';

  @override
  String get notificationRuleRoomOneToOneDescription => '房間（一對一）';

  @override
  String get notificationRuleMessageDescription => '訊息';

  @override
  String get notificationRuleEncryptedDescription => '加密';

  @override
  String get notificationRuleServerAclDescription => '伺服器 ACL';

  @override
  String get notificationRuleJitsiDescription => 'Jitsi';

  @override
  String unknownPushRule(Object ruleId) {
    return '自定義推送規則 $ruleId';
  }

  @override
  String get contentNotificationSettings => '內容通知設定';

  @override
  String get generalNotificationSettings => '一般通知設定';

  @override
  String get roomNotificationSettings => '房間通知設定';

  @override
  String get userSpecificNotificationSettings => '使用者特定通知設定';

  @override
  String get otherNotificationSettings => '其他通知設定';

  @override
  String deletePushRuleTitle(Object ruleName) {
    return '刪除推送規則 $ruleName？';
  }

  @override
  String deletePushRuleDescription(Object ruleName) {
    return '確定要刪除推送規則 $ruleName 嗎？此操作無法撤銷。';
  }

  @override
  String get pusherDevices => '推送裝置';

  @override
  String get syncNow => '立即同步';

  @override
  String get startAppUpPleaseWait => '啟動中，請等待...';

  @override
  String get retry => '重試';

  @override
  String get reportIssue => '報告問題';

  @override
  String get closeApp => '關閉應用';

  @override
  String get creatingRoomPleaseWait => '建立房間，正在等待...';

  @override
  String get creatingSpacePleaseWait => '建立空間，正在等待...';

  @override
  String get joiningRoomPleaseWait => '加入房間，正在等待...';

  @override
  String get leavingRoomPleaseWait => '離開房間，正在等待...';

  @override
  String get deletingRoomPleaseWait => '刪除房間，正在等待...';

  @override
  String get loadingArchivePleaseWait => '載入歸檔，正在等待...';

  @override
  String get clearingArchivePleaseWait => '清除歸檔，正在等待...';

  @override
  String get pleaseSelectAChatRoom => '請選擇一個聊天房間';

  @override
  String get archiveIsEmpty => '歸檔中沒有聊天記錄。當您離開聊天時，您可以在這裡找到它。';

  @override
  String audioMessageSendFromUser(String user) {
    return '音訊訊息來自 $user';
  }

  @override
  String get startRecordingVoiceMessage => '開始錄音';

  @override
  String get endRecordingVoiceMessage => '結束錄音';

  @override
  String get exportFileAs => '匯出檔案為...';

  @override
  String fileExported(String path) {
    return '檔案已匯出到 $path';
  }

  @override
  String get directoryDoesNotExist => '目錄不存在或無法訪問。';

  @override
  String get thread => '執行緒';
}
