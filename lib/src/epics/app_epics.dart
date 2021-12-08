import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import '../actions/get_movies.dart';
import '../data/movies_api.dart';
import '../models/app_state.dart';
import '../models/movie.dart';

class AppEpics {
  AppEpics(this._api);

  final MoviesApi _api;

  Epic<AppState> get epics {
    return combineEpics(<Stream<dynamic> Function(Stream<dynamic>, EpicStore<AppState>)>[
      TypedEpic<AppState, GetMovies>(getMovies),
    ]);
  }

  Stream<Object> getMovies(Stream<GetMovies> actions, EpicStore<AppState> store) {
    return actions //
        .flatMap((GetMovies action) => Stream<void>.value(null)
            .asyncMap((_) => _api.getMovies(store.state.page))
            .map<Object>((List<Movie> movies) => GetMoviesSuccessful(movies))
            .onErrorReturnWith((Object error, StackTrace stackTrace) => GetMoviesError(error))
            .doOnData(action.result));
  }
}
