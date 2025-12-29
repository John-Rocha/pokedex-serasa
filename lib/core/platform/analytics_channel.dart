abstract class AnalyticsChannel {
  Future<void> logEvent({
    required String eventName,
    required Map<String, dynamic> parameters,
  });

  Future<void> logScreenView({
    required String screenName,
    required String screenClass,
  });

  Future<bool> isAnalyticsEnabled();
  Future<void> setAnalyticsEnabled(bool enabled);
}
