import 'package:freezed_annotation/freezed_annotation.dart';
part 'movie.freezed.dart';
part 'movie.g.dart';

@freezed
class Movie with _$Movie {
  const factory Movie({
    required int id,
    required String title,
  }) = Movie$;

  factory Movie.fromJson(Map<dynamic, dynamic> json) => _$MovieFromJson(Map<String, dynamic>.from(json));
}
