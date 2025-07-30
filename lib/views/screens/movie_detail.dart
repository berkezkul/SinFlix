import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/movie_detail/movie_detail_bloc.dart';
import '../../blocs/movie_detail/movie_detail_event.dart';
import '../../blocs/movie_detail/movie_detail_state.dart';
import '../../repositories/movie_repository.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/constants/dimens.dart';
import '../../models/movie.dart';
import '../../l10n/generated/app_localizations.dart';

class MovieDetailView extends StatelessWidget {
  final Movie movie;

  const MovieDetailView({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieDetailBloc(MovieRepository(), movie),
      child: Scaffold(
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
            BlocBuilder<MovieDetailBloc, MovieDetailState>(
              builder: (context, state) {
                if (state is MovieDetailLoaded) {
                  return IconButton(
                    icon: Icon(
                      state.movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: state.movie.isFavorite ? AppColors.red : Colors.white,
                    ),
                    onPressed: () {
                      context.read<MovieDetailBloc>().add(ToggleMovieFavorite(movie.id));
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            print('🎬 MovieDetail State: ${state.runtimeType}');
            
            if (state is MovieDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.red),
              );
            }

            if (state is MovieDetailError) {
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
                      state.message,
                      style: AppTextStyles.body.copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                      ),
                                                child: Text(AppLocalizations.of(context)!.common_back),
                    ),
                  ],
                ),
              );
            }

            if (state is MovieDetailLoaded) {
              print('🎬 Movie loaded: ${state.movie.title}');
              return _buildMovieDetail(context, state.movie);
            }

            // Fallback - başlangıç movie'si ile göster
            print('🎬 Using fallback movie: ${movie.title}');
            return _buildMovieDetail(context, movie);
          },
        ),
      ),
    );
  }

  Widget _buildMovieDetail(BuildContext context, Movie movie) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Film posteri ve temel bilgiler
          _buildHeroSection(context, movie),
          
          // Film detayları
          _buildDetailsSection(context, movie),
          
          // Film bilgileri (Genre, Runtime, Released vs.)
          _buildInfoCardsSection(context, movie),
          
          // Cast ve Crew bilgileri
          _buildCastCrewSection(context, movie),
          
          // Ödüller
          if (movie.awards.isNotEmpty && movie.awards != 'N/A' && movie.awards != 'null')
            _buildAwardsSection(context, movie),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, Movie movie) {
    return Container(
      height: 400,
      child: Stack(
        children: [
          // Arka plan blur poster
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(movie.posterUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7),
                  BlendMode.darken,
                ),
                onError: (exception, stackTrace) {},
              ),
            ),
          ),
          
          // İçerik
          Padding(
            padding: const EdgeInsets.all(AppDimens.pagePadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ana poster
                Container(
                  width: 140,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
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
                
                const SizedBox(width: 16),
                
                // Film bilgileri
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Film başlığı
                      Text(
                        movie.title,
                        style: AppTextStyles.headline.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // IMDB Rating Badge (Compact)
                      if (movie.imdbRating.isNotEmpty && 
                          movie.imdbRating != 'N/A' && 
                          movie.imdbRating != 'null')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.black, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'IMDB',
                                style: AppTextStyles.button.copyWith(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                movie.imdbRating,
                                style: AppTextStyles.button.copyWith(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      const SizedBox(height: 12),
                      
                      // Favorileme butonu
                      BlocBuilder<MovieDetailBloc, MovieDetailState>(
                        builder: (context, state) {
                          if (state is MovieDetailLoaded) {
                            return Container(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  context.read<MovieDetailBloc>().add(ToggleMovieFavorite(movie.id));
                                },
                                icon: Icon(
                                  state.movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                label: Flexible(
                                  child: Text(
                                    state.movie.isFavorite 
                                        ? AppLocalizations.of(context)!.movies_removeFromFavorites
                                        : AppLocalizations.of(context)!.movies_addToFavorites,
                                    style: AppTextStyles.button.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: state.movie.isFavorite ? AppColors.red : Colors.transparent,
                                  side: BorderSide(color: AppColors.red),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, Movie movie) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Konu',
            style: AppTextStyles.headline.copyWith(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            movie.description.isNotEmpty ? movie.description : 'Film konusu mevcut değil.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.lightGreyText,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(BuildContext context, Movie movie) {
    // Null ve empty check'leri
    bool hasImdbRating = movie.imdbRating.isNotEmpty && 
                        movie.imdbRating != 'N/A' && 
                        movie.imdbRating != 'null';
    bool hasMetascore = movie.metascore.isNotEmpty && 
                       movie.metascore != 'N/A' && 
                       movie.metascore != 'null';
    
    // Hiç rating yoksa section'ı gösterme
    if (!hasImdbRating && !hasMetascore) {
      return const SizedBox();
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pagePadding),
      child: Row(
        children: [
          // IMDB Rating Card
          if (hasImdbRating)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.black, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            'IMDB',
                            style: AppTextStyles.button.copyWith(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      movie.imdbRating,
                      style: AppTextStyles.headline.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '/ 10',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.lightGreyText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          if (hasImdbRating && hasMetascore)
            const SizedBox(width: 12),
          
          // Metascore Card
          if (hasMetascore)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'METASCORE',
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      movie.metascore,
                      style: AppTextStyles.headline.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '/ 100',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.lightGreyText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCardsSection(BuildContext context, Movie movie) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                                      AppLocalizations.of(context)!.movieDetail_movieInfo,
            style: AppTextStyles.headline.copyWith(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          
          // İlk satır: Tür ve Süre
          Row(
            children: [
                              Expanded(child: _buildInfoCard(context, AppLocalizations.of(context)!.movieDetail_genre, movie.genre)),
                const SizedBox(width: 12),
                Expanded(child: _buildInfoCard(context, AppLocalizations.of(context)!.movieDetail_runtime, movie.runtime)),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // İkinci satır: Yayın Tarihi ve Yaş Sınırı
          Row(
            children: [
                              Expanded(child: _buildInfoCard(context, AppLocalizations.of(context)!.movieDetail_released, movie.released)),
                const SizedBox(width: 12),
                Expanded(child: _buildInfoCard(context, AppLocalizations.of(context)!.movieDetail_rated, movie.rated)),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Üçüncü satır: Dil ve Ülke
          Row(
            children: [
                              Expanded(child: _buildInfoCard(context, AppLocalizations.of(context)!.movieDetail_language, movie.language)),
                const SizedBox(width: 12),
                Expanded(child: _buildInfoCard(context, AppLocalizations.of(context)!.movieDetail_country, movie.country)),
            ],
          ),
          
          // Metascore (eğer varsa)
          if (movie.metascore.isNotEmpty && 
              movie.metascore != 'N/A' && 
              movie.metascore != 'null')
            Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildMetascoreCard(movie.metascore)),
                    const Expanded(child: SizedBox()), // Boş alan
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String label, String value) {
    // Değer kontrolü ve fallback
    String displayValue = value;
    if (value.isEmpty || value == 'N/A' || value == 'null') {
      displayValue = AppLocalizations.of(context)!.movieDetail_notSpecified;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: AppColors.lightGreyText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            displayValue,
            style: AppTextStyles.body.copyWith(
              color: displayValue == AppLocalizations.of(context)!.movieDetail_notSpecified 
                  ? AppColors.lightGreyText.withOpacity(0.7)
                  : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: displayValue == AppLocalizations.of(context)!.movieDetail_notSpecified 
                  ? FontStyle.italic 
                  : FontStyle.normal,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMetascoreCard(String metascore) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'METASCORE',
              style: AppTextStyles.button.copyWith(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            metascore,
            style: AppTextStyles.headline.copyWith(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '/ 100',
            style: AppTextStyles.body.copyWith(
              color: AppColors.lightGreyText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCastCrewSection(BuildContext context, Movie movie) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.movieDetail_castCrew,
            style: AppTextStyles.headline.copyWith(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          
                                  _buildCrewCard(context, AppLocalizations.of(context)!.movieDetail_director, movie.director, Icons.movie_creation),
            const SizedBox(height: 12),
            _buildCrewCard(context, AppLocalizations.of(context)!.movieDetail_writer, movie.writer, Icons.edit),
            const SizedBox(height: 12),
            _buildCrewCard(context, AppLocalizations.of(context)!.movieDetail_actors, movie.actors, Icons.people),
        ],
      ),
    );
  }

  Widget _buildCrewCard(BuildContext context, String role, String names, IconData icon) {
    // Değer kontrolü ve fallback
    String displayNames = names;
    if (names.isEmpty || names == 'N/A' || names == 'null') {
              displayNames = AppLocalizations.of(context)!.movieDetail_notSpecified;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.lightGreyText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayNames,
                  style: AppTextStyles.body.copyWith(
                    color: displayNames == AppLocalizations.of(context)!.movieDetail_notSpecified
                        ? AppColors.lightGreyText.withOpacity(0.7)
                        : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontStyle: displayNames == AppLocalizations.of(context)!.movieDetail_notSpecified
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAwardsSection(BuildContext context, Movie movie) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.pagePadding),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.yellow.withOpacity(0.1),
              AppColors.red.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.yellow.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.yellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    color: AppColors.yellow,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.movieDetail_awards,
                  style: AppTextStyles.headline.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              movie.awards,
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 