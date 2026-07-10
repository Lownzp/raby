import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/repository_providers.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../domain/models/diary_entry.dart';
import '../../../domain/models/diary_media.dart';
import '../../../domain/models/rabbit.dart';
import '../../../domain/models/tag.dart';
import '../../../domain/models/weight_record.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';
import '../../../shared/widgets/raby_state_card.dart';
import '../../rabbits/application/current_rabbit_providers.dart';
import '../../weight/application/weight_providers.dart';
import '../application/diary_editor_controller.dart';
import '../application/diary_timeline_providers.dart';
import 'photo_viewer_page.dart';
import 'widgets/diary_empty_state.dart';

class RecordsPage extends ConsumerWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rabbitState = ref.watch(currentRabbitProvider);
    final rabbit = rabbitState.maybeWhen(
      data: (rabbit) => rabbit,
      orElse: () => null,
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 108),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeTopBar(
              onCreateDiary: rabbit == null
                  ? () => context.go(AppRoutes.onboardingRabbit)
                  : () => context.go(AppRoutes.recordsNew),
              createDiaryTooltip: rabbit == null ? '建立兔兔档案' : '写日记',
            ),
            Transform.translate(
              offset: const Offset(0, -8),
              child: _RabbitOverviewCard(
                rabbit: rabbit,
                isLoading: rabbitState.isLoading,
                error: rabbitState.hasError ? rabbitState.error : null,
                onViewWeight: () => context.go(AppRoutes.weight),
                onCreateWeight: rabbit == null
                    ? null
                    : () => context.go(AppRoutes.weightNew),
              ),
            ),
            const SizedBox(height: 0),
            _QuickActions(
              hasRabbit: rabbit != null,
              onCreateDiary: rabbit == null
                  ? () => context.go(AppRoutes.onboardingRabbit)
                  : () => context.go(AppRoutes.recordsNew),
              onCreateWeight: rabbit == null
                  ? () => context.go(AppRoutes.onboardingRabbit)
                  : () => context.go(AppRoutes.weightNew),
            ),
            const SizedBox(height: 8),
            _SectionHeader(
              title: '最近动态',
              onViewAll: rabbit == null
                  ? null
                  : () => context.go(AppRoutes.recordsSearch),
            ),
            const SizedBox(height: 6),
            _DiaryTimelineSection(rabbit: rabbit),
          ],
        ),
      ),
    );
  }
}

abstract final class _HomeAssets {
  static const logo = 'assets/images/brand/logo_raby.png';
  static const search = 'assets/images/icons/home/icon_search.png';
  static const add = 'assets/images/icons/home/icon_add.png';
  static const settings = 'assets/images/icons/home/icon_settings.png';
  static const heroBackground =
      'assets/images/rabbits/home/hero_scene_background_v2.png';
  static const heroRabbitStickers = [
    'assets/images/rabbits/home/rabbit_home_sticker_01.png',
    'assets/images/rabbits/home/rabbit_home_sticker_02.png',
    'assets/images/rabbits/home/rabbit_home_sticker_03.png',
  ];
  static const timeline = [
    'assets/images/rabbits/home/rabbit_timeline_01.png',
    'assets/images/rabbits/home/rabbit_timeline_02.png',
    'assets/images/rabbits/home/rabbit_timeline_03.png',
  ];
  static const carrot = 'assets/images/stickers/sticker_carrot.png';
  static const flower = 'assets/images/stickers/sticker_flower.png';
  static const scale = 'assets/images/stickers/sticker_scale.png';
  static const diary = 'assets/images/stickers/sticker_diary.png';
  static const heart = 'assets/images/stickers/sticker_heart.png';
  static const timelineStickers = [heart, carrot, flower];
}

const _homeText = Color(0xFF4C2413);
const _homeMutedText = Color(0xFF7B5544);
const _homeFullRoundFont = 'RabyChillRoundF';
const _homeNameFont = 'RabyChillRoundM';

TextStyle _cuteStyle(
  BuildContext context,
  TextStyle? base, {
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
}) {
  return (base ?? const TextStyle()).copyWith(
    color: color ?? _homeText,
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    letterSpacing: 0,
    fontFamily: _homeFullRoundFont,
    fontFamilyFallback: const [
      _homeNameFont,
      'Microsoft YaHei UI',
      'PingFang SC',
      'Noto Sans CJK SC',
    ],
  );
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar({
    required this.onCreateDiary,
    required this.createDiaryTooltip,
  });

  final VoidCallback onCreateDiary;
  final String createDiaryTooltip;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              // The bitmap contains transparent left padding; compensate so
              // the visible lettering aligns with the hero card edge.
              offset: const Offset(-35, 0),
              child: Image.asset(
                _HomeAssets.logo,
                width: 174,
                height: 87,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
        ),
        _RoundAssetButton(
          asset: _HomeAssets.search,
          tooltip: '搜索日记',
          onTap: () => context.go(AppRoutes.recordsSearch),
        ),
        const SizedBox(width: 8),
        _RoundAssetButton(
          asset: _HomeAssets.add,
          tooltip: createDiaryTooltip,
          onTap: onCreateDiary,
        ),
        const SizedBox(width: 8),
        _RoundAssetButton(
          asset: _HomeAssets.settings,
          tooltip: '设置',
          onTap: () => context.go(AppRoutes.settings),
        ),
      ],
    );
  }
}

class _RoundAssetButton extends StatelessWidget {
  const _RoundAssetButton({
    required this.asset,
    required this.tooltip,
    required this.onTap,
  });

  final String asset;
  final String tooltip;
  final VoidCallback onTap;
  static const double _size = 48;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox.square(
            dimension: _size,
            child: Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: RabyColors.surface.withValues(alpha: 0.68),
                ),
                child: Center(child: Image.asset(asset, width: 24, height: 24)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RabbitOverviewCard extends ConsumerWidget {
  const _RabbitOverviewCard({
    required this.rabbit,
    required this.isLoading,
    required this.error,
    required this.onViewWeight,
    required this.onCreateWeight,
  });

  final Rabbit? rabbit;
  final bool isLoading;
  final Object? error;
  final VoidCallback onViewWeight;
  final VoidCallback? onCreateWeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = isLoading
        ? '正在读取档案'
        : error != null
        ? '档案读取失败'
        : rabbit?.name ?? '还没有兔兔档案';
    final subtitle = error != null
        ? '本地数据暂时不可用,可以稍后重试。'
        : rabbit == null
        ? '完成建档后,这里会显示兔兔的生活首页。'
        : _rabbitIntro(rabbit!, ref.watch(clockProvider)().toLocal());
    final weightState = rabbit == null
        ? null
        : ref.watch(weightRecordsProvider(rabbit!.id));

    return RabyCard(
      radius: 38,
      padding: const EdgeInsets.all(4),
      borderColor: Colors.white,
      borderWidth: 4,
      softShadow: false,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFF2BF), Color(0xFFFFF9E8)],
      ),
      child: SizedBox(
        height: 258,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  _HomeAssets.heroBackground,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        const Color(0xFFFFF0B8).withValues(alpha: 0.95),
                        const Color(0xFFFFF0B8).withValues(alpha: 0.88),
                        const Color(0xFFFFF0B8).withValues(alpha: 0.42),
                        const Color(0xFFFFF1BC).withValues(alpha: 0.00),
                      ],
                      stops: const [0, 0.32, 0.50, 0.70],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -2,
                bottom: -1,
                width: 270,
                height: 235,
                child: const _RabbitStickerSwitcher(
                  assets: _HomeAssets.heroRabbitStickers,
                ),
              ),
              Positioned(
                left: 24,
                top: 23,
                right: 194,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _cuteStyle(
                              context,
                              Theme.of(context).textTheme.headlineMedium,
                              color: _homeText,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              height: 1.02,
                            ).copyWith(fontFamily: _homeNameFont),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Image.asset(
                          _HomeAssets.carrot,
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _cuteStyle(
                        context,
                        Theme.of(context).textTheme.bodyMedium,
                        color: _homeText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 18,
                bottom: 14,
                child: _HomeHeroWeightPanel(
                  weightState: weightState,
                  hasRabbit: rabbit != null,
                  onViewWeight: onViewWeight,
                  onCreateWeight: onCreateWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RabbitStickerSwitcher extends StatefulWidget {
  const _RabbitStickerSwitcher({required this.assets});

  final List<String> assets;

  @override
  State<_RabbitStickerSwitcher> createState() => _RabbitStickerSwitcherState();
}

class _RabbitStickerSwitcherState extends State<_RabbitStickerSwitcher> {
  var _currentIndex = 0;
  var _didPrecache = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecache) {
      return;
    }
    _didPrecache = true;
    for (final asset in widget.assets) {
      precacheImage(AssetImage(asset), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asset = widget.assets[_currentIndex];
    return Semantics(
      button: true,
      label: '切换兔兔贴纸',
      child: Tooltip(
        message: '切换兔兔贴纸',
        child: GestureDetector(
          key: const ValueKey('home-rabbit-sticker-switcher'),
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _currentIndex = (_currentIndex + 1) % widget.assets.length;
            });
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: _RabbitHeroSticker(
              key: ValueKey('home-rabbit-sticker-$_currentIndex'),
              imageProvider: AssetImage(asset),
            ),
          ),
        ),
      ),
    );
  }
}

class _RabbitHeroSticker extends StatelessWidget {
  const _RabbitHeroSticker({required this.imageProvider, super.key});

  final ImageProvider imageProvider;

  static const _outlineOffsets = [
    Offset(-4, 0),
    Offset(4, 0),
    Offset(0, -4),
    Offset(0, 4),
    Offset(-3, -3),
    Offset(3, -3),
    Offset(-3, 3),
    Offset(3, 3),
  ];

  @override
  Widget build(BuildContext context) {
    Widget image({bool outline = false}) {
      return Image(
        image: imageProvider,
        fit: BoxFit.contain,
        alignment: Alignment.bottomRight,
        filterQuality: FilterQuality.high,
        color: outline ? Colors.white : null,
        colorBlendMode: outline ? BlendMode.srcIn : null,
        excludeFromSemantics: outline,
        semanticLabel: outline ? null : '兔兔主图',
      );
    }

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        for (final offset in _outlineOffsets)
          Transform.translate(offset: offset, child: image(outline: true)),
        image(),
      ],
    );
  }
}

class _HomeHeroWeightPanel extends StatelessWidget {
  const _HomeHeroWeightPanel({
    required this.weightState,
    required this.hasRabbit,
    required this.onViewWeight,
    required this.onCreateWeight,
  });

  final AsyncValue<List<WeightRecord>>? weightState;
  final bool hasRabbit;
  final VoidCallback onViewWeight;
  final VoidCallback? onCreateWeight;

  @override
  Widget build(BuildContext context) {
    if (!hasRabbit) {
      return _WeightPanelShell(
        child: _WeightPanelEmpty(
          title: '当前体重',
          message: '建档后可以开始记录体重。',
          actionLabel: '开始建档',
          onAction: onCreateWeight,
        ),
      );
    }

    return _WeightPanelShell(
      child: weightState!.when(
        data: (records) {
          if (records.isEmpty) {
            return _WeightPanelEmpty(
              title: '当前体重',
              message: '还没有体重记录。',
              actionLabel: '去记录',
              onAction: onCreateWeight,
            );
          }
          return _WeightPanelContent(
            records: records,
            onViewWeight: onViewWeight,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _WeightPanelEmpty(
          title: '体重读取失败',
          message: '本地体重数据暂时不可用。',
          actionLabel: '查看趋势',
          onAction: onViewWeight,
        ),
      ),
    );
  }
}

class _WeightPanelShell extends StatelessWidget {
  const _WeightPanelShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 152,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        color: RabyColors.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 2.5),
      ),
      child: child,
    );
  }
}

class _WeightPanelContent extends StatelessWidget {
  const _WeightPanelContent({
    required this.records,
    required this.onViewWeight,
  });

  final List<WeightRecord> records;
  final VoidCallback onViewWeight;

  @override
  Widget build(BuildContext context) {
    final latest = records.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '当前体重',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _homeText,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFCBEFAD),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                child: Text(
                  '稳定',
                  style: _cuteStyle(
                    context,
                    Theme.of(context).textTheme.labelSmall,
                    color: const Color(0xFF338A24),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        SizedBox(
          height: 31,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: _homeText,
                  fontSize: 29,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
                children: [
                  TextSpan(text: '${latest.weightGrams}'),
                  TextSpan(
                    text: 'g',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: RabyColors.secondary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 1),
        _MiniWeightChart(records: records),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 24,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: RabyColors.surfaceWarm,
              foregroundColor: RabyColors.primaryDeep,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: onViewWeight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '查看趋势',
                  style: _cuteStyle(
                    context,
                    Theme.of(context).textTheme.labelLarge,
                    color: RabyColors.primaryDeep,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 1),
                const Icon(Icons.chevron_right_rounded, size: 13),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WeightPanelEmpty extends StatelessWidget {
  const _WeightPanelEmpty({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: RabyColors.secondary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '暂无体重',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: RabyColors.primaryDeep,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: RabyColors.textSecondary),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 22,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: RabyColors.surfaceWarm,
              foregroundColor: RabyColors.primaryDeep,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: onAction,
            child: Text(actionLabel),
          ),
        ),
      ],
    );
  }
}

class _MiniWeightChart extends StatelessWidget {
  const _MiniWeightChart({required this.records});

  final List<WeightRecord> records;

  @override
  Widget build(BuildContext context) {
    if (records.length < 2) {
      return SizedBox(
        height: 29,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '再记一次生成趋势',
            style: _cuteStyle(
              context,
              Theme.of(context).textTheme.labelSmall,
              color: _homeMutedText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 43,
      child: CustomPaint(
        painter: _WeightTrendPainter(records: records),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.hasRabbit,
    required this.onCreateDiary,
    required this.onCreateWeight,
  });

  final bool hasRabbit;
  final VoidCallback onCreateDiary;
  final VoidCallback onCreateWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            asset: _HomeAssets.scale,
            title: hasRabbit ? '记体重' : '先建档',
            subtitle: hasRabbit ? '记录体重变化' : '建立兔兔档案',
            color: RabyColors.surfaceWarm,
            iconRotation: -0.12,
            onTap: onCreateWeight,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            asset: _HomeAssets.diary,
            title: hasRabbit ? '写日记' : '建档后记录',
            subtitle: hasRabbit ? '记录日常点滴' : '记录生活日常',
            color: const Color(0xFFFFEEE4),
            iconRotation: 0,
            onTap: onCreateDiary,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconRotation,
    required this.onTap,
  });

  final String asset;
  final String title;
  final String subtitle;
  final Color color;
  final double iconRotation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      radius: 26,
      padding: EdgeInsets.zero,
      color: color,
      borderColor: Colors.white,
      borderWidth: 4,
      softShadow: false,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: SizedBox(
          height: 92,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 13,
                top: 17,
                child: _StickerBadge(
                  asset: asset,
                  size: 54,
                  rotation: iconRotation,
                ),
              ),
              Positioned.fill(
                left: 70,
                right: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _homeText,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: _homeMutedText,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 13,
                top: 37,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: RabyColors.surface.withValues(alpha: 0.92),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.72),
                      width: 1.1,
                    ),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: _homeText,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickerBadge extends StatelessWidget {
  const _StickerBadge({
    required this.asset,
    required this.size,
    required this.rotation,
  });

  final String asset;
  final double size;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onViewAll});

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _CalendarGlyph(),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            title,
            style: _cuteStyle(
              context,
              Theme.of(context).textTheme.titleLarge,
              color: _homeText,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          style: TextButton.styleFrom(
            foregroundColor: _homeMutedText,
            padding: const EdgeInsets.symmetric(horizontal: 6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '查看全部',
                style: _cuteStyle(
                  context,
                  Theme.of(context).textTheme.labelLarge,
                  color: _homeMutedText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.chevron_right_rounded, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _CalendarGlyph extends StatelessWidget {
  const _CalendarGlyph();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 22,
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox.square(
          dimension: 28,
          child: CustomPaint(painter: _CalendarGlyphPainter()),
        ),
      ),
    );
  }
}

class _DiaryTimelineSection extends ConsumerWidget {
  const _DiaryTimelineSection({required this.rabbit});

  final Rabbit? rabbit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rabbit = this.rabbit;
    if (rabbit == null) {
      return RabyStateCard(
        icon: RabyIconKind.rabbit,
        title: '请先建立兔兔档案',
        message: '完成建档后,这里会显示真实生活日记。',
        actionLabel: '建立兔兔档案',
        actionIcon: RabyIconKind.add,
        tone: RabyStateTone.warm,
        onAction: () => context.go(AppRoutes.onboardingRabbit),
      );
    }

    final timelineState = ref.watch(diaryTimelineProvider(rabbit.id));
    return timelineState.when(
      data: (entries) {
        if (entries.isEmpty) {
          return DiaryEmptyState(
            onCreate: () => context.go(AppRoutes.recordsNew),
          );
        }
        final visibleEntries = entries.take(3).toList(growable: false);
        return Column(
          children: [
            for (var index = 0; index < visibleEntries.length; index++) ...[
              _HomeDiaryRow(
                entry: visibleEntries[index],
                fallbackAsset:
                    _HomeAssets.timeline[index % _HomeAssets.timeline.length],
                stickerAsset:
                    _HomeAssets.timelineStickers[index %
                        _HomeAssets.timelineStickers.length],
                onView: () => context.go(
                  AppRoutes.recordDetail(visibleEntries[index].diary.id),
                ),
                onEdit: () => context.go(
                  AppRoutes.recordEdit(visibleEntries[index].diary.id),
                ),
                onDelete: () =>
                    _confirmDelete(context, ref, visibleEntries[index]),
              ),
              if (index != visibleEntries.length - 1) const SizedBox(height: 4),
            ],
          ],
        );
      },
      loading: () =>
          const RabyCard(child: Center(child: CircularProgressIndicator())),
      error: (error, _) => RabyStateCard(
        icon: RabyIconKind.error,
        title: '日记读取失败',
        message: '本地生活记录暂时不可用,可以重试一次。',
        actionLabel: '重试',
        actionIcon: RabyIconKind.refresh,
        tone: RabyStateTone.danger,
        onAction: () => ref.invalidate(diaryTimelineProvider(rabbit.id)),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    DiaryEntry entry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('删除这条日记?'),
        content: const Text('删除后会从时间轴隐藏,这个操作需要确认。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('取消'),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: RabyColors.danger,
              foregroundColor: RabyColors.onPrimary,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    try {
      await ref.read(diaryEditorControllerProvider).delete(entry.diary.id);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('日记已删除')));
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除失败: $error')));
    }
  }
}

class _HomeDiaryRow extends StatelessWidget {
  const _HomeDiaryRow({
    required this.entry,
    required this.fallbackAsset,
    required this.stickerAsset,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final DiaryEntry entry;
  final String fallbackAsset;
  final String stickerAsset;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final content = entry.diary.content?.trim();
    final tag = entry.tags.isEmpty ? null : entry.tags.first;
    return RabyCard(
      radius: 22,
      padding: EdgeInsets.zero,
      color: RabyColors.surface.withValues(alpha: 0.98),
      borderColor: Colors.white,
      borderWidth: 2,
      softShadow: false,
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 11, 6, 11),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _DiaryThumbnail(
                media: entry.media.isEmpty ? null : entry.media.first,
                fallbackAsset: fallbackAsset,
                stickerAsset: stickerAsset,
                onTap: entry.media.isEmpty
                    ? onView
                    : () {
                        context.push(
                          AppRoutes.mediaPhotos,
                          extra: PhotoViewerArgs(
                            media: entry.media,
                            initialIndex: 0,
                            returnPath: AppRoutes.records,
                          ),
                        );
                      },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _formatMonthDay(entry.diary.recordedAt),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: _homeText,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                height: 1.05,
                              ),
                        ),
                        const SizedBox(width: 8),
                        if (tag != null) _TagPill(tag: tag),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content == null || content.isEmpty
                          ? '这条日记没有正文。'
                          : content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _cuteStyle(
                        context,
                        Theme.of(context).textTheme.bodyMedium,
                        color: _homeMutedText,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        height: 1.18,
                      ),
                    ),
                    if (entry.tags.length > 1) ...[
                      const SizedBox(height: 3),
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          for (final extraTag in entry.tags.skip(1))
                            _TagPill(tag: extraTag, compact: true),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 2),
              SizedBox(
                width: 22,
                height: _DiaryThumbnail.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _DiaryMoreButton(onEdit: onEdit, onDelete: onDelete),
                    _DiaryCircleButton(
                      tooltip: '喜欢',
                      onPressed: () {},
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        color: Color(0xFF8B6E5F),
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _DiaryAction { edit, delete }

class _DiaryMoreButton extends StatelessWidget {
  const _DiaryMoreButton({required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return IconButtonTheme(
      data: IconButtonThemeData(style: _diaryActionButtonStyle),
      child: SizedBox(
        width: 22,
        height: 22,
        child: PopupMenuButton<_DiaryAction>(
          tooltip: '更多操作',
          padding: EdgeInsets.zero,
          iconSize: 14,
          splashRadius: 13,
          onSelected: (action) {
            switch (action) {
              case _DiaryAction.edit:
                onEdit();
              case _DiaryAction.delete:
                onDelete();
            }
          },
          icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF8B6E5F)),
          itemBuilder: (context) => const [
            PopupMenuItem(value: _DiaryAction.edit, child: Text('编辑')),
            PopupMenuItem(value: _DiaryAction.delete, child: Text('删除')),
          ],
        ),
      ),
    );
  }
}

final _diaryActionButtonStyle = IconButton.styleFrom(
  backgroundColor: Colors.transparent,
  minimumSize: Size.zero,
  fixedSize: const Size.square(22),
  padding: EdgeInsets.zero,
  side: BorderSide.none,
  shape: const CircleBorder(),
);

class _DiaryCircleButton extends StatelessWidget {
  const _DiaryCircleButton({
    required this.tooltip,
    required this.onPressed,
    required this.child,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        style: _diaryActionButtonStyle,
        onPressed: onPressed,
        icon: child,
      ),
    );
  }
}

class _DiaryThumbnail extends ConsumerWidget {
  const _DiaryThumbnail({
    required this.media,
    required this.fallbackAsset,
    required this.stickerAsset,
    required this.onTap,
  });

  final DiaryMedia? media;
  final String fallbackAsset;
  final String stickerAsset;
  final VoidCallback onTap;
  static const double height = 78;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = this.media;
    final image = media == null
        ? Image.asset(fallbackAsset, fit: BoxFit.cover)
        : FutureBuilder<File>(
            future: ref
                .watch(mediaStorageServiceProvider)
                .resolve(media.thumbnailPath ?? media.relativePath),
            builder: (context, snapshot) {
              final file = snapshot.data;
              if (file == null) {
                return Image.asset(fallbackAsset, fit: BoxFit.cover);
              }
              return Image.file(
                file,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset(fallbackAsset, fit: BoxFit.cover),
              );
            },
          );
    final child = SizedBox(
      width: 124,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: image,
                ),
              ),
            ),
          ),
          Positioned(
            left: -8,
            top: -8,
            child: Image.asset(
              stickerAsset,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
    if (media == null) {
      return child;
    }
    return Tooltip(
      message: '查看照片 ${media.sortOrder + 1}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: child,
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.tag, this.compact = false});

  final Tag tag;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _tagBackground(tag.name),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 8,
          vertical: compact ? 2.5 : 3.5,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _tagIcon(tag.name),
              size: compact ? 10 : 11,
              color: _tagForeground(tag.name),
            ),
            const SizedBox(width: 2),
            Text(
              tag.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _cuteStyle(
                context,
                Theme.of(context).textTheme.labelSmall,
                color: _tagForeground(tag.name),
                fontSize: compact ? 9.5 : 10.5,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _tagIcon(String name) {
    if (name.contains('饮') || name.contains('吃')) {
      return Icons.eco_rounded;
    }
    if (name.contains('心')) {
      return Icons.favorite_border_rounded;
    }
    if (name.contains('健') || name.contains('兽')) {
      return Icons.health_and_safety_outlined;
    }
    return Icons.wb_sunny_outlined;
  }

  Color _tagBackground(String name) {
    if (name.contains('饮') || name.contains('吃')) {
      return const Color(0xFFD8F2C2);
    }
    if (name.contains('心')) {
      return const Color(0xFFD6ECFF);
    }
    if (name.contains('健') || name.contains('兽')) {
      return const Color(0xFFFFE2B1);
    }
    return const Color(0xFFFFE8B9);
  }

  Color _tagForeground(String name) {
    if (name.contains('饮') || name.contains('吃')) {
      return const Color(0xFF288A26);
    }
    if (name.contains('心')) {
      return const Color(0xFF1B7EC9);
    }
    if (name.contains('健') || name.contains('兽')) {
      return const Color(0xFFD06A00);
    }
    return RabyColors.primaryDeep;
  }
}

String _rabbitIntro(Rabbit rabbit, DateTime today) {
  final breed = rabbit.breed.trim();
  final furColor = rabbit.furColor.trim();
  final kind =
      '${furColor.isEmpty ? '' : furColor}${breed.isEmpty ? '兔兔' : breed}';
  final age = _ageText(_parseProfileDate(rabbit.birthDate), today);
  if (age == null) {
    return '一只$kind';
  }
  return '一只 $age的$kind';
}

String? _ageText(DateTime? birthDate, DateTime today) {
  if (birthDate == null) {
    return null;
  }
  var months =
      (today.year - birthDate.year) * 12 + today.month - birthDate.month;
  if (today.day < birthDate.day) {
    months -= 1;
  }
  if (months < 0) {
    return null;
  }
  if (months < 1) {
    return '刚出生不久';
  }
  if (months < 12) {
    return '$months 个月大';
  }
  return '${months ~/ 12} 岁';
}

DateTime? _parseProfileDate(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) {
    return null;
  }
  final parts = text.split('-');
  if (parts.length != 3) {
    return null;
  }
  try {
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    final parsed = DateTime(year, month, day);
    if (parsed.year != year || parsed.month != month || parsed.day != day) {
      return null;
    }
    return parsed;
  } on FormatException {
    return null;
  }
}

String _formatMonthDay(DateTime date) {
  final local = date.toLocal();
  return '${local.month}月${local.day}日';
}

class _WeightTrendPainter extends CustomPainter {
  const _WeightTrendPainter({required this.records});

  final List<WeightRecord> records;

  @override
  void paint(Canvas canvas, Size size) {
    final points = records.take(7).toList().reversed.toList();
    if (points.length < 2) {
      return;
    }

    final weights = points.map((record) => record.weightGrams).toList();
    final minWeight = weights.reduce(math.min);
    final maxWeight = weights.reduce(math.max);
    final span = maxWeight - minWeight;
    final range = math.max(60, span * 1.15);
    final plotMin = minWeight - (range - span) / 2;
    final left = 3.0;
    final right = size.width - 3;
    final top = 3.0;
    final bottom = size.height - 4;

    Offset offsetFor(int index, int grams) {
      final x = points.length == 1
          ? size.width / 2
          : left + (right - left) * index / (points.length - 1);
      final y = bottom - (bottom - top) * (grams - plotMin) / range;
      return Offset(x, y);
    }

    final offsets = [
      for (var index = 0; index < points.length; index++)
        offsetFor(index, points[index].weightGrams),
    ];
    final path = _smoothTrendPath(offsets);

    final fillPath = Path.from(path)
      ..lineTo(offsets.last.dx, bottom)
      ..lineTo(offsets.first.dx, bottom)
      ..close();
    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x2EFFB000), Color(0x02FFB000)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = RabyColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);
  }

  Path _smoothTrendPath(List<Offset> offsets) {
    final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    if (offsets.length == 2) {
      path.lineTo(offsets.last.dx, offsets.last.dy);
      return path;
    }

    for (var index = 1; index < offsets.length; index++) {
      final previous = offsets[index - 1];
      final current = offsets[index];
      final beforePrevious = index > 1 ? offsets[index - 2] : previous;
      final afterCurrent = index < offsets.length - 1
          ? offsets[index + 1]
          : current;
      final control1 = Offset(
        previous.dx + (current.dx - beforePrevious.dx) / 6,
        previous.dy + (current.dy - beforePrevious.dy) / 6,
      );
      final control2 = Offset(
        current.dx - (afterCurrent.dx - previous.dx) / 6,
        current.dy - (afterCurrent.dy - previous.dy) / 6,
      );
      path.cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        current.dx,
        current.dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _WeightTrendPainter oldDelegate) {
    return oldDelegate.records != records;
  }
}

class _CalendarGlyphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = RabyColors.secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(3, 5.5, size.width - 6, size.height - 7),
      const Radius.circular(4),
    );
    canvas.drawRRect(rect, stroke);
    canvas.drawLine(Offset(3, 12), Offset(size.width - 3, 12), stroke);
    canvas.drawLine(const Offset(9, 3), const Offset(9, 8.5), stroke);
    canvas.drawLine(
      Offset(size.width - 9, 3),
      Offset(size.width - 9, 8.5),
      stroke,
    );
    final dot = Paint()
      ..color = RabyColors.secondary
      ..style = PaintingStyle.fill;
    for (final offset in const [
      Offset(9, 17),
      Offset(15, 17),
      Offset(21, 17),
      Offset(9, 22),
      Offset(15, 22),
      Offset(21, 22),
    ]) {
      canvas.drawCircle(offset, 1.1, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _CalendarGlyphPainter oldDelegate) => false;
}
