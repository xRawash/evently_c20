import 'package:evently_app_abbas/data_sources/contracts/auth_data_source.dart';
import 'package:evently_app_abbas/data_sources/contracts/event_data_source.dart';
import 'package:evently_app_abbas/data_sources/firestore_impl/auth_firestore_data_source_impl.dart';
import 'package:evently_app_abbas/data_sources/firestore_impl/event_firestore_data_source_impl.dart';
import 'package:evently_app_abbas/repositories/contracts/auth_repository.dart';
import 'package:evently_app_abbas/repositories/contracts/event_repository.dart';
import 'package:evently_app_abbas/repositories/impl/auth_repository_impl.dart';
import 'package:evently_app_abbas/repositories/impl/event_repository_impl.dart';

class DependencyInjection {
  static AuthDataSource provideAuthDataSource() {
    return AuthFirestoreDataSourceImpl();
  }

  static EventDataSource provideEventDataSource() {
    return EventFirestoreDataSourceImpl();
  }

  static AuthRepository provideAuthRepository() {
    return AuthRepositoryImpl(
      authDataSource: provideAuthDataSource(),
    );
  }

  static EventRepository provideEventRepository() {
    return EventRepositoryImpl(
      eventDataSource: provideEventDataSource(),
    );
  }
}
