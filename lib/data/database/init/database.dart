import 'dart:async';

import 'package:floor/floor.dart';
import 'package:movie_app/data/database/dao/movie_dao.dart';
import 'package:movie_app/data/database/models/movie_db.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [MovieDb])
abstract class AppDatabase extends FloorDatabase {
  MovieDao get movieDao;
}
