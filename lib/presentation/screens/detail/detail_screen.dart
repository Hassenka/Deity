import 'package:diety/core/constants/app_colors.dart';
import 'package:diety/presentation/widgets/favorites_manager.dart';
import 'package:diety/logic/product_bloc/detail_bloc/recipe_detail_bloc.dart';
import 'package:provider/provider.dart';
import 'package:diety/data/models/recipe_detail_model.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailScreen extends StatefulWidget {
  final int recipeId;
  const DetailScreen({super.key, required this.recipeId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _barAnimationController;
  late Animation<double> _barAnimation;
  late AnimationController _favoriteAnimationController;
  late Animation<double> _favoriteAnimation;
  String? _initialSection;
  bool _detailsShown = false;
  Timer? _detailsTimer;
  bool _hasShownTemporaryDetails = false;
  late FavoritesManager _favoritesManager; // Declare as late

  Future<void> _showRecipeDetails({
    double initialSize = 0.8,
    required BuildContext context,
  }) async {
    final state = context.read<RecipeDetailBloc>().state;
    if (state is! RecipeDetailLoadSuccess) return;

    if (_detailsShown) return;
    setState(() => _detailsShown = true);

    // Cancel any existing timer to prevent premature closing
    _detailsTimer?.cancel();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: initialSize,
          maxChildSize: 0.95,
          minChildSize: 0.22,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: RecipeDetailSheet(
                recipe: state.recipe,
                scrollController: scrollController,
                initialSection: _initialSection,
              ),
            );
          },
        );
      },
    );

    if (mounted) setState(() => _detailsShown = false);
    _initialSection = null; // Reset after sheet is closed
  }

  // Add this method
  void _showSectionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('القيم الغذائية'),
                onTap: () {
                  Navigator.pop(context);
                  _initialSection = 'القيم الغذائية';
                  _showRecipeDetails(context: context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_basket),
                title: const Text('المكونات'),
                onTap: () {
                  Navigator.pop(context);
                  _initialSection = 'المكونات';
                  _showRecipeDetails(context: context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.list_alt),
                title: const Text('الطريقة'),
                onTap: () {
                  Navigator.pop(context);
                  _initialSection = 'الطريقة';
                  _showRecipeDetails(context: context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTemporaryDetails(BuildContext context) {
    // Don't show if already visible
    if (_detailsShown) return;

    // Show the sheet
    _showRecipeDetails(context: context, initialSize: 0.22);

    // Set a timer to close it after 5 seconds
    _detailsTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _detailsShown) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _barAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _barAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _barAnimationController, curve: Curves.easeInOut),
    );

    _favoriteAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _favoriteAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _favoriteAnimationController,
        curve: Curves.easeOut,
      ),
    );
  }

  void _onFavoritesChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _favoritesManager = context.read<FavoritesManager>();
    _favoritesManager.fetchFavorites();
    _favoritesManager.addListener(_onFavoritesChanged);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RecipeDetailBloc()..add(FetchRecipeById(widget.recipeId)),
      child: BlocBuilder<RecipeDetailBloc, RecipeDetailState>(
        builder: (context, state) {
          if (state is RecipeDetailLoadInProgress) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is RecipeDetailLoadFailure) {
            return Scaffold(body: Center(child: Text('Error: ${state.error}')));
          }
          if (state is RecipeDetailLoadSuccess) {
            if (!_hasShownTemporaryDetails) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showTemporaryDetails(context);
              });
              _hasShownTemporaryDetails = true;
            }
            final recipe = state.recipe;
            final bool isFavorite = _favoritesManager.isFavorite(
              widget.recipeId,
            );
            return Scaffold(
              backgroundColor: AppColors.black,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.black,
                        size: 23,
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ScaleTransition(
                      scale: _favoriteAnimation,
                      child: GestureDetector(
                        onTap: () {
                          _favoritesManager.toggleFavorite(
                            widget.recipeId,
                            context: context,
                          );
                          _favoriteAnimationController.forward().then(
                            (_) => _favoriteAnimationController.reverse(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isFavorite
                                ? AppColors.favcard
                                : Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? Colors.white
                                : AppColors.favcard,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: _FullScreenVideoPlayer(
                      videoUrl: recipe.videoPath ?? '',
                      posterUrl: recipe.imgPath ?? '',
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.05,
                    left: MediaQuery.of(context).size.width * 0.06,
                    right: MediaQuery.of(context).size.width * 0.06,
                    child: GestureDetector(
                      onTap: () => _showRecipeDetails(context: context),
                      onLongPress: () {
                        // Show a menu to select section
                        _showSectionMenu(context);
                      },
                      child: ScaleTransition(
                        scale: _barAnimation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.keyboard_arrow_up,
                              color: AppColors.primary,
                              size: 28,
                            ),
                            GestureDetector(
                              onTap: () => _showRecipeDetails(context: context),
                              child: Divider(
                                height: 5,
                                thickness: 4,
                                color: AppColors.primary,
                                indent: MediaQuery.of(context).size.width * 0.3,
                                endIndent:
                                    MediaQuery.of(context).size.width * 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Scaffold(
            body: Center(child: Text('Something went wrong.')),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _barAnimationController.dispose();
    _favoriteAnimationController.dispose();
    _detailsTimer?.cancel();
    _favoritesManager.removeListener(_onFavoritesChanged);
    super.dispose();
  }
}

// --- Fullscreen Video Player Widget ---
class _FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String posterUrl;

  const _FullScreenVideoPlayer({
    required this.videoUrl,
    required this.posterUrl,
  });

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<_FullScreenVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  Timer? _controlsTimer;
  bool _showControls = true;
  bool _isMuted = false;
  Duration _videoDuration = Duration.zero;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _videoPlayerController.setVolume(_isMuted ? 0.0 : 1.0);
    });
    _startControlsTimer(); // Reset timer on interaction
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _videoPlayerController.value.isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
        _controlsTimer?.cancel(); // Keep controls visible when paused
      } else {
        _videoPlayerController.play();
        _startControlsTimer(); // Hide controls after a delay when playing
      }
    });
  }

  void _seekRelative(Duration seekStep) {
    final currentPosition = _videoPlayerController.value.position;
    final newPosition = currentPosition + seekStep;
    _videoPlayerController.seekTo(newPosition);

    // Show controls briefly on seek
    setState(() {
      _showControls = true;
    });
    _startControlsTimer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(Uri.encodeFull(widget.videoUrl)),
    );
    // Add a listener to show controls when the video ends/pauses.
    _videoPlayerController.addListener(() {
      if (!_videoPlayerController.value.isPlaying && mounted) {
        setState(() => _showControls = true);
      }
    });
    await _videoPlayerController.initialize();
    setState(() {
      _videoDuration = _videoPlayerController.value.duration;
      _videoPlayerController.setLooping(true);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Image.network(
        widget.posterUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stack) =>
            Container(color: AppColors.lightGray),
      );
    }

    return GestureDetector(
      // Tap anywhere on the video to toggle controls visibility
      onTap: () {
        setState(() => _showControls = !_showControls);
        if (_showControls) _startControlsTimer();
      },
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: _videoPlayerController.value.size.width,
            height: _videoPlayerController.value.size.height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_videoPlayerController),
                // Double tap to seek gestures
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onDoubleTap: () =>
                            _seekRelative(const Duration(seconds: -10)),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    // This middle part is to prevent the center play button
                    // from interfering with the double-tap gesture.
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _showControls = !_showControls);
                          if (_showControls) _startControlsTimer();
                        },
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onDoubleTap: () =>
                            _seekRelative(const Duration(seconds: 10)),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
                // Animated overlay for controls
                AnimatedOpacity(
                  opacity: _showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: IgnorePointer(
                    ignoring: !_showControls,
                    child: Stack(
                      children: [
                        // Dark overlay for better control visibility
                        Container(color: Colors.black.withOpacity(0.2)),
                        // Play/Pause Button
                        Center(
                          child: GestureDetector(
                            onTap: _togglePlayPause,
                            child: Container(
                              color: Colors.transparent, // For hit testing
                              child: Icon(
                                _videoPlayerController.value.isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled,
                                color: Colors.white.withOpacity(0.9),
                                size: 120.0,
                              ),
                            ),
                          ),
                        ),
                        // Bottom controls bar
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 4.0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  VideoProgressIndicator(
                                    _videoPlayerController,
                                    allowScrubbing: true,
                                    colors: const VideoProgressColors(
                                      playedColor: AppColors.primary,
                                      bufferedColor: Colors.white54,
                                      backgroundColor: Colors.black38,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ValueListenableBuilder(
                                        valueListenable: _videoPlayerController,
                                        builder: (context, value, child) {
                                          return Text(
                                            '${_formatDuration(value.position)} / ${_formatDuration(_videoDuration)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                            ),
                                          );
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: _toggleMute,
                                        child: Icon(
                                          _isMuted
                                              ? Icons.volume_off
                                              : Icons.volume_up,
                                          color: Colors.white,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Recipe Detail Sheet (Modal Content) ---
class RecipeDetailSheet extends StatefulWidget {
  final RecipeDetailModel recipe;
  final ScrollController scrollController;
  final String? initialSection;

  const RecipeDetailSheet({
    super.key,
    required this.recipe,
    required this.scrollController,
    this.initialSection,
  });

  @override
  State<RecipeDetailSheet> createState() => _RecipeDetailSheetState();
}

class _RecipeDetailSheetState extends State<RecipeDetailSheet>
    with TickerProviderStateMixin {
  late int _servings;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  String _activeSection = 'القيم الغذائية';
  bool _showStickyNav = false;
  bool _isScrolling = false;
  late AnimationController _headerAnimationController;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _headerFadeAnimation;
  @override
  void initState() {
    super.initState();
    _servings = widget.recipe.nbrServes ?? 1;
    _itemPositionsListener.itemPositions.addListener(_onScroll);

    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.95), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_headerAnimationController);

    // Start the animation when the sheet is built
    _headerAnimationController.forward();

    if (widget.initialSection != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        int? index;
        if (widget.initialSection == 'المكونات') {
          index = 1;
        } else if (widget.initialSection == 'الطريقة') {
          index = 2;
        } else if (widget.initialSection == 'القيم الغذائية') {
          // The first item is a combination of header and nutrition, so we scroll to index 0
          index = 0;
        }
        if (index != null) _scrollToSection(index);
      });
    }
  }

  // This function is called when the user scrolls within the recipe details sheet.
  void _onScroll() {
    if (_isScrolling) return;

    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    // Find the item that is closest to the top of the viewport.
    final firstVisibleIndex = positions
        .where((p) => p.itemLeadingEdge < 1)
        .reduce((max, p) => p.itemLeadingEdge > max.itemLeadingEdge ? p : max)
        .index;

    final sections = ['القيم الغذائية', 'المكونات', 'الطريقة'];
    if (firstVisibleIndex < sections.length &&
        _activeSection != sections[firstVisibleIndex]) {
      setState(() {
        _activeSection = sections[firstVisibleIndex];
      });
    }

    // --- New logic to control sticky nav visibility ---
    // Check if the first item (containing the header) is scrolled up.
    final firstItem = positions.firstWhere(
      (p) => p.index == 0,
      orElse: () => const ItemPosition(
        index: -1,
        itemLeadingEdge: 0,
        itemTrailingEdge: 0,
      ),
    );

    // Show sticky nav if scrolled past 20% of the first item's height.
    // Assuming the first item (index 0) is the main content area to check against.
    if (firstItem.itemLeadingEdge < -0.20) {
      if (!_showStickyNav) setState(() => _showStickyNav = true);
    } else if (firstItem.itemLeadingEdge > -00) {
      if (_showStickyNav) setState(() => _showStickyNav = false);
    }
  }

  void _scrollToSection(int index) {
    _isScrolling = true;
    _itemScrollController
        .scrollTo(
          index: index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          // Align the item just below the sticky header.
          // You might need to adjust this value based on the header's height.
          alignment: 0.05,
        )
        .whenComplete(() => _isScrolling = false);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onScroll);
    _headerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Drag Handle
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Conditionally display the sticky navigation bar
        if (_showStickyNav)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: _StickyNav(
                  activeSection: _activeSection,
                  onSectionTap: (sectionName) {
                    final sections = ['القيم الغذائية', 'المكونات', 'الطريقة'];
                    final sectionIndex = sections.indexOf(sectionName);
                    if (sectionIndex != -1) {
                      // The active section is updated optimistically for a faster UI response
                      setState(() => _activeSection = sectionName);
                      _scrollToSection(sectionIndex);
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Divider(height: 1, color: AppColors.lightGray),
              ),
            ],
          ),
        // Scrollable Content
        Expanded(
          child: ScrollablePositionedList.builder(
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
            itemCount: 3, // Nutrition, Ingredients, Directions
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSectionAtIndex(index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionAtIndex(int index) {
    switch (index) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideTransition(
              position: _headerSlideAnimation,
              child: FadeTransition(
                opacity: _headerFadeAnimation,
                child: _RecipeHeader(recipe: widget.recipe),
              ),
            ),
            _NutritionSection(
              recipe: widget.recipe,
              servings: _servings,
              onServingsChanged: (newServings) {
                if (newServings > 0) {
                  setState(() => _servings = newServings);
                }
              },
            ),
          ],
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: _IngredientsSection(
            recipe: widget.recipe,
            servings: _servings,
            initialServings: widget.recipe.nbrServes ?? 1,
            onServingsChanged: (newServings) {
              if (newServings > 0) {
                setState(() => _servings = newServings);
              }
            },
          ),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: _DirectionsSection(steps: widget.recipe.steps),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _RecipeHeader extends StatelessWidget {
  final RecipeDetailModel recipe;
  const _RecipeHeader({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recipe.title,
          style: GoogleFonts.tajawal(
            fontSize: 32,
            // fontWeight: FontWeight.bold,
            color: AppColors.darkBluePurple,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                "assets/images/flame_d.svg",
                width: 25,
                height: 25,
                color: AppColors.blueTitle,
              ),
            ),

            Text(
              ' Kcal ',
              style: GoogleFonts.tajawal(
                fontSize: 24,
                color: AppColors.blueTitle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 32),
              child: Text(
                ' ${recipe.kcal}',
                style: GoogleFonts.tajawal(
                  fontSize: 24,
                  color: AppColors.blueTitle,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'قيمة السعرات الحرارية للحصة الواحدة',
              style: GoogleFonts.tajawal(
                fontSize: 16,
                color: AppColors.blueTitle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MacroIndicator(
              label: 'البروتين',
              value: recipe.macros
                  .firstWhere(
                    (m) => m.title == 'البروتين',
                    orElse: () => Macro(title: '', value: 0, unit: ''),
                  )
                  .value,
              color: AppColors.primary,
              subtitle: 'Protein | Protéines',
            ),
            _MacroIndicator(
              label: 'الدهون',
              value: recipe.macros
                  .firstWhere(
                    (m) => m.title == 'الدهون',
                    orElse: () => Macro(title: '', value: 0, unit: ''),
                  )
                  .value,
              color: const Color(0xFFFFEB00),
              subtitle: 'Fat | Lipides',
            ),
            _MacroIndicator(
              label: 'الكربوهيدرات',
              value: recipe.macros
                  .firstWhere(
                    (m) => m.title == 'الكربوهيدرات',
                    orElse: () => Macro(title: '', value: 0, unit: ''),
                  )
                  .value,
              color: const Color(0xFF4CC9FE),
              subtitle: 'Carbohydrates | Glucides',
            ),
            _MacroIndicator(
              label: 'الألياف',
              value: recipe.macros
                  .firstWhere(
                    (m) => m.title == 'الألياف',
                    orElse: () => Macro(title: '', value: 0, unit: ''),
                  )
                  .value,
              color: const Color(0xFF06E775),
              subtitle: 'Fiber | Fibres',
            ),
          ],
        ),
      ],
    );
  }
}

// ignore: unused_element
class _InfoChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  // ignore: unused_element_parameter
  const _InfoChip({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, size: 18, color: AppColors.darkBluePurple),
          if (icon != null) const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.tajawal(
              color: AppColors.darkBluePurple,
              //fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroIndicator extends StatelessWidget {
  final String label;
  final double value;
  final String subtitle;
  final Color color;
  const _MacroIndicator({
    required this.label,
    required this.value,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    const totalMacros = 100; // Assume 100g for percentage calculation
    final percentage = (value / totalMacros);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    color: AppColors.darkBluePurple,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 16,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: percentage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.tajawal(
                    fontSize: 14,
                    color: AppColors.blueTitle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${value.toStringAsFixed(1)} g',
            style: GoogleFonts.tajawal(
              fontSize: 16,
              //fontWeight: FontWeight.w500,
              color: AppColors.darkBluePurple,
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyNav extends StatefulWidget {
  final String activeSection;
  final Function(String) onSectionTap;

  const _StickyNav({required this.activeSection, required this.onSectionTap});

  @override
  _StickyNavState createState() => _StickyNavState();
}

class _StickyNavState extends State<_StickyNav> {
  @override
  Widget build(BuildContext context) {
    final sections = ['القيم الغذائية', 'المكونات', 'الطريقة'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment:
                widget.activeSection ==
                    'القيم الغذائية' // This is on the right in RTL
                ? Alignment.centerRight
                : widget.activeSection == 'المكونات'
                ? Alignment.center
                : Alignment.centerLeft, // 'الطريقة' is on the left
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: sections.map((section) {
              final isActive = widget.activeSection == section;
              return Expanded(
                child: GestureDetector(
                  onTap: () => widget.onSectionTap(section),
                  child: Container(
                    color: Colors.transparent, // for hit testing
                    child: Center(
                      child: Text(
                        section,
                        style: GoogleFonts.tajawal(
                          fontSize: 18,
                          fontWeight: isActive
                              ? FontWeight.normal
                              : FontWeight.normal,
                          color: isActive
                              ? AppColors.white
                              : AppColors.blueTitle,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // The icon was removed as the asset does not exist.
            // You can re-add an Icon widget here if you have a valid icon.
            // Icon(icon, color: AppColors.perpel, size: 28),
            if (icon.isNotEmpty)
              SvgPicture.asset(
                "assets/images/$icon",
                color: AppColors.perpel,
                width: 28,
                height: 28,
              ),
            icon.isNotEmpty ? const SizedBox(width: 12) : SizedBox(),
            Text(
              title,
              style: GoogleFonts.tajawal(
                fontSize: 24,
                // fontWeight: FontWeight.bold,
                color: AppColors.perpel,
              ),
            ),
          ],
        ),
        subtitle.isNotEmpty
            ? Text(
                subtitle,
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  color: AppColors.blueTitle,
                ),
              )
            : SizedBox(),
        const SizedBox(height: 8),
        Container(height: 2, color: AppColors.perpel),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// A track shape that adds an inset “shadow” on both active and inactive parts.
class ShadowedTrackShape extends SliderTrackShape {
  const ShadowedTrackShape({
    this.shadowColor = const Color(0xFF5e5dc0),
    this.shadowAlpha = 102, // 0x66 ≈ 40 %
  });

  final Color shadowColor;
  final int shadowAlpha;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Canvas canvas = context.canvas;
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // 1. Normal yellow track
    final Paint trackPaint = Paint()
      ..color = sliderTheme.activeTrackColor ?? Colors.yellow
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, Radius.circular(trackRect.height / 2)),
      trackPaint,
    );

    // 2. Inset “shadow” (1 px inside)
    final Rect shadowRect = trackRect.deflate(1);
    final Paint shadowPaint = Paint()
      ..color = shadowColor.withAlpha(shadowAlpha)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        shadowRect,
        Radius.circular(shadowRect.height / 2),
      ),
      shadowPaint,
    );
  }
}

class _ServingsSelector extends StatelessWidget {
  final int servings;
  final ValueChanged<int> onServingsChanged;

  const _ServingsSelector({
    required this.servings,
    required this.onServingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'عدد الحصص',
          style: GoogleFonts.tajawal(fontSize: 20, color: AppColors.blueTitle),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.yellow,
              inactiveTrackColor: Colors.yellow,
              trackHeight: 6,
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayColor: AppColors.primary.withOpacity(0.2),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              trackShape: const ShadowedTrackShape(), // <-- add this line
            ),
            child: Slider(
              value: servings.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              onChanged: (v) => onServingsChanged(v.toInt()),
            ),
          ),
        ),
        Text(
          '$servings',
          style: GoogleFonts.tajawal(
            fontSize: 22,
            color: AppColors.darkBluePurple,
          ),
        ),
      ],
    );
  }
}

class _NutritionSection extends StatelessWidget {
  final RecipeDetailModel recipe;
  final int servings;
  final ValueChanged<int> onServingsChanged;

  const _NutritionSection({
    required this.recipe,
    required this.servings,
    required this.onServingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'القيم الغذائية للحصة الواحدة',
          subtitle: "",
          icon: "rak.svg",
        ),

        _ServingsSelector(
          servings: servings,
          onServingsChanged: onServingsChanged,
        ),
        const SizedBox(height: 24),

        const _SectionTitle(
          title: 'قيم المغذيات الكبيرة',
          subtitle: 'Macronutrients | Macronutriments',
          icon: "rak.svg",
        ),
        const SizedBox(height: 8),
        ...recipe.macros.map(
          (macro) => _NutrientRow(
            title: macro.title,
            value: (macro.value * servings).toDouble(),
            unit: 'غ',
            showDivider: true,
          ),
        ),
        const SizedBox(height: 24),

        const _SectionTitle(
          title: 'قيم المغذيات الدقيقة',
          subtitle: 'Micronutrients | Micronutriments',
          icon: "rak.svg",
        ),
        const SizedBox(height: 8),
        ...recipe.micros.map(
          (micro) => _NutrientRow(
            title: micro.title,
            value: micro.value * servings,
            unit: micro.unit,
            showDivider: true,
          ),
        ),
      ],
    );
  }
}

class _NutrientRow extends StatelessWidget {
  final String title;
  final num value;
  final String unit;
  final bool showDivider;

  const _NutrientRow({
    required this.title,
    required this.value,
    required this.unit,
    this.showDivider = false,
  });

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 16,
      color: AppColors.darkBluePurple.withOpacity(0.25),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              title,
              style: GoogleFonts.tajawal(
                fontSize: 18,
                color: AppColors.darkBluePurple,
              ),
            ),
          ),
          _buildDivider(),
          Expanded(
            flex: 2,
            child: Text(
              value.toStringAsFixed(1),
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: 18,
                color: AppColors.darkBluePurple,
              ),
            ),
          ),
          _buildDivider(),
          Expanded(
            flex: 2,
            child: Text(
              unit,
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: 12,
                color: AppColors.darkBluePurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientsSection extends StatelessWidget {
  final RecipeDetailModel recipe;
  final int servings;
  final int initialServings;
  final ValueChanged<int> onServingsChanged;

  const _IngredientsSection({
    required this.recipe,
    required this.servings,
    required this.initialServings,
    required this.onServingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    double factor = servings / (initialServings > 0 ? initialServings : 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'المكونات',
          subtitle: 'Ingredients',
          icon: "rak.svg",
        ),
        _ServingsSelector(
          servings: servings,
          onServingsChanged: onServingsChanged,
        ),
        const SizedBox(height: 24),
        ...recipe.ingredients.map((group) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (group.title != 'Ingrédient')
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Text(
                    group.title,
                    style: GoogleFonts.tajawal(
                      fontSize: 20,
                      color: AppColors.darkBluePurple,
                    ),
                  ),
                ),
              ...group.items.map((item) {
                return _NutrientRow(
                  title: item.ingredient,
                  value: item.qteGramme * factor,
                  unit: item.unite,
                );
              }),
            ],
          );
        }),
      ],
    );
  }
}

class _DirectionsSection extends StatelessWidget {
  final List<Step> steps;
  const _DirectionsSection({required this.steps});

  @override
  Widget build(BuildContext context) {
    int stepCounter = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'الطريقة',
          subtitle: 'Directions',
          icon: "rak.svg",
        ),
        ...steps.map((group) {
          stepCounter++;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$stepCounter. ',
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: Text(
                    group.description,
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      color: AppColors.darkBluePurple,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 60),
      ],
    );
  }
}
