import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/force_update/force_update_service.dart';
import '../../../../core/url_launcher/url_launcher_service.dart';
import 'force_update_event.dart';
import 'force_update_state.dart';

class ForceUpdateBloc extends Bloc<ForceUpdateEvent, ForceUpdateState> {
  ForceUpdateBloc({
    required ForceUpdateService forceUpdateService,
    required UrlLauncherService urlLauncherService,
  })  : _forceUpdateService = forceUpdateService,
        _urlLauncherService = urlLauncherService,
        super(const ForceUpdateState()) {
    on<ForceUpdateOpenStoreRequested>(_onOpenStoreRequested);
  }

  final ForceUpdateService _forceUpdateService;
  final UrlLauncherService _urlLauncherService;

  Future<void> _onOpenStoreRequested(
    ForceUpdateOpenStoreRequested event,
    Emitter<ForceUpdateState> emit,
  ) async {
    try {
      final url = _forceUpdateService.getStoreUrl();
      if (url.isEmpty) {
        emit(state.copyWith(
          status: ForceUpdateStatus.openFailed,
          openStoreError: 'Store link not available',
        ));
        return;
      }
      final launched = await _urlLauncherService.openUrl(url);
      if (!launched) {
        emit(state.copyWith(
          status: ForceUpdateStatus.openFailed,
          openStoreError: 'Could not open store',
        ));
      }
    } catch (e, _) {
      emit(state.copyWith(
        status: ForceUpdateStatus.openFailed,
        openStoreError: e.toString(),
      ));
    }
  }
}
