import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/raby_colors.dart';
import '../../app/theme/raby_theme.dart';

class RabyShell extends StatelessWidget {
  const RabyShell({required this.currentPath, required this.child, super.key});

  final String currentPath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
          child: Container(
            height: 76,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6E1),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: RabyColors.stickerBorder, width: 4),
            ),
            child: Row(
              children: [
                for (var index = 0; index < _tabs.length; index++)
                  Expanded(
                    child: _RabyTabButton(
                      tab: _tabs[index],
                      selected: index == _selectedIndex,
                      onTap: () => context.go(_tabs[index].route),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int get _selectedIndex {
    if (currentPath == AppRoutes.weight ||
        currentPath.startsWith('${AppRoutes.weight}/')) {
      return 1;
    }
    if (currentPath == AppRoutes.me ||
        currentPath.startsWith('${AppRoutes.me}/')) {
      return 2;
    }
    return 0;
  }
}

class _RabyTabButton extends StatelessWidget {
  const _RabyTabButton({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _RabyTabSpec tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? RabyColors.primaryDeep : RabyColors.secondary;
    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      child: Tooltip(
        message: tab.label,
        child: InkWell(
          key: ValueKey('raby-tab-${tab.label}'),
          borderRadius: BorderRadius.circular(34),
          onTap: onTap,
          child: Center(
            child: Container(
              height: 64,
              constraints: BoxConstraints(
                minWidth: selected ? 122 : 56,
                maxWidth: 128,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFFFEDC5) : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    selected ? tab.activeAsset : tab.asset,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    tab.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: foreground,
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      height: 0.95,
                      fontFamily: rabyTextFontFamily,
                      fontFamilyFallback: const [
                        'RabyChillRoundM',
                        'Microsoft YaHei UI',
                        'PingFang SC',
                        'Noto Sans CJK SC',
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RabyTabSpec {
  const _RabyTabSpec({
    required this.label,
    required this.route,
    required this.asset,
    required this.activeAsset,
  });

  final String label;
  final String route;
  final String asset;
  final String activeAsset;
}

const _tabs = [
  _RabyTabSpec(
    label: '首页',
    route: AppRoutes.records,
    asset: 'assets/images/icons/home/icon_tab_home.png',
    activeAsset: 'assets/images/icons/home/icon_tab_home_active.png',
  ),
  _RabyTabSpec(
    label: '体重',
    route: AppRoutes.weight,
    asset: 'assets/images/icons/home/icon_tab_weight.png',
    activeAsset: 'assets/images/icons/home/icon_tab_weight_active.png',
  ),
  _RabyTabSpec(
    label: '我的',
    route: AppRoutes.me,
    asset: 'assets/images/icons/home/icon_tab_profile.png',
    activeAsset: 'assets/images/icons/home/icon_tab_profile_active.png',
  ),
];
