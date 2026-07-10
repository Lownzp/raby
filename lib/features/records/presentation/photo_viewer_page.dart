import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/repository_providers.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../domain/models/diary_media.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';

class PhotoViewerArgs {
  PhotoViewerArgs({
    required List<DiaryMedia> media,
    this.initialIndex = 0,
    this.returnPath = AppRoutes.records,
    this.returnTooltip = '返回记录页',
    this.returnLabel = '返回记录页',
  }) : media = List.unmodifiable(media);

  const PhotoViewerArgs.empty()
    : media = const [],
      initialIndex = 0,
      returnPath = AppRoutes.records,
      returnTooltip = '返回记录页',
      returnLabel = '返回记录页';

  final List<DiaryMedia> media;
  final int initialIndex;
  final String returnPath;
  final String returnTooltip;
  final String returnLabel;

  int get safeInitialIndex {
    if (media.isEmpty) {
      return 0;
    }
    return initialIndex.clamp(0, media.length - 1).toInt();
  }
}

class PhotoViewerPage extends ConsumerStatefulWidget {
  const PhotoViewerPage({required this.args, super.key});

  final PhotoViewerArgs args;

  @override
  ConsumerState<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends ConsumerState<PhotoViewerPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.args.safeInitialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _leave(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: widget.args.media.isEmpty
            ? _MissingPhotoState(
                returnLabel: widget.args.returnLabel,
                onBack: () => _leave(context),
              )
            : Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.args.media.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return _PhotoPage(media: widget.args.media[index]);
                    },
                  ),
                  _ViewerTopBar(
                    currentIndex: _currentIndex,
                    total: widget.args.media.length,
                    returnTooltip: widget.args.returnTooltip,
                    onBack: () => _leave(context),
                  ),
                ],
              ),
      ),
    );
  }

  void _leave(BuildContext context) {
    context.go(widget.args.returnPath);
  }
}

class _ViewerTopBar extends StatelessWidget {
  const _ViewerTopBar({
    required this.currentIndex,
    required this.total,
    required this.returnTooltip,
    required this.onBack,
  });

  final int currentIndex;
  final int total;
  final String returnTooltip;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            RabySpacing.sm,
            RabySpacing.xs,
            RabySpacing.sm,
            0,
          ),
          child: Row(
            children: [
              _DarkIconButton(
                tooltip: returnTooltip,
                icon: RabyIconKind.back,
                onPressed: onBack,
              ),
              Expanded(
                child: Text(
                  '${currentIndex + 1}/$total',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class _DarkIconButton extends StatelessWidget {
  const _DarkIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final RabyIconKind icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: RabyColors.paper,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        color: RabyColors.secondary,
        icon: RabySketchIcon(kind: icon, color: RabyColors.secondary),
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      ),
    );
  }
}

class _PhotoPage extends ConsumerStatefulWidget {
  const _PhotoPage({required this.media});

  final DiaryMedia media;

  @override
  ConsumerState<_PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends ConsumerState<_PhotoPage> {
  late Future<File> _photoFileFuture;

  @override
  void initState() {
    super.initState();
    _photoFileFuture = ref
        .read(mediaStorageServiceProvider)
        .resolve(widget.media.relativePath);
  }

  @override
  void didUpdateWidget(covariant _PhotoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media.relativePath != widget.media.relativePath) {
      _photoFileFuture = ref
          .read(mediaStorageServiceProvider)
          .resolve(widget.media.relativePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _photoFileFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const _PhotoErrorState();
        }
        final file = snapshot.data;
        if (file == null) {
          return const _PhotoPreviewFallback();
        }
        return SizedBox.expand(
          child: Image.file(
            file,
            fit: BoxFit.contain,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) =>
                const _PhotoErrorState(),
          ),
        );
      },
    );
  }
}

class _PhotoPreviewFallback extends StatelessWidget {
  const _PhotoPreviewFallback();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        height: 248,
        decoration: BoxDecoration(
          color: RabyColors.surfaceWarm,
          borderRadius: BorderRadius.circular(RabyRadius.xl),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 28,
              top: 28,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: RabyColors.primary.withValues(alpha: 0.28),
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: 52),
              ),
            ),
            Positioned(
              right: 34,
              bottom: 22,
              child: Transform.rotate(
                angle: -0.48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: RabyColors.primaryDeep,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const SizedBox(width: 46, height: 92),
                ),
              ),
            ),
            const Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: RabyColors.paper,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: RabySketchIcon(
                    kind: RabyIconKind.rabbit,
                    color: RabyColors.secondary,
                    size: 96,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissingPhotoState extends StatelessWidget {
  const _MissingPhotoState({required this.returnLabel, required this.onBack});

  final String returnLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(RabySpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const RabySketchIcon(
                kind: RabyIconKind.brokenImage,
                color: Colors.white70,
                size: 44,
              ),
              const SizedBox(height: RabySpacing.md),
              Text(
                '照片不可用',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: RabySpacing.xs),
              Text(
                '返回上一页后可以继续查看其它内容。',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: RabySpacing.lg),
              OutlinedButton.icon(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white38),
                ),
                icon: const RabySketchIcon(kind: RabyIconKind.back),
                label: Text(returnLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoErrorState extends StatelessWidget {
  const _PhotoErrorState();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.black),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const RabySketchIcon(
              kind: RabyIconKind.brokenImage,
              color: Colors.white70,
              size: 44,
            ),
            const SizedBox(height: RabySpacing.sm),
            Text(
              '照片文件无法读取',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
