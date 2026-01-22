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
import 'package:asha_ehr/domain/repositories/i_visit_repository.dart';
import 'package:asha_ehr/data/repositories/visit_repository_impl.dart';
import 'package:asha_ehr/domain/usecases/create_visit_usecase.dart';
import 'package:asha_ehr/domain/usecases/get_visits_by_member_usecase.dart';
import 'package:asha_ehr/presentation/visits/visit_list_view_model.dart';
import 'package:asha_ehr/domain/repositories/i_due_list_repository.dart';
import 'package:asha_ehr/data/repositories/due_list_repository_impl.dart';
import 'package:asha_ehr/domain/usecases/regenerate_due_list_usecase.dart';
import 'package:asha_ehr/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:asha_ehr/domain/usecases/get_all_due_items_usecase.dart';
import 'package:asha_ehr/presentation/dashboard/dashboard_view_model.dart';
import 'package:asha_ehr/presentation/due_list/due_list_view_model.dart';
import 'package:asha_ehr/core/sync/device_attributes.dart';
import 'package:asha_ehr/data/remote/firestore_helper.dart';
import 'package:asha_ehr/data/repositories/sync_repository_impl.dart';
import 'package:asha_ehr/domain/repositories/i_sync_repository.dart';
import 'package:asha_ehr/presentation/sync/sync_view_model.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core
  getIt.registerLazySingleton(() => DatabaseHelper());
  getIt.registerLazySingleton(() => DeviceAttributes(getIt()));
  getIt.registerLazySingleton(() => FirestoreHelper());

  // Repositories
  getIt.registerLazySingleton<IHouseholdRepository>(
    () => HouseholdRepositoryImpl(getIt()),
  );

  // UseCases
  getIt.registerLazySingleton(() => CreateHouseholdUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllHouseholdsUseCase(getIt()));

  getIt.registerLazySingleton(() => CreateMemberUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => GetMembersByHouseholdUseCase(getIt()));

  getIt.registerLazySingleton(() => CreateVisitUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => GetVisitsByMemberUseCase(getIt()));

  getIt.registerLazySingleton(() => GetAllDueItemsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetDashboardStatsUseCase(getIt()));
  getIt.registerLazySingleton(() => RegenerateDueListUseCase(
    householdRepository: getIt(),
    memberRepository: getIt(),
    visitRepository: getIt(),
    dueListRepository: getIt(),
  ));

  // Repositories

  getIt.registerLazySingleton<IMemberRepository>(
    () => MemberRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<IVisitRepository>(
    () => VisitRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<IDueListRepository>(
    () => DueListRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<ISyncRepository>(
    () => SyncRepositoryImpl(
      dbHelper: getIt(),
      firestoreHelper: getIt(),
      deviceAttributes: getIt(),
    ),
  );

  // ViewModels
  getIt.registerFactory(() => HomeViewModel(getIt()));
  getIt.registerFactory(() => MemberListViewModel(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => VisitListViewModel(getIt()));
  getIt.registerFactory(() => DashboardViewModel(getIt(), getIt()));
  getIt.registerFactory(() => DueListViewModel(getIt()));
  getIt.registerFactory(() => SyncViewModel(getIt(), getIt()));
}
