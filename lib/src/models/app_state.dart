import 'package:freezed_annotation/freezed_annotation.dart';
import 'movie.dart';
part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    @Default(<Movie>[]) List<Movie> movies,
    @Default(false) bool isLoading,
    @Default(1) int page,
  }) = AppState$;
}
