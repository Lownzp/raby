import 'package:flutter/material.dart';

import '../../../../shared/widgets/raby_sketch_icon.dart';
import '../../../../shared/widgets/raby_state_card.dart';

class DiaryEmptyState extends StatelessWidget {
  const DiaryEmptyState({required this.onCreate, super.key});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return RabyStateCard(
      icon: RabyIconKind.diary,
      title: '还没有生活记录',
      message: '先写一段今天的状态,标签和时间轴会自动整理起来。',
      actionLabel: '写第一条日记',
      actionIcon: RabyIconKind.add,
      tone: RabyStateTone.warm,
      onAction: onCreate,
    );
  }
}
