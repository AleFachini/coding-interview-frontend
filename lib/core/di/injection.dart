import 'package:coding_interview_frontend/core/services/conversion_api_service.dart';
import 'package:coding_interview_frontend/features/conversion/data/datasources/conversion_remote_datasource.dart';
import 'package:coding_interview_frontend/features/conversion/data/repositories/conversion_repository_impl.dart';
import 'package:coding_interview_frontend/features/conversion/domain/repositories/conversion_repository.dart';
import 'package:coding_interview_frontend/features/conversion/domain/usecases/get_conversion_quote_usecase.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void configureDependencies() {
  getIt
    ..registerLazySingleton<Dio>(Dio.new)
    ..registerLazySingleton<ConversionApiService>(ConversionApiService.new)
    ..registerLazySingleton<ConversionRemoteDataSource>(
      () => ConversionRemoteDataSourceImpl(
        dio: getIt<Dio>(),
        apiService: getIt<ConversionApiService>(),
      ),
    )
    ..registerLazySingleton<ConversionRepository>(
      () => ConversionRepositoryImpl(getIt<ConversionRemoteDataSource>()),
    )
    ..registerLazySingleton<GetConversionQuoteUseCase>(
      () => GetConversionQuoteUseCase(getIt<ConversionRepository>()),
    )
    ..registerFactory<ConversionBloc>(
      () => ConversionBloc(getIt<GetConversionQuoteUseCase>()),
    );
}
