import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_event_usecase.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_screen_view_usecase.dart';

mixin AnalyticsMixin<T extends StatefulWidget> on State<T> {
  late final LogScreenViewUseCase _logScreenViewUseCase;

  String get screenName;
  String get screenClass => runtimeType.toString();

  @override
  void initState() {
    super.initState();
    _logScreenViewUseCase = Modular.get<LogScreenViewUseCase>();
    _logScreenView();
  }

  Future<void> _logScreenView() async {
    await _logScreenViewUseCase(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  Future<void> logCustomEvent(
    String eventName,
    Map<String, dynamic> params,
  ) async {
    final useCase = Modular.get<LogEventUseCase>();
    await useCase(eventName: eventName, parameters: params);
  }
}
