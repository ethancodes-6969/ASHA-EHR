import 'package:get_it/get_it.dart';
import 'package:asha_ehr/core/database/database_helper.dart';
import 'package:asha_ehr/data/repositories/household_repository_impl.dart';
import 'package:asha_ehr/domain/repositories/i_household_repository.dart';
import 'package:asha_ehr/domain/usecases/create_household_usecase.dart';
import 'package:asha_ehr/domain/usecases/get_all_households_usecase.dart';
import 'package:asha_ehr/presentation/home/home_view_model.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core
  getIt.registerLazySingleton(() => DatabaseHelper());

  // Repositories
  getIt.registerLazySingleton<IHouseholdRepository>(
    () => HouseholdRepositoryImpl(getIt()),
  );

  // UseCases
  getIt.registerLazySingleton(() => CreateHouseholdUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllHouseholdsUseCase(getIt()));

  // ViewModels
  getIt.registerFactory(() => HomeViewModel(getIt()));
}
