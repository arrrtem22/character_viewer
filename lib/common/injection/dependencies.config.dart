// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:character_viewer/common/common.dart' as _i12;
import 'package:character_viewer/common/constant/config.dart' as _i3;
import 'package:character_viewer/common/injection/api_module.dart' as _i18;
import 'package:character_viewer/common/injection/third_party_module.dart'
    as _i19;
import 'package:character_viewer/common/network/api/characters_api.dart'
    as _i15;
import 'package:character_viewer/common/network/interceptor/base_interceptor.dart'
    as _i11;
import 'package:character_viewer/common/network/interceptor/error_interceptor.dart'
    as _i14;
import 'package:character_viewer/common/network/interceptor/json_response_interceptor.dart'
    as _i8;
import 'package:character_viewer/common/network/interceptor/logger_interceptor.dart'
    as _i10;
import 'package:character_viewer/common/service/character_service.dart' as _i16;
import 'package:character_viewer/common/service/device_info.dart' as _i5;
import 'package:character_viewer/feature/detail/cubit/detail_cubit.dart' as _i4;
import 'package:character_viewer/feature/home/cubit/home_cubit.dart' as _i17;
import 'package:dio/dio.dart' as _i13;
import 'package:get_it/get_it.dart' as _i1;
import 'package:go_router/go_router.dart' as _i6;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i7;
import 'package:logger/logger.dart' as _i9;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final thirdPartyModule = _$ThirdPartyModule();
    final apiModule = _$ApiModule();
    gh.singleton<_i3.Config>(_i3.Config());
    gh.factory<_i4.DetailCubit>(() => _i4.DetailCubit());
    await gh.singletonAsync<_i5.DeviceInfoProvider>(
      () {
        final i = _i5.DeviceInfoProvider();
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.factory<_i6.GoRouter>(() => thirdPartyModule.router);
    gh.factory<_i7.InternetConnectionChecker>(
        () => thirdPartyModule.connectionChecker);
    gh.factory<_i8.JsonResponseInterceptor>(
        () => _i8.JsonResponseInterceptor());
    gh.factory<_i9.Logger>(() => thirdPartyModule.logger);
    gh.factory<_i10.LoggerInterceptor>(
        () => _i10.LoggerInterceptor(logger: gh<_i9.Logger>()));
    gh.singleton<_i11.RequestIdProvider>(_i11.RequestIdProvider());
    gh.factory<_i11.BaseInterceptor>(() => _i11.BaseInterceptor(
          deviceInfoProvider: gh<_i12.DeviceInfoProvider>(),
          requestIdProvider: gh<_i11.RequestIdProvider>(),
        ));
    gh.factory<_i13.Dio>(
      () => apiModule.cdn(
        gh<_i12.Config>(),
        gh<_i12.LoggerInterceptor>(),
      ),
      instanceName: 'cdn',
    );
    gh.factory<_i14.ErrorInterceptor>(() => _i14.ErrorInterceptor(
        connectionChecker: gh<_i7.InternetConnectionChecker>()));
    gh.factory<_i13.Dio>(() => apiModule.dio(
          gh<_i12.Config>(),
          gh<_i12.BaseInterceptor>(),
          gh<_i12.LoggerInterceptor>(),
          gh<_i12.ErrorInterceptor>(),
          gh<_i12.JsonResponseInterceptor>(),
        ));
    gh.factory<_i15.CharactersApi>(() => _i15.CharactersApi(gh<_i13.Dio>()));
    gh.factory<_i16.CharactersService>(
        () => _i16.CharactersService(charactersApi: gh<_i12.CharactersApi>()));
    gh.factory<_i17.HomeCubit>(
        () => _i17.HomeCubit(charactersService: gh<_i12.CharactersService>()));
    return this;
  }
}

class _$ApiModule extends _i18.ApiModule {}

class _$ThirdPartyModule extends _i19.ThirdPartyModule {}
