import 'package:injectable/injectable.dart';

enum _Environment {
  simpsons(
    'simpsons',
    // usually only the baseUrl changes, not query parameters
    endpoint: 'http://api.duckduckgo.com/?q=simpsons+characters&format=json',
    // we can add this line if cdnUrl is different for each env
    // cdnUrl: 'https://duckduckgo.com',
  ),
  wire(
    'wire',
    endpoint: 'http://api.duckduckgo.com/?q=the+wire+characters&format=json',
    // cdnUrl: 'https://duckduckgo.com',
  );

  final String env;
  final String endpoint;

  const _Environment(
    this.env, {
    required this.endpoint,
  });

  factory _Environment.forEnv(String envString) {
    final env = envString.toLowerCase();
    return _Environment.values.firstWhere(
      (it) => it.env == env,
      orElse: () => _Environment.simpsons,
    );
  }
}

@singleton
class Config {
  static const isNotPublicBuild = !isPublicBuild;
  static const isPublicBuild =
      bool.fromEnvironment('PUBLIC_BUILD', defaultValue: true);

  static final _env = _Environment.forEnv(const String.fromEnvironment('ENV'));

  Uri get endpoint => Uri.parse(_env.endpoint);

  Uri get cdnUrl => Uri.parse('https://duckduckgo.com');

  String get queryParams => _env.endpoint;
}
