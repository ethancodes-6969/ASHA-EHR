import 'package:get_it/get_it.dart';
import 'package:asha_ehr/core/database/database_helper.dart';
import 'package:asha_ehr/data/repositories/household_repository_impl.dart';
import 'package:asha_ehr/domain/repositories/i_household_repository.dart';
import 'package:asha_ehr/domain/usecases/create_household_usecase.dart';
import 'package:asha_ehr/domain/usecases/get_all_households_usecase.dart';
import 'package:asha_ehr/presentation/home/home_view_model.dart';
import 'package:asha_ehr/domain/repositories/i_member_repository.dart';
import 'package:asha_ehr/data/repositories/member_repository_impl.dart';
import 'package:asha_ehr/domain/usecases/create_member_usecase.dart';
import 'package:asha_ehr/domain/usecases/get_members_by_household_usecase.dart';
import 'package:asha_ehr/presentation/members/member_list_view_model.dart';

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

  getIt.registerLazySingleton(() => CreateMemberUseCase(getIt()));
  getIt.registerLazySingleton(() => GetMembersByHouseholdUseCase(getIt()));

  // Repositories

  getIt.registerLazySingleton<IMemberRepository>(
    () => MemberRepositoryImpl(getIt()),
  );

  // ViewModels
  getIt.registerFactory(() => HomeViewModel(getIt()));
  getIt.registerFactory(() => MemberListViewModel(getIt()));
}
