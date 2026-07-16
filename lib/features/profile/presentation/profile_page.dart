import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/repository_providers.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../domain/models/rabbit.dart';
import '../../../domain/models/weight_record.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_image_slot.dart';
import '../../../shared/widgets/raby_page.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';
import '../../../shared/widgets/raby_state_card.dart';
import '../../../shared/widgets/rabbit_avatar.dart';
import '../../rabbits/application/current_rabbit_providers.dart';
import '../../records/application/diary_timeline_providers.dart';
import '../../weight/application/weight_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rabbitState = ref.watch(currentRabbitProvider);

    return RabyPage(
      title: '我的',
      centerTitle: true,
      trailing: RabyIconBubble(
        icon: RabyIconKind.settings,
        tooltip: '设置',
        onTap: () => context.go(AppRoutes.settings),
      ),
      children: [
        rabbitState.when(
          data: (rabbit) => _ProfileContent(rabbit: rabbit),
          loading: () => const RabyStateCard(
            icon: RabyIconKind.hourglass,
            title: '正在读取档案',
            message: '稍等一下，本地档案正在准备。',
          ),
          error: (error, _) => RabyStateCard(
            icon: RabyIconKind.error,
            title: '档案读取失败',
            message: '本地数据暂时不可用，可以重试一次。',
            actionLabel: '重试',
            actionIcon: RabyIconKind.refresh,
            tone: RabyStateTone.danger,
            onAction: () => ref.invalidate(currentRabbitProvider),
          ),
        ),
      ],
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({required this.rabbit});

  final Rabbit? rabbit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rabbit = this.rabbit;
    final today = ref.watch(clockProvider)().toLocal();
    final diaryCount = rabbit == null
        ? 0
        : ref
              .watch(diaryTimelineProvider(rabbit.id))
              .maybeWhen(data: (entries) => entries.length, orElse: () => 0);
    final weightRecords = rabbit == null
        ? const <WeightRecord>[]
        : ref
              .watch(weightRecordsProvider(rabbit.id))
              .maybeWhen(data: (records) => records, orElse: () => const []);
    final weightCount = weightRecords.length;
    final latestWeightGrams = weightRecords.isEmpty
        ? null
        : weightRecords.first.weightGrams;

    return Column(
      children: [
        _OwnerCard(rabbit: rabbit, today: today),
        const SizedBox(height: RabySpacing.md),
        _ProfileCard(
          rabbit: rabbit,
          today: today,
          latestWeightGrams: latestWeightGrams,
        ),
        const SizedBox(height: RabySpacing.md),
        _StatsCard(
          diaryCount: diaryCount,
          weightCount: weightCount,
          streakDays: rabbit == null ? 0 : _companionDays(rabbit, today),
        ),
        const SizedBox(height: RabySpacing.md),
        _SettingsCard(rabbit: rabbit),
      ],
    );
  }
}

class _OwnerCard extends StatelessWidget {
  const _OwnerCard({required this.rabbit, required this.today});

  final Rabbit? rabbit;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final days = rabbit == null ? 0 : _companionDays(rabbit!, today);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Row(
        children: [
          const RabyImageSlot(
            width: 64,
            height: 64,
            radius: RabyRadius.pill,
            placeholderColor: RabyColors.surfaceWarm,
            semanticLabel: '待替换主人头像',
          ),
          const SizedBox(width: RabySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rabbit == null ? 'Raby 的主人' : '${rabbit!.name}的主人',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 3),
                Text(
                  rabbit == null
                      ? '建立档案后开始记录陪伴日常'
                      : '陪伴${rabbit!.name}的第 $days 天',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: RabyColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.rabbit,
    required this.today,
    required this.latestWeightGrams,
  });

  final Rabbit? rabbit;
  final DateTime today;
  final int? latestWeightGrams;

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      radius: RabyRadius.lg,
      color: RabyColors.surfaceSoft,
      borderColor: RabyColors.borderWarm,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (rabbit?.avatarPath == null || rabbit!.avatarPath!.isEmpty)
                const RabyImageSlot(
                  width: 112,
                  height: 112,
                  radius: RabyRadius.lg,
                  semanticLabel: '待替换兔兔主图',
                )
              else
                RabbitAvatar(
                  avatarPath: rabbit!.avatarPath,
                  size: 112,
                  iconSize: 54,
                  borderWidth: 4,
                  borderColor: RabyColors.stickerBorder,
                ),
              const SizedBox(width: RabySpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rabbit?.name ?? '还没有兔兔档案',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: RabyColors.secondary,
                            fontFamily: rabbit == null
                                ? 'RabyChillRoundF'
                                : 'RabyChillRoundM',
                          ),
                    ),
                    const SizedBox(height: RabySpacing.xs),
                    Text(
                      rabbit == null
                          ? '本地优先的兔子生活记录本'
                          : _profileMetaText(rabbit!, today, latestWeightGrams),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: RabyColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: RabySpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go(
                rabbit == null
                    ? AppRoutes.onboardingRabbit
                    : AppRoutes.rabbitEdit,
              ),
              icon: RabySketchIcon(
                kind: rabbit == null ? RabyIconKind.add : RabyIconKind.edit,
              ),
              label: Text(rabbit == null ? '建立档案' : '编辑资料'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.diaryCount,
    required this.weightCount,
    required this.streakDays,
  });

  final int diaryCount;
  final int weightCount;
  final int streakDays;

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              value: diaryCount.toString(),
              label: '日记数量',
              icon: RabyIconKind.diary,
            ),
          ),
          const SizedBox(height: 78, child: VerticalDivider(width: 1)),
          Expanded(
            child: _StatItem(
              value: weightCount.toString(),
              label: '体重记录',
              icon: RabyIconKind.weight,
            ),
          ),
          const SizedBox(height: 78, child: VerticalDivider(width: 1)),
          Expanded(
            child: _StatItem(
              value: streakDays.toString(),
              label: '陪伴天数',
              icon: RabyIconKind.calendar,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final RabyIconKind icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RabySticker(icon: icon, size: 42, background: RabyColors.surfaceWarm),
        const SizedBox(height: RabySpacing.sm),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: RabyColors.secondary,
            fontSize: 24,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.rabbit});

  final Rabbit? rabbit;

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              RabySpacing.md,
              RabySpacing.md,
              RabySpacing.md,
              RabySpacing.ms,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '常用功能',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const Divider(height: 1),
          _SettingTile(
            icon: RabyIconKind.rabbit,
            title: '兔兔档案',
            subtitle: rabbit == null ? '先建立第一只兔兔档案' : '查看和编辑 ${rabbit!.name}',
            onTap: () => context.go(
              rabbit == null
                  ? AppRoutes.onboardingRabbit
                  : AppRoutes.rabbitDetail,
            ),
          ),
          const Divider(height: 1),
          _SettingTile(
            icon: RabyIconKind.search,
            title: '搜索日记',
            subtitle: '按正文、标签和日期查找记录',
            onTap: () => context.go(AppRoutes.recordsSearch),
          ),
          const Divider(height: 1),
          _SettingTile(
            icon: RabyIconKind.chart,
            title: '体重趋势',
            subtitle: '查看体重变化和记录明细',
            onTap: () => context.go(AppRoutes.weight),
          ),
          const Divider(height: 1),
          _SettingTile(
            icon: RabyIconKind.photo,
            title: '照片相册',
            subtitle: '查看日记里的生活照片',
            onTap: () => context.go(AppRoutes.mediaAlbum),
          ),
          const Divider(height: 1),
          _SettingTile(
            icon: RabyIconKind.settings,
            title: '设置',
            subtitle: 'App 信息和关于 Raby',
            onTap: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final RabyIconKind icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 0,
      contentPadding: const EdgeInsets.symmetric(horizontal: RabySpacing.md),
      leading: RabySketchIcon(kind: icon, color: RabyColors.primaryDeep),
      title: Text(title, style: Theme.of(context).textTheme.titleSmall),
      subtitle: Text(subtitle),
      trailing: const RabySketchIcon(kind: RabyIconKind.chevronRight),
      onTap: onTap,
    );
  }
}

int _companionDays(Rabbit rabbit, DateTime today) {
  return today.difference(rabbit.createdAt.toLocal()).inDays + 1;
}

String _ageText(Rabbit rabbit, DateTime today) {
  final birthDate = rabbit.birthDate;
  if (birthDate == null || birthDate.isEmpty) {
    return '年龄未知';
  }
  final parsed = DateTime.tryParse(birthDate);
  if (parsed == null) {
    return '年龄未知';
  }
  var months = (today.year - parsed.year) * 12 + today.month - parsed.month;
  if (today.day < parsed.day) {
    months -= 1;
  }
  if (months < 12) {
    return '$months 个月';
  }
  return '${months ~/ 12} 岁';
}

String _profileMetaText(Rabbit rabbit, DateTime today, int? latestWeightGrams) {
  final weight = latestWeightGrams != null
      ? '当前体重 ${latestWeightGrams}g'
      : rabbit.initialWeightGrams == null
      ? '体重待记录'
      : '初始体重 ${rabbit.initialWeightGrams}g';
  return '${rabbit.furColor}${rabbit.breed}\n${_ageText(rabbit, today)} · $weight';
}
