import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/movie/movie_bloc.dart';
import '../../blocs/movie/movie_event.dart';
import '../../blocs/movie/movie_state.dart';
import '../../repositories/movie_repository.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/constants/dimens.dart';
import 'movie_detail.dart';
import 'profile.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:lottie/lottie.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  late ScrollController _scrollController;
  MovieBloc? _movieBloc;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    print('🔄 Scroll Event - Current: ${_scrollController.offset}, Max: ${_scrollController.position.maxScrollExtent}');
    print('🔄 Is Bottom: $_isBottom, MovieBloc exists: ${_movieBloc != null}');
    
    if (_movieBloc != null && _isBottom) {
      print('🚀 Triggering LoadMoreMovies...');
      _movieBloc!.add(LoadMoreMovies());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Daha agresif trigger - %80'de başlat
    final isAtBottom = currentScroll >= (maxScroll * 0.8);
    return isAtBottom;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieBloc(MovieRepository())..add(LoadMovies()),
      child: Builder(
        builder: (context) {
          // BlocProvider context içinde MovieBloc'a erişim sağla
          _movieBloc = context.read<MovieBloc>();
          
          // ScrollController listener'ını burada ekle
          if (!_scrollController.hasListeners) {
            _scrollController.addListener(_onScroll);
          }
          
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Image.asset(
                'assets/images/SinFlixLogoWithoutBg.png',
                height: 32,
                fit: BoxFit.contain,
              ),
              actions: [
                // Manuel test butonu ekle
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  onPressed: () {
                    print(' Manual LoadMoreMovies test');
                    context.read<MovieBloc>().add(LoadMoreMovies());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    // TODO: Search functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.movies_searchComingSoon)),
                    );
                  },
                ),
              ],
            ),
            body: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                // Daha detaylı debug logging
                print('🎬 ===== Movies State Debug =====');
                print('📊 Movies Count: ${state.movies.length}');
                print('📄 Current Page: ${state.currentPage}');
                print('🔚 Has Reached Max: ${state.hasReachedMax}');
                print('⏳ Is Loading: ${state.isLoading}');
                print('⏳ Is Loading More: ${state.isLoadingMore}');
                print('⏳ Is Refreshing: ${state.isRefreshing}');
                print('❌ Error: ${state.error}');
                if (state.movies.isNotEmpty) {
                  print('🎭 First Movie: ${state.movies.first.title}');
                  print('🎭 Last Movie: ${state.movies.last.title}');
                }
                print('🎬 ==============================');
                
                if (state.isLoading && state.movies.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.red),
                  );
                }

                if (state.error != null && state.movies.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.error!,
                          style: AppTextStyles.body.copyWith(color: AppColors.error),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<MovieBloc>().add(LoadMovies());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                          ),
                          child: Text(AppLocalizations.of(context)!.common_retry),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<MovieBloc>().add(RefreshMovies());
                  },
                  color: AppColors.red,
                  backgroundColor: AppColors.background,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(AppDimens.pagePadding),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index >= state.movies.length) {
                                return const SizedBox();
                              }
                              
                              final movie = state.movies[index];
                              return _MovieCard(
                                movie: movie,
                                onFavoriteToggle: () {
                                  context.read<MovieBloc>().add(ToggleFavorite(movie.id));
                                },
                              );
                            },
                            childCount: state.movies.length,
                          ),
                        ),
                      ),
                      
                      // Loading indicator for infinite scroll
                      if (state.isLoadingMore)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Lottie.asset(
                                'assets/animations/popcorn.json',
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                                repeat: true,
                              ),
                            ),
                          ),
                        ),
                        
                      // End of list indicator
                      if (state.hasReachedMax && state.movies.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.movies_endOfList,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.lightGreyText,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final dynamic movie; // Movie type
  final VoidCallback onFavoriteToggle;

  const _MovieCard({
    required this.movie,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailView(movie: movie),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.inputBackground,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Film posteri
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(movie.posterUrl),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {},
                      ),
                    ),
                    child: movie.posterUrl.isEmpty
                        ? Container(
                            color: AppColors.border,
                            child: const Icon(
                              Icons.movie,
                              color: AppColors.lightGreyText,
                              size: 48,
                            ),
                          )
                        : null,
                  ),
                  
                  // Favorileme butonu
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        // Event'i engelle, sadece favorileme yapılsın
                        onFavoriteToggle();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: movie.isFavorite ? AppColors.red : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Film bilgileri
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        movie.description,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.lightGreyText,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 