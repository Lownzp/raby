import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/repository_providers.dart';
import '../../../domain/models/tag.dart';

final availableTagsProvider = StreamProvider.family<List<Tag>, String>((
  ref,
  rabbitId,
) {
  return ref.watch(tagRepositoryProvider).watchAvailableTags(rabbitId);
});
