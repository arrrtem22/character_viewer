// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:character_viewer/common/common.dart' as _i11;
import 'package:character_viewer/common/constant/config.dart' as _i3;
import 'package:character_viewer/common/injection/api_module.dart' as _i19;
import 'package:character_viewer/common/injection/third_party_module.dart'
    as _i20;
import 'package:character_viewer/common/network/api/characters_api.dart'
    as _i14;
import 'package:character_viewer/common/network/interceptor/base_interceptor.dart'
    as _i10;
import 'package:character_viewer/common/network/interceptor/error_interceptor.dart'
    as _i13;
import 'package:character_viewer/common/network/interceptor/json_response_interceptor.dart'
    as _i7;
import 'package:character_viewer/common/network/interceptor/logger_interceptor.dart'
    as _i9;
import 'package:character_viewer/common/repository/characters_repository.dart'
    as _i15;
import 'package:character_viewer/common/service/characters_service.dart'
    as _i16;
import 'package:character_viewer/common/service/device_info.dart' as _i4;
import 'package:character_viewer/feature/add_character/cubit/add_character_cubit.dart'
    as _i18;
import 'package:character_viewer/feature/home/cubit/home_cubit.dart' as _i17;
import 'package:dio/dio.dart' as _i12;
import 'package:get_it/get_it.dart' as _i1;
import 'package:go_router/go_router.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i6;
import 'package:logger/logger.dart' as _i8;

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
    await gh.singletonAsync<_i4.DeviceInfoProvider>(
      () {
        final i = _i4.DeviceInfoProvider();
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.factory<_i5.GoRouter>(() => thirdPartyModule.router);
    gh.factory<_i6.InternetConnectionChecker>(
        () => thirdPartyModule.connectionChecker);
    gh.factory<_i7.JsonResponseInterceptor>(
        () => _i7.JsonResponseInterceptor());
    gh.factory<_i8.Logger>(() => thirdPartyModule.logger);
    gh.factory<_i9.LoggerInterceptor>(
        () => _i9.LoggerInterceptor(logger: gh<_i8.Logger>()));
    gh.singleton<_i10.RequestIdProvider>(_i10.RequestIdProvider());
    gh.factory<_i10.BaseInterceptor>(() => _i10.BaseInterceptor(
          deviceInfoProvider: gh<_i11.DeviceInfoProvider>(),
          requestIdProvider: gh<_i10.RequestIdProvider>(),
        ));
    gh.factory<_i12.Dio>(
      () => apiModule.cdn(
        gh<_i11.Config>(),
        gh<_i11.LoggerInterceptor>(),
      ),
      instanceName: 'cdn',
    );
    gh.factory<_i13.ErrorInterceptor>(() => _i13.ErrorInterceptor(
        connectionChecker: gh<_i6.InternetConnectionChecker>()));
    gh.factory<_i12.Dio>(() => apiModule.dio(
          gh<_i11.Config>(),
          gh<_i11.BaseInterceptor>(),
          gh<_i11.LoggerInterceptor>(),
          gh<_i11.ErrorInterceptor>(),
          gh<_i11.JsonResponseInterceptor>(),
        ));
    gh.singleton<_i14.CharactersApi>(_i14.CharactersApi(gh<_i12.Dio>()));
    gh.singleton<_i15.CharactersRepository>(
        _i15.CharactersRepository(gh<_i11.CharactersApi>()));
    gh.factory<_i16.CharactersService>(() => _i16.CharactersService(
          charactersRepository: gh<_i11.CharactersRepository>(),
          charactersApi: gh<_i11.CharactersApi>(),
        ));
    gh.factory<_i17.HomeCubit>(
        () => _i17.HomeCubit(charactersService: gh<_i11.CharactersService>()));
    gh.factory<_i18.AddCharacterCubit>(
        () => _i18.AddCharacterCubit(gh<_i11.CharactersService>()));
    return this;
  }
}

class _$ApiModule extends _i19.ApiModule {}

class _$ThirdPartyModule extends _i20.ThirdPartyModule {}
