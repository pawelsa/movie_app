import 'package:floor/floor.dart';
import 'package:movie_app/data/database/models/movie_db.dart';

@dao
abstract class MovieDao {
  @Query('SELECT * FROM Movie')
  Future<List<MovieDb>> getAll();

  @insert
  Future<void> insertMovie(MovieDb movie);
}
