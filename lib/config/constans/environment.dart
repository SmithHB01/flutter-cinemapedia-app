import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment{

  static String theMovieDbkey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No hay api key';



}