import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/raby_colors.dart';
import '../../app/theme/raby_theme.dart';
import '../../app/theme/raby_tokens.dart';

class RabyShell extends StatelessWidget {
  const RabyShell({required this.currentPath, required this.child, super.key});

  final String currentPath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: RabyBottomNavigation(currentPath: currentPath),
    );
  }
}

class RabyBottomNavigation extends StatelessWidget {
  const RabyBottomNavigation({required this.currentPath, super.key});

  final String currentPath;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: const ValueKey('raby-bottom-navigation'),
      decoration: const BoxDecoration(
        color: RabyColors.surface,
        boxShadow: RabyShadows.topEdge,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
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
          onTap: onTap,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          child: Center(
            child: SizedBox(
              height: 52,
              width: 56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    key: ValueKey('raby-tab-icon-${tab.label}'),
                    selected ? tab.activeAsset : tab.asset,
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    tab.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: foreground,
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      height: 1,
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
