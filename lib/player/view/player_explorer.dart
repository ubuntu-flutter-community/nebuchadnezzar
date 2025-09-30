import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../radio/view/radio_browser.dart';
import '../../radio/view/radio_favorites_list.dart';
import 'player_queue.dart';

class PlayerExplorer extends StatefulWidget {
  const PlayerExplorer({super.key});

  @override
  State<PlayerExplorer> createState() => _PlayerExplorerState();
}

class _PlayerExplorerState extends State<PlayerExplorer>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(right: kBigPadding),
      child: Column(
        children: [
          YaruTabBar(
            tabController: _tabController,
            tabs: [
              Tab(text: l10n.queue),
              Tab(text: l10n.radioBrowser),
              Tab(text: l10n.favorites),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                PlayerQueue(),
                RadioBrowser(),
                RadioFavoritesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
