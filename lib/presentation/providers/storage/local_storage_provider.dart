import 'package:cinemapedia/domain/repositories/local_storage_repository_impl.dart';
import 'package:cinemapedia/infrastructure/datasources/isar_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStoreRepositoryProvider = Provider((ref) => LocalStorageRepositoryImpl( IsarDatasource()));