## Cached Repository

Implementation of Google's NetworkBoundResource for Flutter apps.

## Usage

```dart
class AccountRepository {
  AccountRepository(AccountApi accountApi)
      // Persistent (uses Hive to store data)
      : _cachedRepo = CachedRepository.persistent(
          'account',
          fetch: (key, [__]) => accountApi.getAccount(),
          decode: (json) => AccountResponse.fromJson(json),
          cacheDuration: const Duration(minutes: 15),
        );

      // Persistent (uses flutter_secure_storage to store data)
      //: _cachedRepo = CachedRepository.secureStorage(
      //    'account',
      //    fetch: (key, [__]) => accountApi.getAccount(),
      //    decode: (json) => AccountResponse.fromJson(json),
      //    cacheDuration: const Duration(minutes: 15),
      //  );

      // In memory
      //: _cachedRepo = CachedRepository.inMemory(
      //    'account',
      //    fetch: (key, [__]) => accountApi.getAccount(),
      //    cacheDuration: const Duration(minutes: 15),
      //  );

  final CachedRepository<String, AccountResponse> _cachedRepo;

  Stream<Resource<AccountResponse>> getAccountStream(
    String msisdn, {
    bool forceReload = false,
  }) =>
      _cachedRepo.stream(msisdn, forceReload: forceReload);

  Future<void> invalidate(String msisdn) => _cachedRepo.invalidate(msisdn);

  Future<void> clear() => _cachedRepo.clear();
}

```
And then, you can subscribe to get updates of resource.

repository.getAccountStream(msisdn).listen((res) {
// work with resource
});

// Do something

repository.invalidate(msisdn); // reload
```

### Authors

- [drstranges](https://github.com/drstranges)
- [NaikSoftware](https://github.com/NaikSoftware)
- [MagTuxGit](https://github.com/MagTuxGit)
